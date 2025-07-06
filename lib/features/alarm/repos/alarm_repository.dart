import 'package:alarmi/common/configs/inner_database.dart';
import 'package:sqflite/sqflite.dart';

class AlarmRepository {
  static AlarmRepository? _instance;
  late final Database _db;
  final String alarms = 'alarms';

  AlarmRepository._(this._db);

  static Future<AlarmRepository> getInstance() async {
    if (_instance == null) {
      final database =
          await InnerDatabase.instance; // InnerDatabase 인스턴스를 비동기로 가져옵니다.
      _instance = AlarmRepository._(database);
    }
    return _instance!;
  }

  Future<List<Map<String, dynamic>>> getAlarms({String? type}) async {
    if (type != null) {
      return await _db.query(alarms, where: 'type = ?', whereArgs: [type]);
    } else {
      return await _db.query(alarms);
    }
  }

  Future<List<Map<String, dynamic>>> getAlarmsByAlarmKeyContains(
    String searchKey,
  ) async {
    return await _db.query(
      alarms,
      where: 'alarmKeys LIKE ?',
      whereArgs: ['%$searchKey%'],
    );
  }

  Future<int> insertAlarm(Map<String, dynamic> alarm) async {
    final id = await _db.insert(
      'alarms',
      alarm,
      conflictAlgorithm: ConflictAlgorithm.replace, // 충돌 발생 시 교체
    );
    return id;
  }

  Future<int> deleteAlarm(int id) async {
    return await _db.delete(alarms, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateAlarm(Map<String, dynamic> alarm) async {
    final id = alarm['id'];
    if (id == null) {
      throw ArgumentError('필수값(id)이 누락되었습니다.');
    }

    return await _db.update(
      alarms,
      alarm,
      where: 'id = ?',
      whereArgs: [id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
