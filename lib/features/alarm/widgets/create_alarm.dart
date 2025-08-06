import 'package:alarmi/common/configs/notification_controller.dart';
import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/common/consts/raw_data/weekdays.dart';
import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/common/vms/global_view_model.dart';
import 'package:alarmi/common/widgets/cst_part_loading.dart';
import 'package:alarmi/features/alarm/models/alarm_params.dart';
import 'package:alarmi/features/alarm/models/weekday.dart';
import 'package:alarmi/features/alarm/services/alarm_notifier.dart';
import 'package:alarmi/features/main/screens/main_screen.dart';
import 'package:alarmi/utils/date_utils.dart';
import 'package:alarmi/utils/toast_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'alarm_date_picker.dart';
import 'alarm_settings.dart';

class CreateAlarm extends ConsumerStatefulWidget {
  final String type;
  final String? alarmId;
  final VoidCallback? onSave;

  const CreateAlarm({super.key, required this.type, this.alarmId, this.onSave});

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
  List<int>? _alarmKeys;

  @override
  void initState() {
    super.initState();
    _initializeAlarmData();
    // 부모 위젯의 onSave 콜백에 이 위젯의 _save 함수 할당
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.onSave != null) {
        widget.onSave!();
      }
    });
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
              _alarmKeys = initialParams.alarmKeys;
            } else {
              // 해당 ID의 알람이 없는 경우 기본값으로 초기화
              _selectedDateTime = now;
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
            _selectedDateTime = now;
            _isLoading = false;
          });
          callToast(context, '유효하지 않은 알람 ID입니다.');
        }
      }
    } else {
      // alarmId가 없는 경우 (새 알람 생성)
      if (mounted) {
        setState(() {
          _selectedDateTime = now;
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

  bool isValidParams(AlarmParams params) {
    bool isValid = true;
    String msg = '';

    if (params.bellId == null && params.vibrateId == null) {
      msg = '알람음 또는 진동을 설정해주세요.';
      isValid = false;
    } else if (params.weekdays.isEmpty) {
      msg = '요일을 지정해주세요.';
      isValid = false;
    }

    if (!isValid) {
      callToast(
        context,
        msg,
        icon: Icon(
          Icons.error,
          color: Theme.of(context).colorScheme.error,
          size: 24,
        ),
      );
    }

    return isValid;
  }

  void _save() async {
    bool isCreate = _currentAlarmDbId == null;
    bool isSuccess = false;
    final AlarmListNotifier alarmNotifier = ref.read(
      alarmListProvider('my').notifier,
    );

    AlarmParams params = await _setParams();
    if (!isValidParams(params)) return;
    debugPrint(params.toString());

    if (!isCreate) {
      isSuccess = await alarmNotifier.updateAlarm(params.toJson(), widget.type);
      if (isSuccess) {
        NotificationController.stopScheduledAlarm(_alarmKeys!); // 이전 알람 제거
      }
    } else {
      int? id = await alarmNotifier.insertAlarm(params: params);
      isSuccess = id != 0;
    }

    if (mounted) {
      if (isSuccess) {
        callToast(context, '알람이 ${isCreate ? '등록' : '저장'}되었습니다.');
        context.go('${MainScreen.routeURL}/null');
      } else {
        callToast(context, '알람 ${isCreate ? '등록' : '저장'}에 실패했습니다.');
      }
    }
  }

  void saveAlarm() {
    _save(); // 실제 저장 로직 호출
  }

  Future<AlarmParams> _setParams() async {
    List<int> alarmKeys = [];
    List<int> selectedWeekdays =
        _weekdays.where((w) => w.isSelected == true).map((w) => w.id).toList();

    alarmKeys = await NotificationController.setWeeklyAlarm(
      weekdays: selectedWeekdays,
      dateTime: _selectedDateTime,
      bellId: _bellId,
      vibrateId: _vibrateId,
      isWakeUpMission: _isActivatedWakeUpMission,
    );

    return AlarmParams(
      id: _currentAlarmDbId,
      alarmKeys: alarmKeys,
      weekdays: selectedWeekdays,
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
    final isEvening = ref.watch(
      globalViewProvider.select((state) => state.isEvening),
    );

    if (_isLoading) {
      return CstPartLoading();
    }

    return Column(
      children: [
        Gaps.v96,
        widget.alarmId != null ? Gaps.v24 : Gaps.v32,
        AlarmDatePicker(
          selectedDateTime: _selectedDateTime,
          changeDate: changeDate,
        ),
        widget.alarmId != null ? Gaps.v24 : Gaps.v32,
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
        // 최종 기획에서 삭제
        if (widget.alarmId != null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              onPressed: () async {
                try {
                  final alarmNotifier = ref.read(
                    alarmListProvider(widget.type).notifier,
                  );

                  await alarmNotifier.deleteAlarm(
                    int.parse(widget.alarmId!),
                    widget.type,
                  );

                  callToast(
                    context,
                    '알람이 삭제되었습니다.',
                    icon: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.check, color: Colors.white, size: 16),
                    ),
                  );

                  context.pop(); // 뒤로 가기
                } catch (e) {
                  callToast(context, '알람 삭제가 실패했습니다.');
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Color(0xFFFF5F5F),
                backgroundColor:
                    isEvening ? Color(0xFF272C4F) : Color(0xFF206391),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: Sizes.size14),
                child: Center(
                  child: Text(
                    '알람 삭제',
                    style: TextStyle(
                      fontSize: Sizes.size16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        Gaps.v32,
      ],
    );
  }
}
