import 'package:alarmi/common/consts/raw_data/bells.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NotificationInitialize {
  static ReceivedAction? initialAction;

  static Future<void> initAwesomeNotifications() async {
    List<NotificationChannel> channels =
        bells.map((bell) {
          String soundFileName = bell.path.split('/').last.split('.').first;

          return NotificationChannel(
            channelKey: bell.id,
            channelName: bell.name,
            channelDescription: 'Alarm sound channel for ${bell.name}',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white,
            playSound: true,
            enableVibration: false,
            soundSource: 'resource://raw/$soundFileName',
            importance: NotificationImportance.Max,
            channelShowBadge: true,
            locked: true,
            criticalAlerts: true,
          );
        }).toList();

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

  @pragma('vm:entry-point')
  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    if (kDebugMode) {
      print(
        'onNotificationDisplayedMethod 호출됨. ID: ${receivedNotification.id}',
      );
      print('Payload (Displayed): ${receivedNotification.payload}');
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
      if (kDebugMode) {
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
