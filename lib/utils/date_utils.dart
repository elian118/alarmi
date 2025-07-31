import 'package:intl/intl.dart';

String formatDate(String dateString, String format) {
  DateTime dateTime = DateTime.parse(dateString);
  String formattedDateString = DateFormat(format).format(dateTime);
  return formattedDateString;
}

String dtFormStr(DateTime dt, String format) => DateFormat(format).format(dt);

String formatTimeToAmPm(String time24hr) {
  final DateTime dateTime = DateFormat('HH:mm:ss').parse(time24hr);
  final String formattedTime = DateFormat('a hh:mm', 'ko_KR').format(dateTime);
  return formattedTime;
}

DateTime getWakeUpTimeFromAlarm(String alarmTime) {
  DateTime now = DateTime.now();
  List<String> timeParts = alarmTime.split(':');

  int hour = int.parse(timeParts[0]);
  int minute = int.parse(timeParts[1]);
  int second = int.parse(timeParts[2]);

  return DateTime(now.year, now.month, now.day, hour, minute, second);
}

String getHourCategory() {
  final now = DateTime.now();
  final currentHour = now.hour;

  return currentHour >= 6 && currentHour < 12
      ? 'good_morning'
      : currentHour >= 12 && currentHour < 20
      ? 'good_afternoon'
      : 'good_evening';
}

bool isEvening() {
  DateTime now = DateTime.now();
  return !(now.hour >= 6 && now.hour < 18);
}
