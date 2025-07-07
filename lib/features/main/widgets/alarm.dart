import 'package:alarmi/common/configs/notification_controller.dart';
import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/common/consts/raw_data/weekdays.dart';
import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/common/widgets/cst_image_switch.dart';
import 'package:alarmi/features/alarm/models/alarm_params.dart';
import 'package:alarmi/features/alarm/models/weekday.dart';
import 'package:alarmi/features/alarm/services/alarm_notifier.dart';
import 'package:alarmi/utils/date_utils.dart';
import 'package:alarmi/utils/toast_utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Alarm extends ConsumerWidget {
  final int alarmId;
  final AlarmParams params;

  const Alarm({super.key, required this.alarmId, required this.params});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String formattedTime = formatTimeToAmPm(params.alarmTime);

    final List<String> repeatDayNames =
        params.weekdays.map((wId) {
          final Weekday? weekday = weekdays.firstWhereOrNull(
            (wd) => wd.id == wId,
          );
          return weekday?.name ?? '';
        }).toList();

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
            : NotificationController.setWeeklyAlarm(
              weekdays: params.weekdays,
              dateTime: renewDateTime,
              bellId: params.bellId,
              vibrateId: params.vibrateId,
            );

        callSimpleToast(newValue ? '알람이 비활성화되었습니다.' : '알람이 활성화되었습니다.');
      } catch (e) {
        if (kDebugMode) {
          print('알람 상태 업데이트 실패: $e');
        }
        callSimpleToast('알람 상태 변경에 실패했습니다.');
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
                          fontSize: Sizes.size16,
                          color: value,
                          fontWeight: FontWeight.w400,
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
                          fontSize: Sizes.size24,
                          color: value,
                          fontWeight: FontWeight.w500,
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
                            fontSize: Sizes.size12,
                            color: value,
                            fontWeight: FontWeight.w600,
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
        ),
      ],
    );
  }
}
