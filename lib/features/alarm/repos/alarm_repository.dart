import 'package:alarmi/common/configs/inner_database.dart';
import 'package:sqflite/sqflite.dart';

class AlarmRepository {
  static final AlarmRepository _instance = AlarmRepository._internal();

  factory AlarmRepository() {
    return _instance;
  }

  AlarmRepository._internal();

  Future<List<Map<String, dynamic>>> getAlarms() async {
    final Database db = InnerDatabase.instance;
    return await db.query('alarms');
  }

  Future<int> insertAlarm(Map<String, dynamic> alarm) async {
    final Database db = InnerDatabase.instance;
    final id = await db.insert(
      'alarms',
      alarm,
      conflictAlgorithm: ConflictAlgorithm.replace, // 충돌 발생 시 교체
    );
    return id;
  }
}
