import 'package:alarmi/features/missions/layers/guide_layer.dart';
import 'package:alarmi/features/missions/layers/mission_completed_layer.dart';
import 'package:alarmi/features/missions/layers/mission_layer.dart';
import 'package:alarmi/utils/lottie_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../test/screens/alarm_test_screen.dart';
import '../layers/mission_failed_layer.dart';
import '../vms/shaking_clams_view_model.dart';

class ShakingClamsScreen extends ConsumerStatefulWidget {
  static const String routeName = 'shaking_clams';
  static const String routeURL = '/shaking_clams';

  const ShakingClamsScreen({super.key});

  @override
  ConsumerState<ShakingClamsScreen> createState() => _ShakingClamsScreenState();
}

class _ShakingClamsScreenState extends ConsumerState<ShakingClamsScreen>
    with SingleTickerProviderStateMixin {
  late final shakingClamsNotifier;
  late final AnimationController bgLottieController;

  @override
  void initState() {
    shakingClamsNotifier = ref.read(shakingClamsViewProvider.notifier);
    bgLottieController = AnimationController(vsync: this);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      shakingClamsNotifier.initStates();
    });
    super.initState();
  }

  @override
  void dispose() {
    bgLottieController.dispose();
    shakingClamsNotifier.disposeViewModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shakingClamsState = ref.watch(shakingClamsViewProvider);
    bool isPlayingMission =
        shakingClamsState.showMission &&
        !(shakingClamsState.isCompleted) &&
        !shakingClamsState.isFailed;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgrounds/mission_shaking_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgrounds/mission_shaking_bg_floor.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: buildLottieWidget(
              assetPath: 'assets/lotties/mission_shaking_bg_light.json',
              controller: bgLottieController,
              repeat: true,
              fit: BoxFit.fill,
            ),
          ),
          Positioned.fill(
            child: buildLottieWidget(
              assetPath: 'assets/lotties/mission_shaking_bg_floor.json',
              controller: bgLottieController,
              repeat: true,
              fit: BoxFit.fill,
            ),
          ),
          Positioned.fill(
                child: Container(color: Colors.black.withValues(alpha: 0.6)),
              )
              .animate(target: isPlayingMission ? 1 : 0)
              .fadeOut(begin: 1.0, duration: 0.4.seconds),
          IgnorePointer(
            ignoring: !isPlayingMission,
            child: MissionLayer()
                .animate(target: isPlayingMission ? 1 : 0)
                .fadeIn(begin: 0.0, duration: 0.4.seconds),
          ),
          IgnorePointer(
            ignoring: isPlayingMission,
            child: MissionCompletedLayer()
                .animate(target: shakingClamsState.isCompleted ? 1 : 0)
                .fadeIn(begin: 0.0, duration: 0.4.seconds),
          ),
          IgnorePointer(
            ignoring: isPlayingMission,
            child: MissionFailedLayer()
                .animate(target: shakingClamsState.isFailed ? 1 : 0)
                .fadeIn(begin: 0.0, duration: 0.4.seconds),
          ),
          IgnorePointer(
            ignoring: shakingClamsState.showMission,
            child: GuideLayer()
                .animate(
                  target:
                      shakingClamsState.showMission ||
                              (!shakingClamsState.showMission &&
                                  (shakingClamsState.isCompleted ||
                                      shakingClamsState.isCompleting ||
                                      shakingClamsState.isFailed))
                          ? 1
                          : 0,
                )
                .fadeOut(begin: 1.0, duration: 0.4.seconds),
          ),
          // 테스트 스크린으로 이동하는 버튼 - 임시
          Positioned(
            top: 50,
            right: 20,
            child: GestureDetector(
              onTap: () => context.push(AlarmTestScreen.routeURL),
              child: Image.asset(
                'assets/images/characters/thumb.png',
              ).animate().scale(duration: 0.5.seconds, curve: Curves.easeInOut),
            ),
          ),
        ],
      ),
    );
  }
}
