import 'package:alarmi/common/configs/notification_controller.dart';
import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/common/consts/raw_data/weekdays.dart';
import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/features/alarm/models/alarm_params.dart';
import 'package:alarmi/features/alarm/models/weekday.dart';
import 'package:alarmi/features/alarm/services/alarm_notifier.dart';
import 'package:alarmi/features/main/screens/main_screen.dart';
import 'package:alarmi/utils/date_utils.dart';
import 'package:alarmi/utils/toast_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'alarm_date_picker.dart';
import 'alarm_settings.dart';

class CreateAlarm extends ConsumerStatefulWidget {
  final String type;
  final String? alarmId;

  const CreateAlarm({super.key, required this.type, this.alarmId});

  @override
  ConsumerState<CreateAlarm> createState() => _CreateAlarmState();
}

class _CreateAlarmState extends ConsumerState<CreateAlarm> {
  bool _isLoading = true;
  int? _currentAlarmDbId;

  List<Weekday> _weekdays = weekdays;
  DateTime now = DateTime.now();
  late DateTime _selectedDateTime;
  String? _bellId;
  String? _vibrateId;
  bool _isActivatedWakeUpMission = false;
  bool _isActivatedVibrate = false;
  bool _isAllDay = false;

  @override
  void initState() {
    super.initState();
    _initializeAlarmData();
  }

  Future<void> _initializeAlarmData() async {
    // alarmId가 있다면 기존 알람 데이터를 로드
    if (widget.alarmId != null) {
      final alarmNotifier = ref.read(alarmListProvider(widget.type).notifier);
      final int? parsedAlarmId = int.tryParse(widget.alarmId!);

      if (parsedAlarmId != null) {
        final AlarmParams? initialParams = await alarmNotifier.loadAlarm(
          alarmId: widget.alarmId!,
        );

        if (mounted) {
          // 위젯이 마운트된 상태인지 확인
          setState(() {
            if (initialParams != null) {
              _currentAlarmDbId = parsedAlarmId; // DB ID 저장 (업데이트 시 필요)
              _bellId = initialParams.bellId;
              _vibrateId = initialParams.vibrateId;
              _isActivatedWakeUpMission = initialParams.isWakeUpMission == 1;
              _selectedDateTime = getWakeUpTimeFromAlarm(
                initialParams.alarmTime,
              );
              _weekdays =
                  _weekdays.map((day) {
                    return day.copyWith(
                      isSelected: initialParams.weekdays.contains(day.id),
                    );
                  }).toList();
              _isAllDay = _weekdays.every((day) => day.isSelected);
            } else {
              // 해당 ID의 알람이 없는 경우 기본값으로 초기화
              _selectedDateTime = DateTime(
                now.year,
                now.month,
                now.day,
                7,
                0,
                0,
              );
              _bellId = null;
              _vibrateId = null;
              _isActivatedWakeUpMission = false;
              _isActivatedVibrate = false;
              _weekdays = weekdays;
              _isAllDay = false;
            }
            _isLoading = false;
          });
        }
      } else {
        // alarmId가 유효한 숫자가 아닌 경우
        if (mounted) {
          setState(() {
            _selectedDateTime = DateTime(now.year, now.month, now.day, 7, 0, 0);
            _isLoading = false;
          });
          callSimpleToast('유효하지 않은 알람 ID입니다.');
        }
      }
    } else {
      // alarmId가 없는 경우 (새 알람 생성)
      if (mounted) {
        setState(() {
          _selectedDateTime = DateTime(
            now.year,
            now.month,
            now.day,
            7,
            0,
            0, // 기본 시간
          );
          _isLoading = false; // 로딩 종료
        });
      }
    }
  }

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
      _isActivatedWakeUpMission = !_isActivatedWakeUpMission;
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

  void _save() async {
    final AlarmListNotifier alarmNotifier = ref.read(
      alarmListProvider('my').notifier,
    );

    AlarmParams params = await _setParams();
    if (kDebugMode) {
      print(params.toString());
    }
    int? id = await alarmNotifier.insertAlarm(params: params);

    if (mounted) {
      if (id != null) {
        callSimpleToast('알람이 등록되었습니다.');
        context.go(MainScreen.routeURL);
      } else {
        callSimpleToast('알람 등록에 실패했습니다.');
      }
    }
  }

  Future<AlarmParams> _setParams() async {
    List<int> _alarmKeys = [];
    List<int> _selectedWeekdays =
        _weekdays.where((w) => w.isSelected == true).map((w) => w.id).toList();

    _alarmKeys = await NotificationController.setWeeklyAlarm(
      weekdays: _selectedWeekdays,
      dateTime: _selectedDateTime,
      bellId: _bellId,
      vibrateId: _vibrateId,
    );

    return AlarmParams(
      alarmKeys: _alarmKeys,
      weekdays: _selectedWeekdays,
      bellId: _bellId,
      vibrateId: _vibrateId,
      alarmTime: dtFormStr(_selectedDateTime, 'HH:mm:ss'),
      register: 'me',
      isWakeUpMission: _isActivatedWakeUpMission ? 1 : 0,
      type: 'my',
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

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
              isActivatedVirtualMission: _isActivatedWakeUpMission,
              toggleWakeUpMission: toggleWakeUpMission,
              isActivatedVibrate: _isActivatedVibrate,
              toggleActivatedVibrate: toggleActivatedVibrate,
              isAllDay: _isAllDay,
              toggleIsAllDay: toggleIsAllDay,
              onWeekdaySelected: onWeekdaySelected,
              onChangeSelectedBellId: onChangeSelectedBellId,
              onChangeSelectedVibrateId: onChangeSelectedVibrateId,
              bellId: _bellId,
              vibrateId: _vibrateId,
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
