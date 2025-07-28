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
          primaryColor: Colors.white,
          textTheme: CupertinoTextThemeData(
            pickerTextStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
            dateTimePickerTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        child: Stack(
          children: [
            CupertinoDatePicker(
              initialDateTime: widget.selectedDateTime,
              mode: CupertinoDatePickerMode.time,
              use24hFormat: false,
              onDateTimeChanged: widget.changeDate,
              itemExtent: 50,
              backgroundColor: Colors.transparent,
            ),
            Positioned(
              top: (getWinHeight(context) * 0.3 / 2) - (45 / 2) - 1, // 중앙선 위쪽으로
              left: 0,
              right: 0,
              child: Container(
                height: 0.67,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
            // 선택 영역의 아래쪽 선
            Positioned(
              top: (getWinHeight(context) * 0.3 / 2) + (45 / 2), // 중앙선 아래쪽으로
              left: 0,
              right: 0,
              child: Container(
                height: 0.67,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
