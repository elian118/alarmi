import 'package:alarm/alarm.dart';
import 'package:alarmi/common/configs/alarmSettings.dart';
import 'package:flutter/material.dart';

class AlarmTestScreen extends StatelessWidget {
  static const String routeName = 'alarm-test';
  static const String routeURL = '/alarm-test';

  const AlarmTestScreen({super.key});

  void onTabAlarmSet(BuildContext context) async {
    // 현재 시간 + 5초 후에 알람 설정
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
      now.second + 5, // 3초 후
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Alarm test")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => onTabAlarmSet(context),
              child: const Text('알람 설정 (5초 후)'),
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
          ],
        ),
      ),
    );
  }
}
