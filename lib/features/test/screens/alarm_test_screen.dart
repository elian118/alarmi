import 'dart:math';

import 'package:alarmi/common/configs/notification_controller.dart';
import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/common/consts/raw_data/bells.dart';
import 'package:alarmi/common/consts/raw_data/haptic_patterns.dart';
import 'package:alarmi/common/widgets/cst_divider.dart';
import 'package:alarmi/features/missions/screens/shaking_clams_screen.dart';
import 'package:alarmi/features/onboarding/screens/onboard_screen.dart';
import 'package:alarmi/features/test/widgets/alarms_dialog.dart';
import 'package:alarmi/utils/toast_utils.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AlarmTestScreen extends StatelessWidget {
  static const String routeName = 'alarm-test';
  static const String routeURL = '/alarm-test';
  static const int delay = 5;

  const AlarmTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Alarm test")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                Random random = Random();
                int randomBellIdx = random.nextInt(bells.length - 1);
                int hapticPatternIdx = random.nextInt(
                  hapticPatterns.length - 1,
                );
                debugPrint('soundFile: ${bells[randomBellIdx].path}');
                debugPrint(
                  'hapticPatternId: ${hapticPatterns[hapticPatternIdx].id}',
                );

                await NotificationController.setTestWeeklyAlarm(
                  bellId: bells[randomBellIdx].id,
                  vibrateId: hapticPatterns[hapticPatternIdx].id,
                  isWakeUpMission: true,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('주기적 테스트 알람이 설정되었습니다.')),
                );
              },
              child: const Text('기상 알람 설정'),
            ),
            Gaps.v20,
            ElevatedButton(
              onPressed: () async {
                await NotificationController.stopTestAlarms();
                callSimpleToast('모든 테스트 알람이 취소되었습니다.');
              },
              child: const Text('재생 중지'),
            ),
            Gaps.v20,
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
            Gaps.v20,
            ElevatedButton(
              onPressed: () async {
                await NotificationController.stopTestAlarms();
                await AwesomeNotifications().cancelAll();
                callSimpleToast('캐싱된 알람이 모두 삭제되었습니다.');
              },
              child: const Text('캐싱 알람 모두 삭제'),
            ),
            Gaps.v20,
            CstDivider(thickness: 10, width: 120),
            Gaps.v20,
            ElevatedButton(
              onPressed: () {
                context.push(ShakingClamsScreen.routeURL);
              },
              child: const Text('조개 흔들기로 이동'),
            ),
            Gaps.v20,
            ElevatedButton(
              onPressed: () {
                context.push(OnboardScreen.routeURL);
              },
              child: const Text('온보딩으로 이동'),
            ),
          ],
        ),
      ),
    );
  }
}
