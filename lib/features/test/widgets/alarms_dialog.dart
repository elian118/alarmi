import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class AlarmsDialog extends StatelessWidget {
  final List<NotificationModel> scheduledNotifications;

  const AlarmsDialog({super.key, required this.scheduledNotifications});

  @override
  Widget build(BuildContext context) {
    String _getWeekdayName(int weekday) {
      switch (weekday) {
        case DateTime.monday:
          return '월요일';
        case DateTime.tuesday:
          return '화요일';
        case DateTime.wednesday:
          return '수요일';
        case DateTime.thursday:
          return '목요일';
        case DateTime.friday:
          return '금요일';
        case DateTime.saturday:
          return '토요일';
        case DateTime.sunday:
          return '일요일';
        default:
          return '알 수 없음';
      }
    }

    return AlertDialog(
      title: const Text('설정된 알람 목록'),
      content: SingleChildScrollView(
        child: ListBody(
          children:
              scheduledNotifications.map((notification) {
                String scheduleInfo = '반복 없음';
                if (notification.schedule is NotificationCalendar) {
                  final calendar =
                      notification.schedule as NotificationCalendar;
                  scheduleInfo =
                      '매주 ${_getWeekdayName(calendar.weekday!)} ${calendar.hour!}:${calendar.minute}';
                } else if (notification.schedule is NotificationInterval) {
                  final interval =
                      notification.schedule as NotificationInterval;
                  scheduleInfo = '매 ${interval.interval}초마다 반복'; // 예시
                }
                return Text(
                  'ID: ${notification.content!.id}, 제목: ${notification.content!.title}\n스케줄: $scheduleInfo\n',
                );
              }).toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('닫기'),
        ),
      ],
    );
  }
}
