import 'dart:async';

import 'package:alarmi/features/alarm/models/alarm_params.dart';
import 'package:alarmi/features/alarm/repos/alarm_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlarmListNotifier
    extends FamilyAsyncNotifier<List<Map<String, dynamic>>, String> {
  @override
  FutureOr<List<Map<String, dynamic>>> build(String type) async {
    final alarmRepository = await AlarmRepository.getInstance();
    return alarmRepository.getAlarms(type: type);
  }

  // 알람 목록 새로고침
  Future<void> loadAlarms(String type) async {
    state = const AsyncLoading();
    try {
      final alarmRepository = await AlarmRepository.getInstance();
      final alarms = await alarmRepository.getAlarms(type: type);
      state = AsyncData(alarms);
    } catch (e, st) {
      state = AsyncError(e, st);
      if (kDebugMode) {
        print('알람을 불러오는 데 오류가 발생했습니다. $e');
      }
    }
  }

  // 알람 등록
  Future<int> insertAlarm({required AlarmParams params}) async {
    final now = DateTime.now();

    final Map<String, dynamic> newAlarm = {
      ...params.toJson(),
      'createdAt': now.toIso8601String(),
      'updatedAt': now.toIso8601String(),
    };

    try {
      final alarmRepository = await AlarmRepository.getInstance();
      final id = await alarmRepository.insertAlarm(newAlarm);
      if (kDebugMode) {
        print('새 알람이 등록되었습니다. ID: $id');
      }
      await loadAlarms(params.type);
      return id;
    } catch (e) {
      if (kDebugMode) {
        print('알람 등록 중 오류가 발생했습니다. $e');
      }
      rethrow;
    }
  }

  // 알람 삭제
  Future<void> deleteAlarm(int id, String type) async {
    try {
      final alarmRepository = await AlarmRepository.getInstance();
      await alarmRepository.deleteAlarm(id);
      if (kDebugMode) {
        print('알람이 삭제되었습니다. ID: $id');
      }
      await loadAlarms(type); // 삭제 후 알람 목록 새로고침
    } catch (e) {
      if (kDebugMode) {
        print('알람 삭제 중 오류가 발생했습니다. $e');
      }
      rethrow;
    }
  }

  // 알람 업데이트
  Future<void> updateAlarm(Map<String, dynamic> alarm, String type) async {
    try {
      final alarmRepository = await AlarmRepository.getInstance();
      await alarmRepository.updateAlarm(alarm);
      if (kDebugMode) {
        print('알람이 업데이트되었습니다. ID: ${alarm['id']}');
      }
      await loadAlarms(type); // 업데이트 후 알람 목록 새로고침
    } catch (e) {
      if (kDebugMode) {
        print('알람 업데이트 중 오류가 발생했습니다. $e');
      }
      rethrow;
    }
  }
}

final alarmListProvider = AsyncNotifierProvider.family<
  AlarmListNotifier,
  List<Map<String, dynamic>>,
  String
>(() {
  return AlarmListNotifier();
});
