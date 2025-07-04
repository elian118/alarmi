import 'dart:math';

import 'package:alarmi/common/configs/notification_controller.dart';
import 'package:alarmi/common/consts/raw_data/bells.dart';
import 'package:alarmi/features/test/widgets/alarms_dialog.dart';
import 'package:alarmi/utils/toast_utils.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AlarmTestScreen extends StatelessWidget {
  static const String routeName = 'alarm-test';
  static const String routeURL = '/alarm-test';
  static const int delay = 5;

  const AlarmTestScreen({super.key});

  // void onTabAlarmSet(BuildContext context, int delay) async {
  //   // 현재 시간 + 5초 후에 알람 설정
  //   final now = DateTime.now();
  //   final dateTime = DateTime(
  //     now.year,
  //     now.month,
  //     now.day,
  //     now.hour,
  //     now.minute,
  //     now.second + delay, // 5초 후
  //   );
  //
  //   await Alarm.set(
  //     alarmSettings: setAlarmSettings(
  //       dateTime,
  //       0.8,
  //       'assets/audios/default/test.mp3',
  //     ),
  //   );
  //   ScaffoldMessenger.of(
  //     context,
  //   ).showSnackBar(SnackBar(content: Text('알람 설정됨: ${dateTime.toLocal()}')));
  // }
  //
  // void onTabStopAlarm(BuildContext context) async {
  //   await Alarm.stop(42); // ID로 알람 중지
  //   ScaffoldMessenger.of(
  //     context,
  //   ).showSnackBar(const SnackBar(content: Text('알람 중지됨')));
  // }
  //
  // void onTabGetAlarmCounts(BuildContext context) async {
  //   final alarms = await Alarm.getAlarms();
  //   ScaffoldMessenger.of(
  //     context,
  //   ).showSnackBar(SnackBar(content: Text('현재 설정된 알람 수: ${alarms.length}')));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Alarm test")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ElevatedButton(
            //   onPressed: () => onTabAlarmSet(context, delay),
            //   child: const Text('알람 설정 ($delay)'),
            // ),
            // const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () => onTabStopAlarm(context),
            //   child: const Text('알람 중지'),
            // ),
            // const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () => onTabGetAlarmCounts(context),
            //   child: const Text('설정된 알람 확인'),
            // ),
            // Gaps.v24,
            // CstDivider(width: 100, thickness: 10),
            // Gaps.v24,
            ElevatedButton(
              onPressed: () async {
                Random random = Random();
                int randomBellIdx = random.nextInt(bells.length);
                if (kDebugMode) {
                  print('soundFilePath: ${bells[randomBellIdx].path}');
                }

                await NotificationController.setTestWeeklyAlarm(
                  soundAssetPath: bells[randomBellIdx].path,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('주기적 테스트 알람이 설정되었습니다.')),
                );
              },
              child: const Text('기상 알람 설정'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await AwesomeNotifications().cancelAll(); // 모든 알림 취소
                await NotificationController.stopAlarmSound(); // 혹시 재생 중인 사운드가 있다면 중지
                callSimpleToast('모든 알람이 취소되었습니다.');
              },
              child: const Text('모든 알람 삭제'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final List<NotificationModel> scheduledNotifications =
                    await AwesomeNotifications().listScheduledNotifications();

                if (scheduledNotifications.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('설정된 알람 없음'),
                        content: const Text('현재 설정된 알람이 없습니다.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('확인'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlarmsDialog(
                        scheduledNotifications: scheduledNotifications,
                      );
                    },
                  );
                }
              },
              child: const Text('설정된 알람 확인'),
            ),
          ],
        ),
      ),
    );
  }
}
