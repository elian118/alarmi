import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/features/alarm/models/weekday.dart';
import 'package:alarmi/features/alarm/widgets/bell_settings_dialog.dart';
import 'package:alarmi/features/alarm/widgets/vibrate_settings_dialog.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class AlarmSettings extends StatefulWidget {
  final List<Weekday> weekdays;
  final bool isActivatedVirtualMission;
  final Function() toggleVirtualMission;

  const AlarmSettings({
    super.key,
    required this.weekdays,
    required this.isActivatedVirtualMission,
    required this.toggleVirtualMission,
  });

  @override
  State<AlarmSettings> createState() => _AlarmSettingsState();
}

class _AlarmSettingsState extends State<AlarmSettings> {
  void changeSelected(index, value) {
    setState(() {
      widget.weekdays[index].isSelected = value;
    });
  }

  void openSettingsDialog(String type) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) =>
              type == 'bell' ? BellSettingsDialog() : VibrateSettingsDialog(),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '요일 설정',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Gaps.h56,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Checkbox(value: true, onChanged: (value) {}),
                    Text(
                      '매일',
                      style: TextStyle(
                        fontSize: Sizes.size16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  // dense: true,
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ...widget.weekdays.mapIndexed(
                    (idx, day) => SizedBox(
                      width: 38,
                      height: 38,
                      child: TextButton(
                        onPressed: () => changeSelected(idx, !day.isSelected),
                        style: TextButton.styleFrom(
                          backgroundColor:
                              day.isSelected
                                  ? Colors.blueAccent
                                  : Colors.grey.shade700,
                          foregroundColor: Colors.white, // 텍스트 색상
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
                ],
              ),
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
                    '알림음',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('없음', style: TextStyle(color: Colors.black87)),
                      Icon(Icons.chevron_right, color: Colors.black87),
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
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('없음', style: TextStyle(color: Colors.black87)),
                      Icon(Icons.chevron_right, color: Colors.black87),
                    ],
                  ),
                ],
              ),
            ),
            Divider(height: 10),
            TextButton(
              onPressed: widget.toggleVirtualMission,
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '기상 미션',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Switch(
                    value: widget.isActivatedVirtualMission,
                    onChanged: (value) => widget.toggleVirtualMission(),
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
