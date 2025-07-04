import 'package:alarmi/common/configs/inner_database.dart';
import 'package:sqflite/sqflite.dart';

class AlarmRepository {
  static final AlarmRepository _instance = AlarmRepository._internal();
  final Database db = InnerDatabase.instance;
  final String alarms = 'alarms';

  static AlarmRepository getInstance() {
    return _instance;
  }

  AlarmRepository._internal();

  Future<List<Map<String, dynamic>>> getAlarms({String? type}) async {
    if (type != null) {
      return await db.query(alarms, where: 'type = ?', whereArgs: [type]);
    } else {
      return await db.query(alarms);
    }
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
