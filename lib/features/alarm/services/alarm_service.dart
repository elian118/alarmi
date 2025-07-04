import 'package:alarmi/features/alarm/models/alarm_params.dart';
import 'package:alarmi/features/alarm/repos/alarm_repository.dart';
import 'package:flutter/foundation.dart';

class AlarmService {
  static final AlarmService _instance = AlarmService._internal();
  final AlarmRepository alarmRepository = AlarmRepository.getInstance();

  static AlarmService getInstance() {
    return _instance;
  }

  AlarmService._internal();

  Future<int> insertAlarm({required AlarmParams params}) async {
    final now = DateTime.now();

    final Map<String, dynamic> newAlarm = {
      ...params.toJson(),
      'createdAt': now.toIso8601String(),
      'updatedAt': now.toIso8601String(),
    };

    try {
      final id = await alarmRepository.insertAlarm(newAlarm);
      if (kDebugMode) {
        print('새 알람이 등록되었습니다. ID: $id');
      }
      return id;
    } catch (e) {
      if (kDebugMode) {
        print('알람 등록 중 오류가 발생했습니다. $e');
      }
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getAlarms(String type) async {
    return await alarmRepository.getAlarms(type: type);
  }
}
