import 'dart:typed_data';

import 'package:vibration/vibration_presets.dart';

class HapticPattern {
  final String id;
  final String name;
  final VibrationPreset? preset;
  final Int64List pattern;

  HapticPattern({
    required this.id,
    required this.name,
    required this.preset,
    required this.pattern,
  });

  @override
  String toString() {
    return 'HapticPattern(id: $id, name: $name, preset: $preset, pattern: $pattern)';
  }
}
