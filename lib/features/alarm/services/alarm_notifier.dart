import 'dart:async';
import 'dart:convert';

import 'package:alarmi/common/configs/notification_controller.dart';
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
      debugPrint(alarms.toString());
      state = AsyncData(alarms);
    } catch (e, st) {
      state = AsyncError(e, st);
      debugPrint('알람을 불러오는 데 오류가 발생했습니다. $e');
    }
  }

  Future<AlarmParams?> loadAlarm({required String alarmId}) async {
    final alarmRepository = await AlarmRepository.getInstance();
    Map<String, dynamic>? json = await alarmRepository.getAlarmById(
      alarmId: alarmId,
    );

    if (json != null) {
      return AlarmParams.fromJson(json);
    }
    return null;
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
      debugPrint('새 알람이 등록되었습니다. ID: $id');
      await loadAlarms(params.type);
      return id;
    } catch (e) {
      debugPrint('알람 등록 중 오류가 발생했습니다. $e');
      rethrow;
    }
  }

  // 알람 삭제
  Future<void> deleteAlarm(int id, String type) async {
    try {
      final alarmRepository = await AlarmRepository.getInstance();
      String strAlarmKeys = await alarmRepository.getAlarmKeysById(id);
      List<dynamic> alarmKeys = jsonDecode(
        strAlarmKeys.trim().replaceAll(' ', ''),
      );
      alarmKeys = alarmKeys.map((key) => key as int).toList();
      int deletedRowCount = await alarmRepository.deleteAlarm(id);
      debugPrint('deletedRowCount: $deletedRowCount, alarmKeys: $alarmKeys');
      // 삭제 성공 시
      if (deletedRowCount > 0 && alarmKeys.isNotEmpty) {
        NotificationController.stopScheduledAlarm(alarmKeys as List<int>);
      }
      debugPrint('알람이 삭제되었습니다. ID: $id');
      // 관련 메시징 스케쥴 로컬 알람 삭제
      await loadAlarms(type); // 삭제 후 알람 목록 새로고침
    } catch (e) {
      debugPrint('알람 삭제 중 오류가 발생했습니다. $e');
      rethrow;
    }
  }

  // 알람 업데이트
  Future<bool> updateAlarm(Map<String, dynamic> alarm, String type) async {
    try {
      final alarmRepository = await AlarmRepository.getInstance();
      final updatedRows = await alarmRepository.updateAlarm(alarm);
      debugPrint('알람이 업데이트되었습니다. ID: ${alarm['id']}');
      await loadAlarms(type); // 업데이트 후 알람 목록 새로고침
      return updatedRows > 0;
    } catch (e) {
      debugPrint('알람 업데이트 중 오류가 발생했습니다. $e');
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
