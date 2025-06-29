import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlarmDatePicker extends StatefulWidget {
  final DateTime selectedDateTime;
  final Function(DateTime newDateTime) changeDate;

  const AlarmDatePicker({
    super.key,
    required this.selectedDateTime,
    required this.changeDate,
  });

  @override
  State<AlarmDatePicker> createState() => _AlarmDatePickerState();
}

class _AlarmDatePickerState extends State<AlarmDatePicker> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getWinHeight(context) * 0.3,
      child: CupertinoTheme(
        data: CupertinoThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.white,
        ),
        child: CupertinoDatePicker(
          initialDateTime: widget.selectedDateTime,
          mode: CupertinoDatePickerMode.time,
          use24hFormat: false,
          onDateTimeChanged: widget.changeDate,
          itemExtent: 47,
        ),
      ),
    );
  }
}
