import 'dart:typed_data';

import 'package:alarmi/common/consts/enums/haptics_type.dart';
import 'package:alarmi/features/alarm/models/haptic_pattern.dart';

List<HapticPattern> hapticPatterns = [
  // 1. 짧고 빠르게
  HapticPattern(
    id: 'short_and_fast',
    name: '짧고 빠르게',
    pattern: Int64List.fromList([0, 80, 50, 80, 50, 80]), // 짧은 진동 3번을 빠르게
    iosHapticType: HapticsType.light, // 빠르고 가벼운 느낌
  ),

  // 2. 강하고 느리게
  HapticPattern(
    id: 'strong_and_slow',
    name: '강하고 느리게',
    pattern: Int64List.fromList([0, 600, 400, 600]), // 길고 묵직한 진동을 느린 간격으로 두 번
    iosHapticType: HapticsType.heavy, // 묵직하고 강한 느낌
  ),

  // 3. 점점 강하게
  HapticPattern(
    id: 'gradually_stronger',
    name: '점점 강하게',
    pattern: Int64List.fromList([
      0,
      100,
      100,
      200,
      100,
      400,
    ]), // 진동 길이가 점차 길어지면서 강해지는 느낌
    iosHapticType: HapticsType.medium, // 점진적인 변화에 적합
  ),

  // 4. 리듬감 있게
  HapticPattern(
    id: 'rhythmic',
    name: '리듬감 있게',
    pattern: Int64List.fromList([
      0,
      200,
      100,
      100,
      200,
      100,
      100,
    ]), // 박자에 맞춰 짧고 길게 반복
    iosHapticType: HapticsType.success, // 규칙적인 긍정적 피드백과 유사
  ),

  // 5. 3단 울림
  HapticPattern(
    id: 'three_stage_ring',
    name: '3단 울림',
    pattern: Int64List.fromList([0, 200, 150, 200, 150, 200]), // 3번의 명확한 진동
    iosHapticType: HapticsType.warning, // 명확한 경고성 알림과 유사
  ),

  // 6. 심장 박동
  HapticPattern(
    id: 'heartbeat',
    name: '심장 박동',
    pattern: Int64List.fromList([
      0,
      300,
      600,
      300,
    ]), // 느리고 묵직한 두 번의 진동, 심장 박동과 유사
    iosHapticType: HapticsType.heavy, // 깊고 묵직한 느낌
  ),

  // 7. 콕
  HapticPattern(
    id: 'tap',
    name: '콕',
    pattern: Int64List.fromList([0, 50]), // 아주 짧고 가벼운 진동
    iosHapticType: HapticsType.selection, // 짧고 미묘한 터치 피드백과 유사
  ),
];
