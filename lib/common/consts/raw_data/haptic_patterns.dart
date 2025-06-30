import 'package:alarmi/features/alarm/models/haptic_pattern.dart';
import 'package:vibration/vibration_presets.dart';

List<HapticPattern> hapticPatterns = [
  /*// 1. 짧고 빠르게
  HapticPattern(
    id: 'short_and_fast',
    name: '짧고 빠르게',
    pattern: Int64List.fromList([0, 80, 50, 80, 50, 80]), // 짧은 진동 3번을 빠르게
  ),

  // 2. 강하고 느리게
  HapticPattern(
    id: 'strong_and_slow',
    name: '강하고 느리게',
    pattern: Int64List.fromList([0, 600, 400, 600]), // 길고 묵직한 진동을 느린 간격으로 두 번
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
  ),

  // 5. 3단 울림
  HapticPattern(
    id: 'three_stage_ring',
    name: '3단 울림',
    pattern: Int64List.fromList([0, 200, 150, 200, 150, 200]), // 3번의 명확한 진동
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
  ),

  // 7. 콕
  HapticPattern(
    id: 'tap',
    name: '콕',
    pattern: Int64List.fromList([0, 50]), // 아주 짧고 가벼운 진동
  ),*/
  HapticPattern(
    preset: VibrationPreset.countdownTimerAlert,
    id: 'countdownTimerAlert',
    name: '카운트다운',
  ),

  HapticPattern(
    preset: VibrationPreset.doubleBuzz,
    id: 'doubleBuzz',
    name: '더블',
  ),
  HapticPattern(
    preset: VibrationPreset.dramaticNotification,
    id: 'dramaticNotification',
    name: '드라마틱',
  ),
  HapticPattern(
    preset: VibrationPreset.emergencyAlert,
    id: 'emergencyAlert',
    name: '긴급',
  ),
  HapticPattern(
    preset: VibrationPreset.gentleReminder,
    id: 'gentleReminder',
    name: '젠틀 리마인더',
  ),
  HapticPattern(
    preset: VibrationPreset.heartbeatVibration,
    id: 'heartbeatVibration',
    name: '심장 박동',
  ),
  HapticPattern(
    preset: VibrationPreset.longAlarmBuzz,
    id: 'longAlarmBuzz',
    name: '긴 알람',
  ),
  HapticPattern(
    preset: VibrationPreset.progressiveBuzz,
    id: 'progressiveBuzz',
    name: '진취적인',
  ),
  HapticPattern(
    preset: VibrationPreset.pulseWave,
    id: 'pulseWave',
    name: '펄스 웨이브',
  ),
  HapticPattern(
    preset: VibrationPreset.quickSuccessAlert,
    id: 'quickSuccessAlert',
    name: '빠른 성공',
  ),
  HapticPattern(
    preset: VibrationPreset.rapidTapFeedback,
    id: 'rapidTapFeedback',
    name: '급한 탭 피드백',
  ),
  HapticPattern(
    preset: VibrationPreset.rhythmicBuzz,
    id: 'rhythmicBuzz',
    name: '리드미컬',
  ),
  HapticPattern(
    preset: VibrationPreset.softPulse,
    id: 'softPulse',
    name: '부드럽게',
  ),
  HapticPattern(
    preset: VibrationPreset.singleShortBuzz,
    id: 'singleShortBuzz',
    name: '짧게 한 번',
  ),
  HapticPattern(
    preset: VibrationPreset.tripleBuzz,
    id: 'tripleBuzz',
    name: '세 번',
  ),
  HapticPattern(
    preset: VibrationPreset.urgentBuzzWave,
    id: 'urgentBuzzWave',
    name: '긴급 울림',
  ),

  HapticPattern(
    preset: VibrationPreset.zigZagAlert,
    id: 'zigZagAlert',
    name: '지그재그',
  ),
];
