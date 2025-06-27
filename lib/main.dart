import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'common/configs/local_notification_configs.dart';
import 'common/routes/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // runApp() 실행 전에 위젯 바인딩

  tz.initializeTimeZones(); // 타임존 데이터 초기화

  // 세로모드 고정
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // final personalSettings = await SharedPreferences.getInstance();
  // final setRepository = ConfigRepository(personalSettings);

  // 권한 요청
  await [
    Permission.audio,
    Permission.notification,
    Permission.scheduleExactAlarm,
  ].request();

  await LocalNotificationService.initializeNotifications(); // flutter_local_notifications 초기 설정
  await Alarm.init(); // 알람 패키지 초기화

  runApp(ProviderScope(child: AlarmiApp()));
}

class AlarmiApp extends ConsumerWidget {
  const AlarmiApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: ref.watch(routerProvider),
      debugShowCheckedModeBanner: false,
      title: 'Alarmi',
      // themeMode: ref.watch(configProvider).darkMode ? ThemeMode.dark : ThemeMode.light,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        fontFamily: "Pretendard",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
    );
  }
}
