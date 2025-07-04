import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/common/consts/raw_data/weekdays.dart';
import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/features/alarm/models/alarm_params.dart';
import 'package:alarmi/features/alarm/models/weekday.dart';
import 'package:alarmi/utils/date_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'alarm_date_picker.dart';
import 'alarm_settings.dart';

class CreateAlarm extends StatefulWidget {
  const CreateAlarm({super.key});

  @override
  State<CreateAlarm> createState() => _CreateAlarmState();
}

class _CreateAlarmState extends State<CreateAlarm> {
  List<Weekday> _weekdays = weekdays;
  DateTime now = DateTime.now();
  late DateTime _selectedDateTime = DateTime(
    now.year,
    now.month,
    now.day,
    7,
    0,
    0,
  );
  String? _bellId;
  String? _vibrateId;
  bool _isActivatedVirtualMission = false;
  bool _isActivatedVibrate = false;
  bool _isAllDay = false;

  void changeDate(DateTime newDateTime) {
    setState(() {
      _selectedDateTime = newDateTime;
    });
  }

  void onChangeSelectedBellId(String? newId) {
    setState(() {
      _bellId = newId;
    });
  }

  void onChangeSelectedVibrateId(String? newId) {
    setState(() {
      _vibrateId = newId;
    });
  }

  void toggleWakeUpMission() {
    setState(() {
      _isActivatedVirtualMission = !_isActivatedVirtualMission;
    });
  }

  void toggleActivatedVibrate() {
    setState(() {
      _isActivatedVibrate = !_isActivatedVibrate;
    });
  }

  void toggleIsAllDay(bool? value) {
    if (kDebugMode) {
      print(value);
    }
    setState(() {
      _isAllDay = value ?? !_isAllDay;
      _weekdays =
          _weekdays
              .map((day) => day.copyWith(isSelected: _isAllDay == true))
              .toList();
    });
  }

  void onWeekdaySelected(int idx, bool value) {
    setState(() {
      final List<Weekday> updatedWeekdays = List.from(_weekdays);
      updatedWeekdays[idx] = updatedWeekdays[idx].copyWith(isSelected: value);

      _weekdays = updatedWeekdays;
      _isAllDay = _weekdays.every((day) => day.isSelected);
    });
  }

  void _save() {
    AlarmParams params = _setParams();
    if (kDebugMode) {
      print(params.toString());
    }
  }

  AlarmParams _setParams() {
    return AlarmParams(
      alarmKeys: [],
      weekdays:
          _weekdays
              .where((w) => w.isSelected == true)
              .map((w) => w.id)
              .toList(),
      bellId: _bellId,
      vibrateId: _vibrateId,
      alarmTime: dtFormStr(_selectedDateTime, 'HH:mm:ss'),
      register: 'me',
      isWakeUpMission: _isActivatedVirtualMission ? 1 : 0,
      type: 'my',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
            Gaps.v96,
            AlarmDatePicker(
              selectedDateTime: _selectedDateTime,
              changeDate: changeDate,
            ),
            Gaps.v16,
            AlarmSettings(
              weekdays: _weekdays,
              isActivatedVirtualMission: _isActivatedVirtualMission,
              toggleWakeUpMission: toggleWakeUpMission,
              isActivatedVibrate: _isActivatedVibrate,
              toggleActivatedVibrate: toggleActivatedVibrate,
              isAllDay: _isAllDay,
              toggleIsAllDay: toggleIsAllDay,
              onWeekdaySelected: onWeekdaySelected,
              onChangeSelectedBellId: onChangeSelectedBellId,
              onChangeSelectedVibrateId: onChangeSelectedVibrateId,
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: Sizes.size14),
                  child: Center(
                    child: Text(
                      '저장',
                      style: TextStyle(
                        fontSize: Sizes.size18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Gaps.v32,
          ]
          .animate(interval: 0.2.seconds, delay: 0.2.seconds)
          .fadeIn(begin: 0)
          .scale(duration: 600.ms, curve: Curves.easeInOut),
    );
  }
}
