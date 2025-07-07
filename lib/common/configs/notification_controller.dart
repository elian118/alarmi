import 'dart:async';

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
        playSound: true,
        enableVibration: true,
        // vibrationPattern: , // 진동 패턴
        // playSound: false,
        // enableVibration: false,
        soundSource: 'resource://raw/movement',
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

  @pragma('vm:entry-point')
  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    int alarmId = receivedNotification.id!;

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
    if (receivedAction.channelKey == 'my_alarm_channel' &&
        (receivedAction.buttonKeyPressed == 'stop_alarm' ||
            receivedAction.actionType == ActionType.Default)) {
      if (kDebugMode) {
        if (receivedAction.buttonKeyPressed == 'stop_alarm') {
          print('알람 중지 버튼이 눌렸습니다.');
        } else if (receivedAction.actionType == ActionType.Default) {
          print('알림 메시지 본문이 눌렸습니다. (알람 중지)');
        }
      }

      await AwesomeNotifications().dismiss(receivedAction.id!); // 알림 제거
      // await stopAlarmSound(); // 재생 중지
      // await stopHaptic(); // 진동 중지
    }
  }

  @pragma('vm:entry-point')
  static Future<void> playAlarmSound(
    int alarmId,
    String assetPath,
    double currentVolume,
  ) async {
    try {
      if (kDebugMode) {
        print('playAlarmSound 시작: $assetPath');
      }
      await _audioPlayer.setAsset(assetPath);
      await _audioPlayer.setLoopMode(LoopMode.one); // 반복 재생 설정
      await _audioPlayer.play();
      if (kDebugMode) {
        print('재생 시작');
      }
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
  static Future<void> stopAlarmSound(
    // double currentVolume
  ) async {
    if (_audioPlayer.playing) {
      await _audioPlayer.stop();
    }
  }

  static Future<void> stopHaptic() async {
    VibrateUtils.stopRepeatVibration(hapticTimer);
  }

  static Future<void> stopTestAlarms() async {
    // ID 1~5 테스트 알람만 제거
    for (int i = DateTime.monday; i <= DateTime.sunday; i++) {
      await AwesomeNotifications().cancel(i); // 특정 ID의 알람 스케줄 취소
      if (kDebugMode) {
        print('스케줄(테스트 알람 ID: $i) 취소됨.');
      }
    }
  }

  // 예약된 알람들 비활성화(취소)하기
  static void stopScheduledAlarm(List<int> alarmKeys) async {
    for (var alarmKey in alarmKeys) {
      AwesomeNotifications().cancel(alarmKey);
      if (kDebugMode) {
        print('스케줄(ID: $alarmKey) 취소됨.');
      }
    }
  }

  // 테스트 알람 설정 매주 월~금 지금부터 5초 뒤 반복 알람
  static Future<void> setTestWeeklyAlarm({
    required String soundAssetPath,
    required String hapticPattern,
  }) async {
    DateTime testDateTime = DateTime.now().add(5.seconds); // 5초 뒤 시간

    await NotificationController.stopTestAlarms(); // 중복되는 ID 1~5 테스트 알람만 제거
    String fileName = soundAssetPath.split('/').last.split('.').first;

    print('resource://raw/$fileName');
    // 월~일까지 각각 알림 설정
    for (int i = DateTime.monday; i <= DateTime.sunday; i++) {
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
          customSound: 'resource://raw/$fileName',
          // customSound: 'resource://raw/heavy_rain',
          // customSound: null,
          chronometer: Duration.zero, // 카운트 시작 점
          timeoutAfter: Duration(minutes: 15), // 키운팅 이후 15분 뒤 만료
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
    String fileName = bell.path.split('/').last.split('.').first;

    print('resource://raw/$fileName');

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
            'alarmKey': uId.toString(),
          },
          category: NotificationCategory.Alarm,
          notificationLayout: NotificationLayout.BigPicture,
          bigPicture: 'asset://assets/images/backgrounds/alarm_big.png',
          wakeUpScreen: true,
          fullScreenIntent: true, // 안드로이드 12 이상 전용 - 전체화면 인텐트
          locked: true, // 알림 스와이프 방지
          customSound: 'resource://raw/$fileName',
          // customSound: 'resource://raw/heavy_rain',
          // customSound: null,
          chronometer: Duration.zero,
          timeoutAfter: Duration(minutes: 15),
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
