import 'dart:isolate';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:just_audio/just_audio.dart';

// 싱글톤 AudioPlayer 인스턴스
final AudioPlayer _audioPlayer = AudioPlayer();

class NotificationController {
  static ReceivedAction? initialAction;

  static Future<void> initAwesomeNotifications() async {
    await AwesomeNotifications().initialize(null, [
      NotificationChannel(
        channelKey: 'my_alarm_channel',
        channelName: '내 알람',
        channelDescription: '사용자 전용 주기적 기상 알람',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
        playSound: true,
        enableVibration: true,
        importance: NotificationImportance.Max, // 중요도 최대 설정
        channelShowBadge: true,
        locked: true, // 알림을 스와이프 제거 방지(잠금)
        criticalAlerts: true, // Android 12 이상 - 전체 화면 인텐트 활성화
      ),
    ], debug: true);

    // 알림 권한 요청
    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    //
    // // 알림 액션 리스너 설정(알림 끄기 버튼 등)
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
    );

    initialAction = await AwesomeNotifications().getInitialNotificationAction(
      removeFromActionEvents: false,
    );
  }

  static ReceivePort? receivePort;

  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
    );
  }

  @pragma('vm:entry-point') // 백그라운드 실행을 위한 필수 어노테이션
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    int alarmId = receivedAction.id!;

    // 알람이 울렸을 때 (content, schedule 유형 알림)
    if (receivedAction.channelKey == 'my_alarm_channel' &&
        receivedAction.id != null) {
      if (kDebugMode) {
        print('알람이 울렸습니다. ${receivedAction.id}');
        print(
          '재생 파일 (just_audio): ${receivedAction.payload?['soundAssetPath']}',
        );
      }

      final String? soundAssetPath = receivedAction.payload?['soundAssetPath'];
      if (soundAssetPath != null) {
        await playAlarmSound(alarmId, soundAssetPath);
      } else {
        if (kDebugMode) {
          print('soundAssetPath가 전달되지 않았습니다.');
        }
      }
    }

    // '알람 끄기' 버튼이 눌렸을 때
    if (receivedAction.channelKey == 'my_alarm_channel' &&
        receivedAction.buttonKeyPressed == 'stop_alarm') {
      if (kDebugMode) {
        print('알람 중지 버튼이 눌렸습니다.');
      }
      await AwesomeNotifications().dismiss(receivedAction.id!); // 알림 제거
      await stopAlarmSound(); // 재생 중지
    }
  }

  @pragma('vm:entry-point')
  static Future<void> playAlarmSound(int alarmId, String assetPath) async {
    try {
      await _audioPlayer.setAsset(assetPath);
      await _audioPlayer.setLoopMode(LoopMode.one); // 반복 재생 설정
      await _audioPlayer.play();

      // 5분 후 자동 알람 중지
      Future.delayed((10 * 60).seconds, () async {
        if (_audioPlayer.playing) {
          await stopAlarmSound();
          if (kDebugMode) {
            print('5분 경과, 알람 자동 중지');
          }
          await AwesomeNotifications().dismiss(alarmId);
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('재생 중 오류 발생: $e');
      }
    }
  }

  // stopAlarmSound 함수도 Top-level 유지
  static Future<void> stopAlarmSound() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.stop();
    }
  }

  // 테스트 알람 설정 매주 월~금 지금부터 5초 뒤 반복 알람
  static Future<void> setTestWeeklyAlarm({
    required String soundAssetPath,
  }) async {
    DateTime testDateTime = DateTime.now().add(5.seconds); // 5초 뒤 시간

    // 기존 알람 있다면 모두 취소해 중복 방지
    await AwesomeNotifications().cancelSchedulesByChannelKey(
      'my_alarm_channel',
    );

    // 월~금까지 각각 알림 설정
    for (int i = DateTime.monday; i <= DateTime.friday; i++) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: i,
          channelKey: 'my_alarm_channel',
          title: '(test) 기상 시간입니다!',
          body: '상쾌한 아침을 시작하세요.',
          payload: {'day': i.toString(), 'soundAssetPath': soundAssetPath},
          category: NotificationCategory.Alarm,
          wakeUpScreen: true,
          fullScreenIntent: true, // 안드로이드 12 이상 전용 - 전체화면 인텐트
          locked: true, // 알림 스와이프 방지
          // customSound: soundAssetPath,
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'stop_alarm',
            label: '알림 끄기',
            autoDismissible: true, // 버튼 클릭 시 알림 자동 닫힘
          ),
        ],
        schedule: NotificationCalendar(
          weekday: i,
          hour: testDateTime.hour,
          minute: testDateTime.minute,
          second: testDateTime.second,
          millisecond: testDateTime.millisecond,
          repeats: true, // 매주 반복
          allowWhileIdle: true, // 기기 유휴 상태여도 알림 허용
        ),
      );
    }
  }
}
