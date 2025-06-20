import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/routes/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // runApp() 실행 전에 위젯 바인딩
  // 세로모드 고정
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // final personalSettings = await SharedPreferences.getInstance();
  // final setRepository = ConfigRepository(personalSettings);

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
