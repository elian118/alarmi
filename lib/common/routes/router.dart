import 'package:alarmi/common/configs/notification_initialize.dart';
import 'package:alarmi/features/alarm/screens/alarms_screen.dart';
import 'package:alarmi/features/alarm/screens/create_alarm_screen.dart';
import 'package:alarmi/features/auth/repos/authentication_repo.dart';
import 'package:alarmi/features/auth/screens/login_screen.dart';
import 'package:alarmi/features/auth/screens/sign_up_screen.dart';
import 'package:alarmi/features/main/screens/main_screen.dart';
import 'package:alarmi/features/missions/screens/shaking_clams_screen.dart';
import 'package:alarmi/features/missions/services/mission_status_service.dart';
import 'package:alarmi/features/onboarding/screens/onboard_screen.dart';
import 'package:alarmi/features/test/screens/alarm_test_screen.dart';
import 'package:alarmi/utils/route_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider((ref) {
  return GoRouter(
    // initialLocation: MainScreen.routeURL,
    initialLocation: OnboardScreen.routeURL,
    redirect: (context, state) async {
      final isLoggedIn = ref.read(authRepo).isLoggedIn;

      if (!isLoggedIn) {
        if (state.uri.path != SignUpScreen.routeURL &&
            state.uri.path != LoginScreen.routeURL) {
          return LoginScreen.routeURL;
        }
      }

      // 기상 미션 알림이 왔는지 확인
      if (NotificationInitialize.initialAction != null) {
        final bool isWakeUpMissionNotification =
            NotificationInitialize.initialAction!.payload?['isWakeUpMission'] ==
            'true';

        // 미션 완료 여부 확인
        final bool missionAlreadyCompleted =
            await MissionStatusService.isWakeUpMissionCompleted();

        if (isWakeUpMissionNotification && !missionAlreadyCompleted) {
          // 리다이렉트 후 initialAction을 null로 설정 - 중복 처리 방지
          NotificationInitialize.initialAction = null;
          debugPrint('미완료 기상 미션 감지. ${ShakingClamsScreen.routeURL}로 리다이렉트');
          return ShakingClamsScreen.routeURL;
        }
        // 초기화
        NotificationInitialize.initialAction = null;
      }
      return null; // 그 외 리다이렉트 없음
    },
    routes: [
      GoRoute(
        name: SignUpScreen.routeName,
        path: SignUpScreen.routeURL,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        name: LoginScreen.routeName,
        path: LoginScreen.routeURL,
        builder: (context, state) => const LoginScreen(),
      ),
      /*GoRoute(
        name: MainNavigationScreen.routeName,
        path: MainNavigationScreen.routeURL,
        pageBuilder: (context, state) {
          final tab = state.pathParameters['tab']!;
          return goRouteOpacityPageBuilder(
            context,
            state,
            MainNavigationScreen(tab: tab),
          );
        },
      ),*/
      GoRoute(
        name: MainScreen.routeName,
        path: MainScreen.routeURL,
        pageBuilder:
            (context, state) =>
                goRouteOpacityPageBuilder(context, state, MainScreen()),
      ),
      GoRoute(
        name: OnboardScreen.routeName,
        path: OnboardScreen.routeURL,
        pageBuilder:
            (context, state) =>
                goRouteOpacityPageBuilder(context, state, OnboardScreen()),
      ),
      GoRoute(
        name: AlarmsScreen.routeName,
        path: AlarmsScreen.routeURL,
        pageBuilder:
            (context, state) =>
                goRouteOpacityPageBuilder(context, state, AlarmsScreen()),
      ),
      GoRoute(
        name: AlarmTestScreen.routeName,
        path: AlarmTestScreen.routeURL,
        builder: (context, state) => const AlarmTestScreen(),
      ),
      GoRoute(
        name: CreateAlarmScreen.routeName,
        path: '/:type(my|team)/:alarmId',
        pageBuilder: (context, state) {
          final type = state.pathParameters['type']!;
          final alarmId = state.pathParameters['alarmId'];

          return goRouteOpacityPageBuilder(
            context,
            state,
            CreateAlarmScreen(type: type, alarmId: alarmId),
          );
        },
      ),
      GoRoute(
        name: ShakingClamsScreen.routeName,
        path: ShakingClamsScreen.routeURL,
        builder: (context, state) => const ShakingClamsScreen(),
      ),
    ],
  );
});
