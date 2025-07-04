import 'dart:async';
import 'dart:isolate';

import 'package:alarmi/common/consts/app_uuid.dart';
import 'package:alarmi/common/consts/raw_data/bells.dart';
import 'package:alarmi/common/consts/raw_data/haptic_patterns.dart';
import 'package:alarmi/features/alarm/models/bell.dart';
import 'package:alarmi/utils/vibrate_utils.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vibration/vibration_presets.dart';

// 싱글톤 AudioPlayer 인스턴스
final AudioPlayer _audioPlayer = AudioPlayer();

class NotificationController {
  static ReceivedAction? initialAction;
  static Timer? hapticTimer;

  static Future<void> initAwesomeNotifications() async {
    await AwesomeNotifications().initialize(null, [
      NotificationChannel(
        channelKey: 'my_alarm_channel',
        channelName: '내 알람',
        channelDescription: '사용자 전용 주기적 기상 알람',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
        playSound: false, // 기본 벨소리 재생 차단
        enableVibration: false, // 기본 진동 패턴 재생 차단
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

    // // 알림 액션 리스너 설정(알림 끄기 버튼 등)
    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
    );

    initialAction = await AwesomeNotifications().getInitialNotificationAction(
      removeFromActionEvents: false,
    );
  }

  static ReceivePort? receivePort;

  // 알림이 화면에 표시될 때 호출될 메서드 추가
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

    if (receivedNotification.channelKey == 'my_alarm_channel' &&
        receivedNotification.id != null) {
      final String? soundAssetPath =
          receivedNotification.payload?['soundAssetPath'];
      final String? hapticPattern =
          receivedNotification.payload?['hapticPattern'];

      if (soundAssetPath != null) {
        if (kDebugMode) {
          print('알람 표시 시 playAlarmSound 호출 시도: $soundAssetPath');
        }
        await playAlarmSound(receivedNotification.id!, soundAssetPath);
        if (kDebugMode) {
          print('알람 표시 시 playAlarmSound 호출 완료');
        }
      }

      if (hapticPattern != null) {
        if (kDebugMode) {
          print('알람 표시 시 playHaptic 호출 시도: $hapticPattern');
        }
        await playHaptic(receivedNotification.id!, hapticPattern);
        if (kDebugMode) {
          print('알람 표시 시 playHaptic 호출 완료');
        }
      }
    }
  }

  @pragma('vm:entry-point') // 백그라운드 실행을 위한 필수 어노테이션
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    int alarmId = receivedAction.id!;
    print(
      'onActionReceivedMethod 호출됨. ID: $alarmId, Channel: ${receivedAction.channelKey}, Button: ${receivedAction.buttonKeyPressed}',
    );

    // '알람 끄기' 버튼이 눌렸을 때
    if (receivedAction.channelKey == 'my_alarm_channel' &&
        receivedAction.buttonKeyPressed == 'stop_alarm') {
      if (kDebugMode) {
        print('알람 중지 버튼이 눌렸습니다.');
      }
      await AwesomeNotifications().dismiss(receivedAction.id!); // 알림 제거
      await stopAlarmSound(); // 재생 중지
      await stopHaptic(); // 진동 중지
    }
  }

  @pragma('vm:entry-point')
  static Future<void> playAlarmSound(int alarmId, String assetPath) async {
    try {
      int maxMinutes = 15;

      if (kDebugMode) {
        print('playAlarmSound 시작: $assetPath');
      }
      await _audioPlayer.setAsset(assetPath);
      await _audioPlayer.setLoopMode(LoopMode.one); // 반복 재생 설정
      await _audioPlayer.play();
      if (kDebugMode) {
        print('재생 시작');
      }

      // 15분 후 자동 알람 중지
      Future.delayed(maxMinutes.minutes, () async {
        if (_audioPlayer.playing) {
          await stopAlarmSound();
          await stopHaptic();
          if (kDebugMode) {
            print('$maxMinutes분 경과, 알람 자동 중지');
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

  @pragma('vm:entry-point')
  static playHaptic(int alarmId, String hapticPattern) async {
    VibrationPreset preset =
        hapticPatterns.where((h) => h.id == hapticPattern).first.preset;
    hapticTimer = VibrateUtils.playRepeatVibration(preset);
  }

  // stopAlarmSound 함수도 Top-level 유지
  static Future<void> stopAlarmSound() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.stop();
    }
  }

  static Future<void> stopHaptic() async {
    VibrateUtils.stopRepeatVibration(hapticTimer);
  }

  // 테스트 알람 설정 매주 월~금 지금부터 5초 뒤 반복 알람
  static Future<void> setTestWeeklyAlarm({
    required String soundAssetPath,
    required String hapticPattern,
  }) async {
    DateTime testDateTime = DateTime.now().add(5.seconds); // 5초 뒤 시간

    // 기존 알람 있다면 모두 취소해 중복 방지 - 테스트 전용
    // await AwesomeNotifications().cancelSchedulesByChannelKey(
    //   'my_alarm_channel',
    // );

    // 월~금까지 각각 알림 설정
    for (int i = DateTime.monday; i <= DateTime.friday; i++) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: i,
          channelKey: 'my_alarm_channel',
          title: '(test) 기상 시간입니다!',
          body: '상쾌한 아침을 시작하세요.',
          payload: {
            'day': i.toString(),
            'soundAssetPath': soundAssetPath,
            'hapticPattern': hapticPattern,
          },
          category: NotificationCategory.Alarm,
          notificationLayout: NotificationLayout.BigPicture,
          bigPicture: 'asset://assets/images/backgrounds/alarm_big.png',
          wakeUpScreen: true,
          fullScreenIntent: true, // 안드로이드 12 이상 전용 - 전체화면 인텐트
          locked: true, // 알림 스와이프 방지
          // customSound: 'resource://raw/$fileName', // 불필요
          customSound: null,
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'stop_alarm',
            label: '알림 끄기',
            autoDismissible: true, // 버튼 클릭 시 알림 자동 닫힘
            actionType: ActionType.Default,
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

  static Future<List<int>> setWeeklyAlarm({
    required List<int> weekdays,
    required DateTime dateTime,
    required String? bellId,
    required String? vibrateId,
  }) async {
    List<int> alarmKeys = [];
    Bell? bell = bells.where((bell) => bell.id == bellId).first;

    // 반복 주간
    for (int week in weekdays) {
      int uId = appUuid.v4().hashCode.abs();
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: uId,
          channelKey: 'my_alarm_channel',
          title: '기상 시간입니다!',
          body: '상쾌한 아침을 시작하세요.',
          payload: {
            'day': week.toString(),
            'soundAssetPath': bell.path,
            'hapticPattern': vibrateId,
          },
          category: NotificationCategory.Alarm,
          notificationLayout: NotificationLayout.BigPicture,
          bigPicture: 'asset://assets/images/backgrounds/alarm_big.png',
          wakeUpScreen: true,
          fullScreenIntent: true, // 안드로이드 12 이상 전용 - 전체화면 인텐트
          locked: true, // 알림 스와이프 방지
          customSound: null,
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'stop_alarm',
            label: '알림 끄기',
            autoDismissible: true, // 버튼 클릭 시 알림 자동 닫힘
            actionType: ActionType.Default,
          ),
        ],
        schedule: NotificationCalendar(
          weekday: week,
          hour: dateTime.hour,
          minute: dateTime.minute,
          second: dateTime.second,
          millisecond: dateTime.millisecond,
          repeats: true, // 매주 반복
          allowWhileIdle: true, // 기기 유휴 상태여도 알림 허용
        ),
      );
      alarmKeys.add(uId);
    }

    return alarmKeys;
  }
}
