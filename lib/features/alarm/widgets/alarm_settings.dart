import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/common/consts/raw_data/bells.dart';
import 'package:alarmi/common/consts/raw_data/haptic_patterns.dart';
import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/common/widgets/cst_image_switch.dart';
import 'package:alarmi/features/alarm/models/weekday.dart';
import 'package:alarmi/features/alarm/widgets/bell_settings_dialog.dart';
import 'package:alarmi/features/alarm/widgets/vibrate_settings_dialog.dart';
import 'package:alarmi/utils/date_utils.dart';
import 'package:alarmi/utils/route_utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class AlarmSettings extends StatefulWidget {
  final List<Weekday> weekdays;
  final bool isActivatedVirtualMission;
  final Function() toggleWakeUpMission;
  final bool isActivatedVibrate;
  final Function() toggleActivatedVibrate;
  final bool isAllDay;
  final Function(bool? value) toggleIsAllDay;
  final Function(int idx, bool value) onWeekdaySelected;
  final Function(String?) onChangeSelectedBellId;
  final Function(String?) onChangeSelectedVibrateId;
  final String? bellId;
  final String? vibrateId;

  const AlarmSettings({
    super.key,
    required this.weekdays,
    required this.isActivatedVirtualMission,
    required this.toggleWakeUpMission,
    required this.isActivatedVibrate,
    required this.toggleActivatedVibrate,
    required this.isAllDay,
    required this.toggleIsAllDay,
    required this.onWeekdaySelected,
    required this.onChangeSelectedBellId,
    required this.onChangeSelectedVibrateId,
    this.bellId,
    this.vibrateId,
  });

  @override
  State<AlarmSettings> createState() => _AlarmSettingsState();
}

class _AlarmSettingsState extends State<AlarmSettings> {
  String? _selectedBellId;
  String? _selectedVibrateId;

  @override
  void initState() {
    super.initState();
    if (widget.bellId != null) _selectedBellId = widget.bellId;
    if (widget.vibrateId != null) _selectedVibrateId = widget.vibrateId;
  }

  void onSaveBellSettings(String? bellId, double volume) {
    debugPrint(
      'onSaveBellSettings called. mounted: $mounted, bellId: $bellId, volume: $volume',
    );
    setState(() {
      _selectedBellId = bellId;
    });
    widget.onChangeSelectedBellId(bellId);
  }

  void onSaveVibrateSettings(String? patternId) {
    setState(() {
      _selectedVibrateId = patternId;
    });
    widget.onChangeSelectedVibrateId(patternId);
  }

  void changeSelectedWeekday(index, value) {
    setState(() {
      widget.onWeekdaySelected(index, value);
    });
  }

  void openSettingsDialog(String type) async {
    type == 'bell'
        ? await Navigator.of(context).push(
          slidePageRoute(
            page: BellSettingsDialog(
              selectedBellId: _selectedBellId,
              onSaveBellSettings: onSaveBellSettings,
            ),
          ),
        )
        : await Navigator.of(context).push(
          slidePageRoute(
            page: VibrateSettingsDialog(
              isActivatedVibrate: widget.isActivatedVibrate,
              toggleActivatedVibrate: widget.toggleActivatedVibrate,
              selectedVibrateId: _selectedVibrateId,
              onSaveVibrateSettings: onSaveVibrateSettings,
            ),
          ),
        );
  }

  String getBellTitleById(String id) =>
      bells.where((bell) => bell.id == id).first.name;

  String getVibrateNameById(String id) =>
      hapticPatterns.where((pattern) => pattern.id == id).first.name;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withValues(alpha: !isEvening() ? 0.01 : 0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '요일 설정',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gaps.h56,
                GestureDetector(
                  onTap: () => widget.toggleIsAllDay(null),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Checkbox(
                        value: widget.isAllDay,
                        onChanged: (value) => widget.toggleIsAllDay(null),
                      ),
                      Text(
                        '매일',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Sizes.size16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    // dense: true,
                  ),
                ),
              ],
            ),
            Row(
              spacing: 12,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...widget.weekdays.mapIndexed(
                  (idx, day) => Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: TextButton(
                        onPressed:
                            () => changeSelectedWeekday(idx, !day.isSelected),
                        style: TextButton.styleFrom(
                          backgroundColor:
                              day.isSelected
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.1),
                          foregroundColor:
                              day.isSelected
                                  ? Colors.black87
                                  : Colors.white.withValues(
                                    alpha: 0.6,
                                  ), // 텍스트 색상
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.zero, // 내부 패딩 제거
                          minimumSize: Size.zero,
                        ),
                        child: Text(day.name),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Gaps.v10,
            Divider(height: 10),
            TextButton(
              onPressed: () => openSettingsDialog('bell'),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '알람음',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        _selectedBellId != null
                            ? getBellTitleById(_selectedBellId!)
                            : '없음',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.white),
                    ],
                  ),
                ],
              ),
            ),
            Divider(height: 10),
            TextButton(
              onPressed: () => openSettingsDialog('vibrate'),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 12,
                ), // 가로 20, 세로 15 패딩
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '진동',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        _selectedVibrateId != null
                            ? getVibrateNameById(_selectedVibrateId!)
                            : '없음',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.white),
                    ],
                  ),
                ],
              ),
            ),
            Divider(height: 10),
            TextButton(
              onPressed: widget.toggleWakeUpMission,
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '기상 미션',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  CstImageSwitch(
                    value: widget.isActivatedVirtualMission,
                    onChanged: (value) => widget.toggleWakeUpMission(),
                    thumbIconPath: 'assets/images/icons/cat_icon.svg',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
