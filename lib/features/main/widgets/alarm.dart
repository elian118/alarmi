import 'package:alarmi/common/configs/notification_controller.dart';
import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/common/consts/raw_data/weekdays.dart';
import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/common/vms/global_view_model.dart';
import 'package:alarmi/common/widgets/cst_image_switch.dart';
import 'package:alarmi/features/alarm/models/alarm_params.dart';
import 'package:alarmi/features/alarm/models/weekday.dart';
import 'package:alarmi/features/alarm/services/alarm_notifier.dart';
import 'package:alarmi/utils/date_utils.dart';
import 'package:alarmi/utils/toast_utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Alarm extends ConsumerWidget {
  final int alarmId;
  final AlarmParams params;

  const Alarm({super.key, required this.alarmId, required this.params});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEvening = ref.watch(
      globalViewProvider.select((state) => state.isEvening),
    );
    String formattedTime = formatTimeToAmPm(params.alarmTime);

    final List<String> repeatDayNames =
        params.weekdays.map((wId) {
          final Weekday? weekday = weekdays.firstWhereOrNull(
            (wd) => wd.id == wId,
          );
          return weekday?.name ?? '';
        }).toList();

    void updateWeeklyAlarm({
      required DateTime renewDateTime,
      required Map<String, dynamic> updatedAlarmMap,
    }) async {
      final alarmNotifier = ref.read(alarmListProvider(params.type).notifier);
      List<int> newAlarmKeys = await NotificationController.setWeeklyAlarm(
        weekdays: params.weekdays,
        dateTime: renewDateTime,
        bellId: params.bellId,
        vibrateId: params.vibrateId,
        isWakeUpMission: params.isWakeUpMission == 1,
      );
      if (newAlarmKeys.isNotEmpty) {
        updatedAlarmMap['alarmKeys'] = newAlarmKeys.toString();
        await alarmNotifier.updateAlarm(updatedAlarmMap, params.type);
      }
    }

    void onChanged(bool newValue) async {
      final alarmNotifier = ref.read(alarmListProvider(params.type).notifier);

      final Map<String, dynamic> updatedAlarmMap = params.toJson();
      updatedAlarmMap['isDisabled'] = newValue ? 1 : 0;
      updatedAlarmMap['id'] = alarmId;
      List<int> alarmKeys = params.alarmKeys;

      try {
        DateTime renewDateTime = getWakeUpTimeFromAlarm(params.alarmTime);

        await alarmNotifier.updateAlarm(updatedAlarmMap, params.type);
        newValue
            ? NotificationController.stopScheduledAlarm(alarmKeys)
            // 기존 알람 alarmKeys와 연결이 모두 끊어지게 되므로, 새로 생성된 alarmKeys로 내부 DB 정보 업뎃.
            : updateWeeklyAlarm(
              renewDateTime: renewDateTime,
              updatedAlarmMap: updatedAlarmMap,
            );
        callToast(
          context,
          newValue ? '알람이 비활성화되었습니다.' : '알람이 활성화되었습니다.',
          icon: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check, color: Colors.white, size: 16),
          ),
        );
      } catch (e) {
        debugPrint('알람 상태 업데이트 실패: $e');
        callToast(context, '알람 상태 변경에 실패했습니다.');
      }
    }

    final Color targetColor =
        params.isDisabled == 1
            ? Colors.white.withValues(alpha: 0.4)
            : Colors.white;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                TweenAnimationBuilder<Color?>(
                  tween: ColorTween(begin: Colors.white, end: targetColor),
                  curve: Curves.easeInOut,
                  duration: 0.3.seconds,
                  builder:
                      (context, value, child) => Text(
                        formattedTime.split(' ')[0],
                        style: TextStyle(
                          fontSize: Sizes.size24,
                          color: value,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                ),
                Gaps.h8,
                TweenAnimationBuilder<Color?>(
                  tween: ColorTween(begin: Colors.white, end: targetColor),
                  curve: Curves.easeInOut,
                  duration: 0.3.seconds,
                  builder:
                      (context, value, child) => Text(
                        formattedTime.split(' ')[1],
                        style: TextStyle(
                          fontSize: Sizes.size40,
                          color: value,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                ),
              ],
            ),
            Row(
              children: [
                ...repeatDayNames.mapIndexed(
                  (idx, r) => TweenAnimationBuilder(
                    tween: ColorTween(begin: Colors.white, end: targetColor),
                    curve: Curves.easeInOut,
                    duration: 0.3.seconds,
                    builder:
                        (context, value, child) => Text(
                          '$r${idx == params.weekdays.length - 1 ? '' : ', '}',
                          style: TextStyle(
                            fontSize: Sizes.size16,
                            color: value,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
        CstImageSwitch(
          value: params.isDisabled == 0,
          onChanged: (value) => onChanged(!value),
          thumbIconPath: 'assets/images/icons/cat_icon.svg',
          inactiveColor:
              isEvening
                  ? Theme.of(context).colorScheme.secondaryContainer
                  : Theme.of(context).colorScheme.secondary,
        ),
      ],
    );
  }
}
