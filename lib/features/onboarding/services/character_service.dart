import 'package:shared_preferences/shared_preferences.dart';

class CharacterService {
  static const _kCharacterNameKey = 'characterName';
  static const _kCharacterPersonalityKey = 'characterPersonality';

  // 캐릭터 이름 짓기
  static Future<void> setCharacterName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kCharacterNameKey, name);
  }

  // 캐릭터 성격 설정
  static Future<void> setCharacterPersonality(String personality) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kCharacterPersonalityKey, personality);
  }

  //  캐릭터 이름 조회
  static Future<String?> getCharacterNamed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kCharacterNameKey);
  }

  // 캐릭터 성격 조회
  static Future<String?> getCharacterPersonality() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kCharacterPersonalityKey);
  }
}
