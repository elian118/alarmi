import 'dart:typed_data';

import 'package:alarmi/features/alarm/models/haptic_pattern.dart';
import 'package:vibration/vibration_presets.dart';

List<HapticPattern> hapticPatterns = [
  // HapticPattern(
  //   preset: VibrationPreset.countdownTimerAlert,
  //   id: 'countdownTimerAlert',
  //   name: '카운트다운',
  //   pattern: Int64List.fromList([
  //     0,
  //     100,
  //     100,
  //     100,
  //     100,
  //     100,
  //     200,
  //     300,
  //     400,
  //   ]), // 점점 길고 강해지는 카운트다운 느낌
  // ),
  HapticPattern(
    preset: VibrationPreset.doubleBuzz,
    id: 'doubleBuzz',
    name: '더블',
    pattern: Int64List.fromList([0, 200, 150, 200]), // 짧게 두 번
  ),
  HapticPattern(
    preset: VibrationPreset.dramaticNotification,
    id: 'dramaticNotification',
    name: '드라마틱',
    pattern: Int64List.fromList([
      0,
      500,
      100,
      800,
      100,
      1000,
    ]), // 점점 길어지며 극적인 느낌
  ),
  HapticPattern(
    preset: VibrationPreset.emergencyAlert,
    id: 'emergencyAlert',
    name: '긴급',
    pattern: Int64List.fromList([
      0,
      1000,
      200,
      1000,
      200,
      1000,
    ]), // 길고 반복적인 긴급 알림
  ),
  HapticPattern(
    preset: VibrationPreset.gentleReminder,
    id: 'gentleReminder',
    name: '젠틀 리마인더',
    pattern: Int64List.fromList([0, 100, 300, 100]), // 부드럽고 짧은 두 번의 진동
  ),
  HapticPattern(
    preset: VibrationPreset.heartbeatVibration,
    id: 'heartbeatVibration',
    name: '심장 박동',
    pattern: Int64List.fromList([
      0,
      150,
      100,
      150,
      400,
      150,
      100,
      150,
    ]), // 심장 박동처럼 규칙적인 진동
  ),
  HapticPattern(
    preset: VibrationPreset.longAlarmBuzz,
    id: 'longAlarmBuzz',
    name: '긴 알람',
    pattern: Int64List.fromList([0, 2000]), // 한 번에 길게 울리는 알람
  ),
  HapticPattern(
    preset: VibrationPreset.progressiveBuzz,
    id: 'progressiveBuzz',
    name: '진취적인',
    pattern: Int64List.fromList([
      0,
      100,
      100,
      200,
      100,
      300,
      100,
      400,
    ]), // 점점 길고 강해지는 느낌
  ),
  HapticPattern(
    preset: VibrationPreset.pulseWave,
    id: 'pulseWave',
    name: '펄스 웨이브',
    pattern: Int64List.fromList([
      0,
      200,
      200,
      200,
      200,
      200,
      200,
    ]), // 일정한 간격의 펄스
  ),
  // HapticPattern(
  //   preset: VibrationPreset.quickSuccessAlert,
  //   id: 'quickSuccessAlert',
  //   name: '빠른 성공',
  //   pattern: Int64List.fromList([0, 100, 50, 100]), // 짧고 빠르게 두 번
  // ),
  // HapticPattern(
  //   preset: VibrationPreset.rapidTapFeedback,
  //   id: 'rapidTapFeedback',
  //   name: '급한 탭 피드백',
  //   pattern: Int64List.fromList([0, 50, 50, 50, 50, 50]), // 아주 짧게 여러 번 반복
  // ),
  HapticPattern(
    preset: VibrationPreset.rhythmicBuzz,
    id: 'rhythmicBuzz',
    name: '리드미컬',
    pattern: Int64List.fromList([0, 200, 100, 200, 300, 200]), // 리듬감 있는 패턴
  ),
  HapticPattern(
    preset: VibrationPreset.softPulse,
    id: 'softPulse',
    name: '부드럽게',
    pattern: Int64List.fromList([0, 150, 250, 150]), // 부드럽고 완만한 두 번의 진동
  ),
  HapticPattern(
    preset: VibrationPreset.singleShortBuzz,
    id: 'singleShortBuzz',
    name: '짧게 한 번',
    pattern: Int64List.fromList([0, 200]), // 짧게 한 번
  ),
  // HapticPattern(
  //   preset: VibrationPreset.tripleBuzz,
  //   id: 'tripleBuzz',
  //   name: '세 번',
  //   pattern: Int64List.fromList([0, 200, 100, 200, 100, 200]), // 짧게 세 번
  // ),
  // HapticPattern(
  //   preset: VibrationPreset.urgentBuzzWave,
  //   id: 'urgentBuzzWave',
  //   name: '긴급 울림',
  //   pattern: Int64List.fromList([
  //     0,
  //     300,
  //     100,
  //     300,
  //     100,
  //     300,
  //     500,
  //     500,
  //   ]), // 반복적이고 긴급한 느낌
  // ),
  HapticPattern(
    preset: VibrationPreset.zigZagAlert,
    id: 'zigZagAlert',
    name: '지그재그',
    pattern: Int64List.fromList([0, 100, 50, 150, 50, 100, 50, 150]),
  ),
];
