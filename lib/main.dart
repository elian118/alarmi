import 'package:alarmi/common/widgets/cst_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/configs/inner_database.dart';
import 'common/configs/notification_initialize.dart';
import 'common/routes/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // 세로모드 고정
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(ProviderScope(child: AlarmiApp()));
}

class AlarmiApp extends ConsumerStatefulWidget {
  const AlarmiApp({super.key});

  @override
  ConsumerState<AlarmiApp> createState() => _AlarmiAppState();
}

class _AlarmiAppState extends ConsumerState<AlarmiApp> {
  late Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = _initializeDependencies();
  }

  Future<void> _initializeDependencies() async {
    // 개인설정 - 필요시 활성화
    // final personalSettings = await SharedPreferences.getInstance();
    // final setRepository = ConfigRepository(personalSettings);

    await InnerDatabase.initialize();
    await NotificationInitialize.initAwesomeNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Text('앱 초기화 중 오류가 발생했습니다: ${snapshot.error}'),
                ),
              ),
            );
          } else {
            // 오류 없이 완료되면 앱 라우터 설정 반환
            return MaterialApp.router(
              localizationsDelegates: <LocalizationsDelegate<Object>>[
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [Locale('en', 'US'), Locale('ko', 'KR')],
              routerConfig: ref.watch(routerProvider),
              debugShowCheckedModeBanner: false,
              showPerformanceOverlay: true, // 랜더링 테스트 시 활성화
              title: 'Alarmi',
              themeMode: ThemeMode.system,
              // todo: 언제 한 번 날 잡아서 커스덤 테마 적용하기
              theme: ThemeData(
                fontFamily: "Pretendard",
                colorScheme: ColorScheme.fromSwatch().copyWith(
                  primary: const Color(0xFF3E7EFF),
                ),
              ),
            );
          }
        } else {
          // 초기화가 아직 진행 중일 때는 로딩 스플래시
          return MaterialApp(
            home: Scaffold(body: CstLoading()),
            debugShowCheckedModeBanner: false,
          );
        }
      },
    );
  }
}
