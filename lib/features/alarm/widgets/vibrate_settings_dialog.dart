import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/features/alarm/widgets/vibrates.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/material.dart';

class VibrateSettingsDialog extends StatefulWidget {
  final bool isActivatedVibrate;
  final Function() toggleActivatedVibrate;

  const VibrateSettingsDialog({
    super.key,
    required this.isActivatedVibrate,
    required this.toggleActivatedVibrate,
  });

  @override
  State<VibrateSettingsDialog> createState() => _VibrateSettingsDialogState();
}

class _VibrateSettingsDialogState extends State<VibrateSettingsDialog> {
  bool _dialogIsActivatedVibrate = false;

  void _onSwitchChanged(bool newValue) {
    setState(() {
      _dialogIsActivatedVibrate = newValue;
    });
    // 부모 위젯 상태 업데이트
    widget.toggleActivatedVibrate();
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
              Switch(
                value: _dialogIsActivatedVibrate,
                onChanged: _onSwitchChanged,
              ),
            ],
          ),
          Expanded(child: Vibrates()),
          ElevatedButton(
            onPressed: () {},
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
