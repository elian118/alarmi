import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/material.dart';

class VibrateSettingsDialog extends StatefulWidget {
  const VibrateSettingsDialog({super.key});

  @override
  State<VibrateSettingsDialog> createState() => _VibrateSettingsDialogState();
}

class _VibrateSettingsDialogState extends State<VibrateSettingsDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18),
      height: getWinHeight(context) * 0.8,
      width: getWinWidth(context),
      child: Text('진동'),
    );
  }
}
