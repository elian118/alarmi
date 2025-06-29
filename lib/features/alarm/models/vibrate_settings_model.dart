import 'package:flutter/cupertino.dart';

class VibrateSettingsModel {
  final bool isActivated;
  final Widget icon;
  final String label;
  bool isPlaying;

  VibrateSettingsModel({
    required this.isActivated,
    required this.icon,
    required this.label,
    required this.isPlaying,
  });
}
