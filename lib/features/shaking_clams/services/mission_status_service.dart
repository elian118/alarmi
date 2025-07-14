import 'package:shared_preferences/shared_preferences.dart';

class MissionStatusService {
  static const _kWakeUpMissionCompletedKey = 'wakeUpMissionCompleted';

  // 미션 완료 상태 저장
  static Future<void> setWakeUpMissionCompleted(bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kWakeUpMissionCompletedKey, completed);
  }

  // 미션 완료 상태 조회
  static Future<bool> isWakeUpMissionCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kWakeUpMissionCompletedKey) ?? true;
  }
}
