import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/common/consts/sizes.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class Alarm extends StatefulWidget {
  final String maType;
  final String time;
  final List<String> repeatDays;
  final bool isDisabled;

  const Alarm({
    super.key,
    required this.maType,
    required this.time,
    required this.repeatDays,
    required this.isDisabled,
  });

  @override
  State<Alarm> createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {
  bool _isDisabled = false;

  void onChanged(value) {
    setState(() {
      _isDisabled = value;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _isDisabled = widget.isDisabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(widget.maType, style: TextStyle(fontSize: Sizes.size18)),
                Gaps.h8,
                Text(widget.time, style: TextStyle(fontSize: Sizes.size32)),
              ],
            ),
            Row(
              children: [
                ...widget.repeatDays.mapIndexed(
                  (idx, r) => Text(
                    '$r${idx == widget.repeatDays.length - 1 ? '' : ', '}',
                    style: TextStyle(fontSize: Sizes.size14),
                  ),
                ),
              ],
            ),
          ],
        ),
        Switch(value: _isDisabled, onChanged: (value) => onChanged(value)),
      ],
    );
  }
}
