import 'package:alarmi/common/widgets/main_navigation_screen.dart';
import 'package:alarmi/features/auth/repos/authentication_repo.dart';
import 'package:alarmi/features/test/screens/alarm_test_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/sign_up_screen.dart';

final routerProvider = Provider((ref) {
  return GoRouter(
    initialLocation: '/main',
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
      GoRoute(
        name: MainNavigationScreen.routeName,
        path: '/:tab(main|new|team)',
        builder: (context, state) {
          final tab = state.pathParameters['tab']!;
          return MainNavigationScreen(tab: tab);
        },
      ),
      GoRoute(
        name: AlarmTestScreen.routeName,
        path: AlarmTestScreen.routeURL,
        builder: (context, state) => const AlarmTestScreen(),
      ),
    ],
  );
});
