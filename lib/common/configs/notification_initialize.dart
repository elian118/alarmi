import 'package:alarmi/common/consts/raw_data/bells.dart';
import 'package:alarmi/common/consts/raw_data/haptic_patterns.dart';
import 'package:alarmi/features/alarm/models/haptic_pattern.dart';
import 'package:alarmi/features/shaking_clams/services/mission_status_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NotificationInitialize {
  static ReceivedAction? initialAction;

  static Future<void> initAwesomeNotifications() async {
    List<NotificationChannel> channels = getChannels();

    await AwesomeNotifications().initialize(null, channels, debug: false);

    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    // // 알림 액션 리스너 설정(알림 끄기 버튼 등)
    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
    );

    initialAction = await AwesomeNotifications().getInitialNotificationAction(
      removeFromActionEvents: false,
    );
  }

  static List<NotificationChannel> getChannels() {
    String getBellFileName(bell) => bell.path.split('/').last.split('.').first;

    // 진동 패턴이 없는 경우를 나타내는 가상의 HapticPattern 객체 추가
    final allHapticPatterns = [
      HapticPattern(
        preset: null, // 프리셋 없음
        id: 'no_pattern',
        name: '',
        pattern: Int64List(0), // 비어있는 진동 패턴
      ),
      ...hapticPatterns, // 기존의 진동 패턴들
    ];

    return bells.expand((bell) {
      final bellFileName = getBellFileName(bell); // 한 번만 호출하여 변수에 저장

      return allHapticPatterns.map((pattern) {
        // 'no_pattern'의 경우 채널 이름과 키에서 패턴 관련 부분 제외
        final channelKeySuffix =
            pattern.id == 'no_pattern' ? '' : '_${pattern.id}';
        final channelNameSuffix =
            pattern.id == 'no_pattern' ? '' : '_${pattern.name}';

        return NotificationChannel(
          channelKey: '${bell.id}${channelKeySuffix}_channel',
          channelName: '${bell.name}$channelNameSuffix',
          channelDescription:
              'Alarm sound channel for ${bell.name}$channelNameSuffix',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          playSound: true,
          enableVibration: pattern.id != 'no_pattern', // 패턴이 있을 때만 진동 활성화
          vibrationPattern:
              pattern.id == 'no_pattern'
                  ? null
                  : pattern.pattern, // 'no_pattern'일 경우 진동 패턴 없음
          soundSource: 'resource://raw/$bellFileName',
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          locked: true,
          criticalAlerts: true,
        );
      });
    }).toList();
  }

  @pragma('vm:entry-point')
  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    if (kDebugMode) {
      print(
        'onNotificationDisplayedMethod 호출됨. ID: ${receivedNotification.id}',
      );

      final bool isWakeUpMission =
          receivedNotification.payload?['isWakeUpMission'] == 'true';

      print('기상미션 여부: $isWakeUpMission');

      if (isWakeUpMission) {
        MissionStatusService.setWakeUpMissionCompleted(false);
        print('기상미션을 미완료 상태로 설정합니다');
      }
    }
  }

  @pragma('vm:entry-point') // 백그라운드 실행을 위한 필수 어노테이션
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    int alarmId = receivedAction.id!;

    if (kDebugMode) {
      print(
        'onActionReceivedMethod 호출됨. ID: $alarmId, Channel: ${receivedAction.channelKey}, Button: ${receivedAction.buttonKeyPressed}',
      );
    }

    // '알람 끄기' 버튼이 눌렸을 때 또는 메시지 본문이 눌렸을 때
    if (receivedAction.buttonKeyPressed == 'stop_alarm' ||
        receivedAction.actionType == ActionType.Default) {
      final bool isWakeUpMission =
          receivedAction.payload?['isWakeUpMission'] == 'true';

      if (kDebugMode) {
        print(isWakeUpMission ? '기상미션이 있습니다.' : '기상미션이 없습니다.');

        if (receivedAction.buttonKeyPressed == 'stop_alarm') {
          print('알람 중지 버튼이 눌렸습니다.');
        } else if (receivedAction.actionType == ActionType.Default) {
          print('알림 메시지 본문이 눌렸습니다. (알람 중지)');
        }
      }

      await AwesomeNotifications().dismiss(receivedAction.id!); // 알림 제거
    }
  }
}
