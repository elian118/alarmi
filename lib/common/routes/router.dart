import 'package:alarmi/features/alarm/screens/alarms_screen.dart';
import 'package:alarmi/features/alarm/screens/create_alarm_screen.dart';
import 'package:alarmi/features/auth/repos/authentication_repo.dart';
import 'package:alarmi/features/main/screens/main_screen.dart';
import 'package:alarmi/features/test/screens/alarm_test_screen.dart';
import 'package:alarmi/utils/route_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/sign_up_screen.dart';

final routerProvider = Provider((ref) {
  return GoRouter(
    initialLocation: MainScreen.routeURL,
    redirect: (context, state) {
      final isLoggedIn = ref.read(authRepo).isLoggedIn;
      if (!isLoggedIn) {
        if (state.uri.path != SignUpScreen.routeURL &&
            state.uri.path != LoginScreen.routeURL) {
          return LoginScreen.routeURL;
        }
      }
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
        path: '/:type(my|team)',
        pageBuilder: (context, state) {
          final type = state.pathParameters['type']!;
          return goRouteOpacityPageBuilder(
            context,
            state,
            CreateAlarmScreen(type: type),
          );
        },
      ),
    ],
  );
});
