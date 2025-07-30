import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/features/missions/constants/enums/clam_animation_state.dart';
import 'package:alarmi/features/missions/vms/shaking_clams_view_model.dart';
import 'package:alarmi/utils/lottie_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShakingShell extends ConsumerStatefulWidget {
  const ShakingShell({super.key});

  @override
  ConsumerState<ShakingShell> createState() => _ShakingShellState();
}

class _ShakingShellState extends ConsumerState<ShakingShell>
    with TickerProviderStateMixin {
  late AnimationController _waitingLottieController;
  late AnimationController _weaklyShakingLottieController;
  late AnimationController _stronglyShakingLottieController;
  late AnimationController _shakingCompletedLottieController;

  @override
  void initState() {
    _waitingLottieController = AnimationController(
      vsync: this,
      duration: 1.seconds,
    );
    _weaklyShakingLottieController = AnimationController(
      vsync: this,
      duration: 1.seconds,
    );
    _stronglyShakingLottieController = AnimationController(
      vsync: this,
      duration: 1.seconds,
    );
    _shakingCompletedLottieController = AnimationController(
      vsync: this,
      duration: 2.seconds,
    );

    super.initState();
  }

  void _updateLottieAnimation(
    ClamAnimationState? oldState,
    ClamAnimationState newState,
  ) {
    _waitingLottieController.stop();
    _weaklyShakingLottieController.stop();
    _stronglyShakingLottieController.stop();
    _shakingCompletedLottieController.stop();

    switch (newState) {
      case ClamAnimationState.waiting:
        _waitingLottieController.repeat();
        break;
      case ClamAnimationState.weaklyShaking:
        _weaklyShakingLottieController.forward(from: 0.0).then((_) {
          if (mounted) {
            ref
                .read(shakingClamsViewProvider.notifier)
                .setClamAnimationState(ClamAnimationState.waiting);
          }
        });
        break;
      case ClamAnimationState.stronglyShaking:
        _stronglyShakingLottieController.forward(from: 0.0).then((_) {
          if (mounted) {
            ref
                .read(shakingClamsViewProvider.notifier)
                .setClamAnimationState(ClamAnimationState.waiting);
          }
        });
        break;
      case ClamAnimationState.opened:
        _shakingCompletedLottieController.forward(from: 0.0).then((_) {
          if (mounted) {
            ref
                .read(shakingClamsViewProvider.notifier)
                .setClamAnimationState(ClamAnimationState.opened);
          }
        });
        break;
    }
  }

  @override
  void dispose() {
    _waitingLottieController.dispose();
    _weaklyShakingLottieController.dispose();
    _stronglyShakingLottieController.dispose();
    _shakingCompletedLottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shakingClamsState = ref.watch(shakingClamsViewProvider);
    bool isPlayingMission =
        shakingClamsState.showMission &&
        !shakingClamsState.isCompleted &&
        !shakingClamsState.isFailed;

    final ClamAnimationState currentClamAnimationFromVM =
        shakingClamsState.currentClamAnimation;

    return Consumer(
      builder: (context, ref, child) {
        // ref.listen is safely placed inside the Consumer's builder
        ref.listen<ClamAnimationState>(
          shakingClamsViewProvider.select(
            (state) => state.currentClamAnimation,
          ),
          (prev, next) {
            if (mounted) {
              _updateLottieAnimation(prev, next);
            }
          },
        );
        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 40),
          child: GestureDetector(
            onTap: () {
              print('onTap');
              ref.read(shakingClamsViewProvider.notifier).handleShakeEvent();
            },
            child: SizedBox(
                  width: 330,
                  height: 360,
                  child: Stack(
                    children: [
                      !isPlayingMission ? Container() : Gaps.v48,
                      Align(
                        alignment: Alignment.center,
                        child: buildLottieWidget(
                          assetPath:
                              "assets/lotties/mission_shaking_seashell_waiting_2x_opti.json",
                          controller: _waitingLottieController,
                          repeat: true,
                          visible:
                              currentClamAnimationFromVM ==
                              ClamAnimationState.waiting,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: buildLottieWidget(
                          assetPath:
                              "assets/lotties/mission_shaking_seashell_weakly_2x_opti.json",
                          controller: _weaklyShakingLottieController,
                          repeat: false,
                          visible:
                              currentClamAnimationFromVM ==
                              ClamAnimationState.weaklyShaking,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: buildLottieWidget(
                          assetPath:
                              "assets/lotties/mission_shaking_seashell_strongly_2x_opti.json",
                          controller: _stronglyShakingLottieController,
                          repeat: false,
                          visible:
                              currentClamAnimationFromVM ==
                              ClamAnimationState.stronglyShaking,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: buildLottieWidget(
                          assetPath:
                              "assets/lotties/mission_shaking_seashell_complete_2x_opti.json",
                          controller: _shakingCompletedLottieController,
                          repeat: false,
                          visible:
                              currentClamAnimationFromVM ==
                              ClamAnimationState.opened,
                        ),
                      ),
                      isPlayingMission ? Container() : Gaps.v24,
                    ],
                  ),
                )
                .animate(target: shakingClamsState.isStart ? 1 : 0)
                .fadeIn(
                  begin: 0,
                  duration: 0.5.seconds,
                  curve: Curves.easeInOut,
                ),
          ),
        );
      },
    );
  }
}
