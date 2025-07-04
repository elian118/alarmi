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
