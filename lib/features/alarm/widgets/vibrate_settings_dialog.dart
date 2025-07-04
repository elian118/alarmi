import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/common/widgets/cst_image_switch.dart';
import 'package:alarmi/features/alarm/widgets/vibrates.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class VibrateSettingsDialog extends StatefulWidget {
  final bool isActivatedVibrate;
  final Function() toggleActivatedVibrate;
  final String? selectedVibrateId;
  final Function(String? patternId) onSaveVibrateSettings;

  const VibrateSettingsDialog({
    super.key,
    required this.isActivatedVibrate,
    required this.toggleActivatedVibrate,
    required this.onSaveVibrateSettings,
    this.selectedVibrateId,
  });

  @override
  State<VibrateSettingsDialog> createState() => _VibrateSettingsDialogState();
}

class _VibrateSettingsDialogState extends State<VibrateSettingsDialog> {
  late String? _selectedVibrateId = widget.selectedVibrateId;
  late bool _isDialogActivatedVibrate = _selectedVibrateId != null;
  String? _toUpdateVibrateId;

  void _onSwitchChanged(bool newValue) {
    setState(() {
      _isDialogActivatedVibrate = newValue;
    });
    // 부모 위젯 상태 업데이트
    widget.toggleActivatedVibrate();
    // 플레이 상태 반영
    if (newValue == false) {
      onChangeCurrentPlayingPatternId(null);
      Vibration.cancel(); // 재생중인 모든 진동 취소
    }
  }

  void setToUpdateVibrateId(String? patternId) {
    setState(() {
      _toUpdateVibrateId = patternId;
    });
  }

  void saveVibrate() {
    widget.onSaveVibrateSettings(_toUpdateVibrateId);
    Navigator.pop(context);
  }

  void onChangeCurrentPlayingPatternId(String? patternId) {
    setState(() {
      _selectedVibrateId = patternId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(22),
      height: getWinHeight(context) * 0.87,
      width: getWinWidth(context),
      child: Column(
        spacing: 12,
        children: [
          Row(
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
              CstImageSwitch(
                value: _isDialogActivatedVibrate,
                onChanged: _onSwitchChanged,
                thumbIconPath: 'assets/images/icons/cat_icon.svg',
              ),
            ],
          ),
          Expanded(
            child: Vibrates(
              selectedVibrateId: _selectedVibrateId,
              onChangeCurrentPlayingPatternId: onChangeCurrentPlayingPatternId,
              setToUpdateVibrateId: setToUpdateVibrateId,
              isDialogActivatedVibrate: _isDialogActivatedVibrate,
            ),
          ),
          ElevatedButton(
            onPressed: () => saveVibrate(),
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
                  '완료',
                  style: TextStyle(
                    fontSize: Sizes.size18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
