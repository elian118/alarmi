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
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
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
        // playSound: true,
        // enableVibration: true,
        playSound: false,
        enableVibration: false,
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

  // 알람이 떴을 때 실행될 로직
  // 이 로직은 사용자가 알림을 확인하는 순간에 실행되므로,
  // 기기 화면이 꺼진 상태에서는 알림음을 들을 수 없고 화면을 켜야만 들을 수 있다.
  /* todo 제일 좋은 방법은 AwesomeNotifications이 OS 트리거를 작동시킬 수 있도록
    NotificationContent.customSound 에 음원파일을 넣는 방식이다.
    이렇게 하면 화면이 꺼진 상태에서도 들을 수 있지만,
    메서드 안에서 재생하는 로직은 전부 제거해야 소리가 중복되는 걸 막을 수 있다.
    todo 단, 이 경우, 비활성 알림을 판단해 재생을 중간에 차단하는 로직처리도 불가하다.
    사용자가 비활성 처리하면 실제 예약된 알림 목록에서는 아예 삭제처리하도록 변경해야 한다.
    */
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
    // todo OS 알림 트리거 사용 시 아래 재생 로직 제거하기
    if (receivedNotification.channelKey == 'my_alarm_channel' &&
        receivedNotification.id != null) {
      final String? soundAssetPath =
          receivedNotification.payload?['soundAssetPath'];
      final String? hapticPattern =
          receivedNotification.payload?['hapticPattern'];
      final String? currentVolume =
          receivedNotification.payload?['currentVolume'];

      final double doubleCurrentVolume = double.parse(currentVolume ?? '0.8');

      if (soundAssetPath != null) {
        if (kDebugMode) {
          print('알람 표시 시 playAlarmSound 호출 시도: $soundAssetPath');
        }
        await playAlarmSound(
          receivedNotification.id!,
          soundAssetPath,
          doubleCurrentVolume,
        );
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

    if (kDebugMode) {
      print(
        'onActionReceivedMethod 호출됨. ID: $alarmId, Channel: ${receivedAction.channelKey}, Button: ${receivedAction.buttonKeyPressed}',
      );
    }
    final currentVolume = receivedAction.payload?['currentVolume'];
    final doubleCurrentVolume = double.parse(currentVolume ?? '0.8');

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
      await stopAlarmSound(doubleCurrentVolume); // 재생 중지
      await stopHaptic(); // 진동 중지
    }
  }

  @pragma('vm:entry-point')
  static Future<void> playAlarmSound(
    int alarmId,
    String assetPath,
    double currentVolume,
  ) async {
    try {
      int maxMinutes = 15;
      // 1. 현재 볼륨 저장
      final currentVolume = await FlutterVolumeController.getVolume();
      // 2. 알람 재생 전에 시스템 볼륨을 최대로 설정
      await FlutterVolumeController.setVolume(1.0); // 0.0 to 1.0

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
          await stopAlarmSound(currentVolume ?? 0.8);
          await stopHaptic();
          if (kDebugMode) {
            print('$maxMinutes분 경과, 알람 자동 중지');
          }
          await AwesomeNotifications().dismiss(alarmId);
          await FlutterVolumeController.setVolume(
            currentVolume ?? 0.8,
          ); // 원래 볼륨으로 복원
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
  static Future<void> stopAlarmSound(double currentVolume) async {
    if (_audioPlayer.playing) {
      await _audioPlayer.stop();
    }
    FlutterVolumeController.setVolume(currentVolume);
  }

  static Future<void> stopHaptic() async {
    VibrateUtils.stopRepeatVibration(hapticTimer);
  }

  static Future<void> stopTestAlarms(double currentVolume) async {
    // ID 1~5 테스트 알람만 제거
    for (int i = DateTime.monday; i <= DateTime.sunday; i++) {
      await AwesomeNotifications().cancel(i); // 특정 ID의 알람 스케줄 취소
      if (kDebugMode) {
        print('스케줄(테스트 알람 ID: $i) 취소됨.');
      }
    }
    FlutterVolumeController.setVolume(currentVolume);
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
    final currentVolume = await FlutterVolumeController.getVolume();

    await NotificationController.stopTestAlarms(
      currentVolume ?? 0.8,
    ); // 중복되는 ID 1~5 테스트 알람만 제거
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
            'currentVolume': currentVolume.toString() ?? '0.8',
          },
          category: NotificationCategory.Alarm,
          notificationLayout: NotificationLayout.BigPicture,
          bigPicture: 'asset://assets/images/backgrounds/alarm_big.png',
          wakeUpScreen: true,
          fullScreenIntent: true, // 안드로이드 12 이상 전용 - 전체화면 인텐트
          locked: true, // 알림 스와이프 방지
          // customSound: 'resource://raw/$fileName',
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
          // customSound: 'resource://raw/$fileName',
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
