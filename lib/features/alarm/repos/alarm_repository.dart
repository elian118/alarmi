import 'package:alarmi/common/configs/inner_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

final alarmRepositoryProvider = Provider<AlarmRepository>((ref) {
  return AlarmRepository(); // Riverpod이 AlarmRepository 인스턴스를 관리합니다.
});

class AlarmRepository {
  final Database db = InnerDatabase.instance;
  final String alarms = 'alarms';

  AlarmRepository();

  Future<List<Map<String, dynamic>>> getAlarms({String? type}) async {
    if (type != null) {
      return await db.query(alarms, where: 'type = ?', whereArgs: [type]);
    } else {
      return await db.query(alarms);
    }
  }

  Future<List<Map<String, dynamic>>> getAlarmsByAlarmKeyContains(
    String searchKey,
  ) async {
    return await db.query(
      alarms,
      where: 'alarmKeys LIKE ?',
      whereArgs: ['%$searchKey%'],
    );
  }

  Future<int> insertAlarm(Map<String, dynamic> alarm) async {
    final id = await db.insert(
      'alarms',
      alarm,
      conflictAlgorithm: ConflictAlgorithm.replace, // 충돌 발생 시 교체
    );
    return id;
  }

  Future<int> deleteAlarm(int id) async {
    return await db.delete(alarms, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateAlarm(Map<String, dynamic> alarm) async {
    final id = alarm['id'];
    if (id == null) {
      throw ArgumentError('필수값(id)이 누락되었습니다.');
    }

    return await db.update(
      alarms,
      alarm,
      where: 'id = ?',
      whereArgs: [id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
