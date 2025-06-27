import 'package:alarm/alarm.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

// 백그라운드에서 알림 탭/액션 처리 함수
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // 백그라운드에서 알림이 탭되거나 액션 버튼이 눌렸을 때 수행할 로직을 여기에 작성합니다.
  // 이 컨텍스트에서는 Flutter UI에 직접 접근할 수 없으므로,
  // SharedPreferences, 데이터베이스 업데이트, HTTP 요청 등 비동기 작업에 적합합니다.

  print(notificationResponse);
  // notificationResponse.actionId를 사용하여 어떤 액션이 눌렸는지 확인할 수 있습니다.
  print('백그라운드 알림 액션 ID: ${notificationResponse.actionId}');
}

class LocalNotificationService {
  // flutter_local_notifications 플러그인 전역 인스턴스
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static FlutterLocalNotificationsPlugin get instance =>
      _flutterLocalNotificationsPlugin;

  static Future<void> initializeNotifications() async {
    // Android 알림 초기 설정
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS/macOS 알림 초기 설정
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: false, // 필요에 따라 true/false 설정
          requestBadgePermission: false,
          requestSoundPermission: false,
          notificationCategories: [
            DarwinNotificationCategory(
              'demoCategory', // 이 ID는 알림을 보낼 때 사용됩니다.
              actions: <DarwinNotificationAction>[
                DarwinNotificationAction.plain('id_1', 'Action 1'),
                DarwinNotificationAction.plain(
                  'id_2',
                  'Action 2',
                  options: <DarwinNotificationActionOption>{
                    DarwinNotificationActionOption.destructive,
                  },
                ),
                DarwinNotificationAction.plain(
                  'id_3',
                  'Action 3',
                  options: <DarwinNotificationActionOption>{
                    DarwinNotificationActionOption.foreground,
                  },
                ),
                DarwinNotificationAction.plain(
                  'stop_alarm_action',
                  '알람 중지',
                  options: <DarwinNotificationActionOption>{
                    DarwinNotificationActionOption.destructive,
                    DarwinNotificationActionOption.foreground,
                  },
                ),
              ],
              options: <DarwinNotificationCategoryOption>{
                DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
                DarwinNotificationCategoryOption.customDismissAction,
                DarwinNotificationCategoryOption.allowInCarPlay,
              },
            ),
            // 필요한 경우 다른 카테고리를 추가할 수 있습니다.
          ],
        );

    // 모든 플랫폼에 대한 초기화 설정 통합
    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin, // Darwin 설정 적용
          macOS: initializationSettingsDarwin,
        );

    // flutter_local_notifications 안드로이드 13 이상 권한 요청 설정
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    // flutter_local_notifications iOS 권한 요청 설정
    final status = await Permission.notification.status;
    if (status.isDenied || status.isLimited || status.isPermanentlyDenied) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }

    // FlutterLocalNotificationsPlugin 초기화
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // 알림을 탭하거나 액션 버튼을 눌렀을 때의 동작 정의
        if (response.actionId == 'stop_alarm_action') {
          // 인자를 직접 넘길 수 없으므로, 로컬 스토리지에서 알람마다 설정된 id를 가져와야 할 수 있다.
          await Alarm.stop(42);
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  // 알림 보내기
  static Future<void> showSimpleNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'your_channel_id', // 고유한 채널 ID
          'Your Channel Name', // 사용자에게 보여질 채널 이름
          channelDescription: 'Your channel description', // 채널 설명
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
        );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  // iOS 액션 버튼 알림 보내기 (demoCategory 사용)
  static Future<void> showNotificationWithActions({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
          categoryIdentifier: 'demoCategory',
        ); // 정의한 카테고리 ID 사용
    const NotificationDetails notificationDetails = NotificationDetails(
      iOS: darwinNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'scheduled_channel_id',
          'Scheduled Notifications',
          channelDescription: '채널 설명',
          importance: Importance.max,
          priority: Priority.high,
        );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local), // tz.local = 'Asia.Seoul'
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // uiLocalNotificationDateInterpretation:
      //     UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }

  static Future<void> showStopAlarmNotification(int alarmId) async {
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
          categoryIdentifier:
              'alarm_category', // Use the category defined in initialization
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      iOS: darwinNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      alarmId, // Use the same ID as the alarm to link them
      '알람이 울리고 있습니다!',
      '알람을 중지하려면 "알람 중지" 버튼을 누르세요.',
      platformChannelSpecifics,
      payload: 'alarm_stop_payload_$alarmId',
    );
  }
}
