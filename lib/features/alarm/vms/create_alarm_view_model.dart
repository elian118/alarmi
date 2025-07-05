import 'package:alarmi/common/configs/notification_controller.dart';
import 'package:alarmi/features/alarm/models/alarm_params.dart';
import 'package:alarmi/features/alarm/models/create_alarm_state.dart';
import 'package:alarmi/features/alarm/models/weekday.dart';
import 'package:alarmi/features/alarm/screens/alarms_screen.dart';
import 'package:alarmi/features/alarm/services/alarm_service.dart';
import 'package:alarmi/utils/date_utils.dart';
import 'package:alarmi/utils/toast_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateAlarmViewModel extends Notifier<CreateAlarmState> {
  @override
  CreateAlarmState build() {
    return CreateAlarmState();
  }

  void changeDate(DateTime newDateTime) {
    state = state.copyWith(selectedDateTime: newDateTime);
  }

  // void onChangeSelectedBellId(String? newId) {
  //   state = state.copyWith(bellId: newId);
  // }

  void onSaveBellSettings(String? bellId, double volume) {
    state = state.copyWith(bellId: bellId, selectedBellVolume: volume);
  }

  // void onChangeSelectedVibrateId(String? newId) {
  //   state = state.copyWith(vibrateId: newId);
  // }

  void onSaveVibrateSettings(String? patternId) {
    state = state.copyWith(vibrateId: patternId);
  }

  void toggleWakeUpMission() {
    state = state.copyWith(
      isActivatedWakeUpMission: !state.isActivatedWakeUpMission,
    );
  }

  void toggleActivatedVibrate() {
    state = state.copyWith(isActivatedVibrate: !state.isActivatedVibrate);
  }

  void toggleIsAllDay(bool? value) {
    final bool newIsAllDay = value ?? !state.isAllDay; // 실제 토글될 값
    final List<Weekday> updatedWeekdays =
        state
            .selectedWeekdays // <-- List<Weekday>로 사용
            .map((day) => day.copyWith(isSelected: newIsAllDay))
            .toList();

    state = state.copyWith(
      isAllDay: newIsAllDay,
      selectedWeekdays: updatedWeekdays, // <-- weekDays 대신 selectedWeekdays 사용
    );
  }

  void onWeekdaySelected(int idx, bool value) {
    final List<Weekday> updatedWeekdays = List.from(state.selectedWeekdays);
    updatedWeekdays[idx] = updatedWeekdays[idx].copyWith(isSelected: value);

    final bool newIsAllDay = updatedWeekdays.every((day) => day.isSelected);

    state = state.copyWith(
      selectedWeekdays: updatedWeekdays,
      isAllDay: newIsAllDay,
    );
  }

  Future<void> saveAlarm(BuildContext context) async {
    final AlarmService alarmService = AlarmService.getInstance();

    List<int> alarmKeys = [];
    List<int> selectedWeekdayIds =
        state.selectedWeekdays
            .where((w) => w.isSelected == true)
            .map((w) => w.id) // Weekday 모델의 id 사용
            .toList();

    try {
      alarmKeys = await NotificationController.setWeeklyAlarm(
        weekdays: selectedWeekdayIds,
        dateTime: state.selectedDateTime,
        bellId: state.bellId,
        vibrateId: state.vibrateId,
      );

      final AlarmParams params = AlarmParams(
        alarmKeys: alarmKeys,
        weekdays: selectedWeekdayIds,
        bellId: state.bellId,
        vibrateId: state.vibrateId,
        alarmTime: dtFormStr(state.selectedDateTime, 'HH:mm:ss'),
        register: 'me',
        isWakeUpMission: state.isActivatedWakeUpMission ? 1 : 0,
        type: 'my',
      );

      if (kDebugMode) {
        print(params.toString());
      }

      int? id = await alarmService.insertAlarm(params: params);

      if (id != null) {
        callSimpleToast('알람이 등록되었습니다.');
        context.go(AlarmsScreen.routeURL);
      } else {
        callSimpleToast('알람 등록에 실패했습니다.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('알람 저장 중 오류 발생: $e');
      }
      callSimpleToast('알람 저장 중 오류가 발생했습니다.');
    }
  }
}

final createAlarmProvider =
    NotifierProvider<CreateAlarmViewModel, CreateAlarmState>(
      () => CreateAlarmViewModel(),
    );
