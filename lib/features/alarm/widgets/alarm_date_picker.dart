import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/cupertino.dart';

class AlarmDatePicker extends StatefulWidget {
  const AlarmDatePicker({super.key});

  @override
  State<AlarmDatePicker> createState() => _AlarmDatePickerState();
}

class _AlarmDatePickerState extends State<AlarmDatePicker> {
  DateTime _selectedDateTime = DateTime.now();

  void changeDate(DateTime newDateTime) {
    setState(() {
      _selectedDateTime = newDateTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getWinHeight(context) * 0.3,
      child: CupertinoDatePicker(
        initialDateTime: _selectedDateTime,
        mode: CupertinoDatePickerMode.dateAndTime,
        use24hFormat: false,
        onDateTimeChanged: changeDate,
      ),
    );
  }
}
