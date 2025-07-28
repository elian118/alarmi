import 'dart:ui';

import 'package:alarmi/common/configs/notification_initialize.dart';
import 'package:alarmi/features/alarm/screens/alarms_screen.dart';
import 'package:alarmi/features/alarm/screens/create_alarm_screen.dart';
import 'package:alarmi/features/alarm/widgets/bell_settings_dialog.dart';
import 'package:alarmi/features/alarm/widgets/vibrate_settings_dialog.dart';
import 'package:alarmi/features/main/screens/main_screen.dart';
import 'package:alarmi/features/missions/screens/shaking_clams_screen.dart';
import 'package:alarmi/features/missions/services/mission_status_service.dart';
import 'package:alarmi/features/onboarding/screens/onboard_screen.dart';
import 'package:alarmi/features/onboarding/services/character_service.dart';
import 'package:alarmi/features/test/screens/alarm_test_screen.dart';
import 'package:alarmi/utils/route_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider((ref) {
  return GoRouter(
    initialLocation: '${MainScreen.routeURL}/null',
    redirect: (context, state) async {
      // todo 추후 로그인 절차가 필요해지면 활성화
      // final isLoggedIn = ref.read(authRepo).isLoggedIn;

      // if (!isLoggedIn) {
      //   if (state.uri.path != SignUpScreen.routeURL &&
      //       state.uri.path != LoginScreen.routeURL) {
      //     return LoginScreen.routeURL;
      //   }
      // }

      bool isThereNamedCharacter =
          await CharacterService.getCharacterNamed() != null;
      // 고양이 이름이 지어졌는지 확인
      if (isThereNamedCharacter) {
        String? name = await CharacterService.getCharacterNamed();
        String? personality = await CharacterService.getCharacterPersonality();
        int? color = await CharacterService.getCharacterColor();
        debugPrint(
          'character name: $name ($personality) - ${color?.toRadixString(16)}',
        );
      } else {
        debugPrint('character name: null');
        return OnboardScreen.routeURL;
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
        name: MainScreen.routeName,
        path: '${MainScreen.routeURL}/:situation',
        pageBuilder: (context, state) {
          final situation = state.pathParameters['situation'];

          return goRouteOpacityPageBuilder(
            context,
            state,
            MainScreen(situationParam: situation),
          );
        },
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

          return goRouteSlidePageBuilder(
            context,
            state,
            target: CreateAlarmScreen(type: type, alarmId: alarmId),
            // end: Offset(0.0, 0.1),
          );
        },
      ),
      GoRoute(
        name: BellSettingsDialog.routeName,
        path: BellSettingsDialog.routeURL,
        pageBuilder: (context, state) {
          final Map<String, dynamic>? extras =
              state.extra as Map<String, dynamic>?;

          final Function(String?, double) onSaveBellSettings =
              extras?['onSaveBellSettings'] as Function(String?, double);
          final String? selectedBellId = extras?['selectedBellId'] as String?;

          return goRouteSlidePageBuilder(
            context,
            state,
            target: BellSettingsDialog(
              onSaveBellSettings: onSaveBellSettings,
              selectedBellId: selectedBellId,
            ),
            begin: Offset(1.0, 0.0),
          );
        },
      ),
      GoRoute(
        name: VibrateSettingsDialog.routeName,
        path: VibrateSettingsDialog.routeURL,
        pageBuilder: (context, state) {
          final Map<String, dynamic>? extras =
              state.extra as Map<String, dynamic>?;

          final bool isActivatedVibrate = extras?['isActivatedVibrate'] as bool;
          final Function() toggleActivatedVibrate =
              extras?['toggleActivatedVibrate'] as Function();
          final String? selectedVibrateId =
              extras?['selectedVibrateId'] as String?;
          final Function(String?) onSaveVibrateSettings =
              extras?['onSaveVibrateSettings'] as Function(String?);

          return goRouteSlidePageBuilder(
            context,
            state,
            target: VibrateSettingsDialog(
              isActivatedVibrate: isActivatedVibrate,
              toggleActivatedVibrate: toggleActivatedVibrate,
              selectedVibrateId: selectedVibrateId,
              onSaveVibrateSettings: onSaveVibrateSettings,
            ),
            begin: Offset(1.0, 0.0),
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
