import 'package:alarm/alarm.dart';
import 'package:alarmi/common/configs/alarmSettings.dart';
import 'package:alarmi/common/configs/local_notification_configs.dart';
import 'package:alarmi/common/widgets/cst_divider.dart';
import 'package:flutter/material.dart';

class AlarmTestScreen extends StatelessWidget {
  static const String routeName = 'alarm-test';
  static const String routeURL = '/alarm-test';
  static const int delay = 5;

  const AlarmTestScreen({super.key});

  void onTabAlarmSet(BuildContext context, int delay) async {
    // 현재 시간 + 5초 후에 알람 설정
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
      now.second + delay, // 5초 후
    );

    await Alarm.set(alarmSettings: getAlarmSettings(dateTime));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('알람 설정됨: ${dateTime.toLocal()}')));
  }

  void onTabStopAlarm(BuildContext context) async {
    await Alarm.stop(42); // ID로 알람 중지
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('알람 중지됨')));
  }

  void onTabGetAlarmCounts(BuildContext context) async {
    final alarms = await Alarm.getAlarms();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('현재 설정된 알람 수: ${alarms.length}')));
  }

  void onTabGeneralNoti() {
    LocalNotificationService.showSimpleNotification(
      // <-- static 메서드 호출
      id: 0,
      title: '간단 알림',
      body: '이것은 일반적인 알림입니다.',
      payload: 'simple_notification_data',
    );
  }

  void onTabIOSNotiWithBtn() {
    LocalNotificationService.showNotificationWithActions(
      // <-- static 메서드 호출
      id: 1,
      title: '액션 알림',
      body: '이 알림에는 버튼이 있습니다. iOS에서 확인하세요.',
      payload: 'action_notification_data',
    );
  }

  void onTabScheduledNoti(BuildContext context) async {
    final scheduledDate = DateTime.now().add(const Duration(seconds: delay));
    await LocalNotificationService.scheduleNotification(
      id: 2,
      title: '예약 알림',
      body: '$delay초 뒤에 나타나는 알림입니다.',
      scheduledDate: scheduledDate,
      payload: 'scheduled_notification_data',
    );
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$delay초 후 알림이 예약되었습니다.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Alarm test")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => onTabAlarmSet(context, delay),
              child: const Text('알람 설정 ($delay)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => onTabStopAlarm(context),
              child: const Text('알람 중지'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => onTabGetAlarmCounts(context),
              child: const Text('설정된 알람 확인'),
            ),
            CstDivider(width: 100, thickness: 10),
            // 일반 알림 보내기 버튼
            ElevatedButton(
              onPressed: onTabGeneralNoti,
              child: const Text('일반 알림 보내기'),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: onTabIOSNotiWithBtn,
              child: const Text('액션 버튼 알림 보내기 (iOS)'),
            ),
            const SizedBox(height: 20),

            // 예약 알림 버튼
            ElevatedButton(
              onPressed: () => onTabScheduledNoti(context),
              child: const Text('$delay초 후 예약 알림 보내기'),
            ),
          ],
        ),
      ),
    );
  }
}
