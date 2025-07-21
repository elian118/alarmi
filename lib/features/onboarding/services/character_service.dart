import 'package:shared_preferences/shared_preferences.dart';

class CharacterService {
  static const _kCharacterNameKey = 'characterName';
  static const _kCharacterPersonalityKey = 'characterPersonality';
  static const _kCharacterColorKey = 'characterColor';

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

  // 캐릭터 색상 설정
  static Future<void> setCharacterColor(int color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kCharacterColorKey, color);
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

  // 캐릭터 색상 조회
  static Future<int?> getCharacterColor() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kCharacterColorKey);
  }
}
