import 'dart:typed_data';

import 'package:alarmi/common/consts/enums/haptics_type.dart';

class HapticPattern {
  final String id;
  final String name;
  final Int64List pattern;
  final HapticsType? iosHapticType;

  HapticPattern({
    required this.id,
    required this.name,
    required this.pattern,
    this.iosHapticType,
  });

  @override
  String toString() {
    return 'HapticPattern(id: $id, name: $name, pattern: $pattern)';
  }
}
