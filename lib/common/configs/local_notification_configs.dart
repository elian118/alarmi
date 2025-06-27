import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

// flutter_local_notifications 플러그인 전역 인스턴스
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// 백그라운드에서 알림 탭/액션 처리 함수
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // 백그라운드에서 알림이 탭되거나 액션 버튼이 눌렸을 때 수행할 로직을 여기에 작성합니다.
  // 이 컨텍스트에서는 Flutter UI에 직접 접근할 수 없으므로,
  // SharedPreferences, 데이터베이스 업데이트, HTTP 요청 등 비동기 작업에 적합합니다.

  // notificationResponse.actionId를 사용하여 어떤 액션이 눌렸는지 확인할 수 있습니다.
  print('백그라운드 알림 액션 ID: ${notificationResponse.actionId}');

  // 예를 들어, 특정 액션에 따라 데이터 업데이트
  if (notificationResponse.actionId == 'id_1') {
    print('Action 1이 백그라운드에서 실행되었습니다.');
    // await SharedPreferences.getInstance().then((prefs) => prefs.setBool('action1_handled', true));
  }
}

class LocalNotificationService {
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
              ],
              options: <DarwinNotificationCategoryOption>{
                DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
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
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    // flutter_local_notifications iOS 권한 요청 설정
    final status = await Permission.notification.status;
    if (status.isDenied || status.isLimited || status.isPermanentlyDenied) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }

    // FlutterLocalNotificationsPlugin 초기화
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (
        NotificationResponse notificationResponse,
      ) async {
        // 알림을 탭하거나 액션 버튼을 눌렀을 때의 동작 정의
        // notificationResponse.actionId를 사용하여 어떤 액션이 눌렸는지 확인할 수 있습니다.
        print('Notification action ID: ${notificationResponse.actionId}');
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
    await flutterLocalNotificationsPlugin.show(
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

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
