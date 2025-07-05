import 'package:alarmi/common/consts/raw_data/weekdays.dart';
import 'package:alarmi/features/alarm/models/weekday.dart';

class CreateAlarmState {
  final List<Weekday> selectedWeekdays; // <-- List<Weekday>로 유지
  final DateTime selectedDateTime;
  final bool isActivatedWakeUpMission;
  final bool isActivatedVibrate;
  final bool isAllDay;
  final String? bellId;
  final String? vibrateId;
  final double selectedBellVolume;

  DateTime now = DateTime.now();

  CreateAlarmState({
    List<Weekday>? selectedWeekdays,
    DateTime? selectedDateTime,
    this.isActivatedWakeUpMission = false,
    this.isActivatedVibrate = false,
    this.isAllDay = false,
    this.bellId,
    this.vibrateId,
    this.selectedBellVolume = 0.8,
  }) : selectedWeekdays = selectedWeekdays ?? _getDefaultWeekdays(),
       selectedDateTime = selectedDateTime ?? _getDefaultSelectedDateTime();

  static List<Weekday> _getDefaultWeekdays() => List.from(weekdays);

  static DateTime _getDefaultSelectedDateTime() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 7, 0, 0);
  }

  CreateAlarmState copyWith({
    List<Weekday>? selectedWeekdays,
    DateTime? selectedDateTime,
    bool? isActivatedWakeUpMission,
    bool? isActivatedVibrate,
    bool? isAllDay,
    String? bellId,
    String? vibrateId,
    double? selectedBellVolume,
  }) {
    return CreateAlarmState(
      selectedWeekdays: selectedWeekdays ?? this.selectedWeekdays,
      selectedDateTime: selectedDateTime ?? this.selectedDateTime,
      isActivatedWakeUpMission:
          isActivatedWakeUpMission ?? this.isActivatedWakeUpMission,
      isActivatedVibrate: isActivatedVibrate ?? this.isActivatedVibrate,
      isAllDay: isAllDay ?? this.isAllDay,
      bellId: bellId ?? this.bellId,
      vibrateId: vibrateId ?? this.vibrateId,
      selectedBellVolume: selectedBellVolume ?? this.selectedBellVolume,
    );
  }
}
