import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/material.dart';

class BellSettingsDialog extends StatefulWidget {
  const BellSettingsDialog({super.key});

  @override
  State<BellSettingsDialog> createState() => _BellSettingsDialogState();
}

class _BellSettingsDialogState extends State<BellSettingsDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18),
      height: getWinHeight(context) * 0.8,
      width: getWinWidth(context),
      child: Text('알람음'),
    );
  }
}
