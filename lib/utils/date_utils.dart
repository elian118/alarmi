import 'package:intl/intl.dart';

String formatDate(String dateString, String format) {
  DateTime dateTime = DateTime.parse(dateString);
  String formattedDateString = DateFormat(format).format(dateTime);
  return formattedDateString;
}
