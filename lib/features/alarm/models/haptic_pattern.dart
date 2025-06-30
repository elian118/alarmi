import 'package:vibration/vibration_presets.dart';

class HapticPattern {
  final String id;
  final String name;
  // final Int64List pattern;
  final VibrationPreset preset;

  HapticPattern({required this.id, required this.name, required this.preset});

  @override
  String toString() {
    return 'HapticPattern(id: $id, name: $name, preset: $preset)';
  }
}
