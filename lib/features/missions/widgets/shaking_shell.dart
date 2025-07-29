import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/features/missions/constants/enums/clam_animation_state.dart';
import 'package:alarmi/features/missions/vms/shaking_clams_view_model.dart';
import 'package:alarmi/utils/lottie_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shake/shake.dart';

class ShakingShell extends ConsumerStatefulWidget {
  const ShakingShell({super.key});

  @override
  ConsumerState<ShakingShell> createState() => _ShakingShellState();
}

class _ShakingShellState extends ConsumerState<ShakingShell>
    with TickerProviderStateMixin {
  late final ShakingClamsViewModel shakingClamsNotifier;
  late ShakeDetector shakeDetector;

  late AnimationController _waitingLottieController;
  late AnimationController _weaklyShakingLottieController;
  late AnimationController _stronglyShakingLottieController;

  ClamAnimationState _currentClamAnimation = ClamAnimationState.waiting;

  @override
  void initState() {
    shakingClamsNotifier = ref.read(shakingClamsViewProvider.notifier);

    _waitingLottieController = AnimationController(vsync: this);
    _weaklyShakingLottieController = AnimationController(vsync: this);
    _stronglyShakingLottieController = AnimationController(vsync: this);

    // _waitingLottieController.repeat();

    shakeDetector = ShakeDetector.autoStart(
      onPhoneShake: (event) {
        final shakingClamsState = ref.read(shakingClamsViewProvider);
        bool isPlayingMission =
            shakingClamsState.showMission &&
            !shakingClamsState.isCompleted &&
            !shakingClamsState.isFailed;

        if (isPlayingMission) {
          if (!_weaklyShakingLottieController.isAnimating &&
              !_stronglyShakingLottieController.isAnimating) {
            // waitingLottieController 정지
            _waitingLottieController.stop();

            setState(() {
              // 임시로 약한 흔들림 애니메이션으로 전환 (강도 구분 로직은 별도 구현 필요)
              _currentClamAnimation = ClamAnimationState.weaklyShaking;
            });

            // 약한 흔들림 애니메이션 재생
            _weaklyShakingLottieController.forward(from: 0.0).then((_) {
              // 애니메이션 재생 완료 후 waiting 상태로 복귀
              if (mounted) {
                setState(() {
                  _currentClamAnimation = ClamAnimationState.waiting;
                });
                _waitingLottieController.repeat(); // waiting 애니메이션 다시 반복 재생
              }
            });
          }
        }
      },
      shakeThresholdGravity: 1.5, // 필요에 따라 조절 (흔들림 감도)
      shakeSlopTimeMS: 200, // 흔들림 간격
      // shakeCount: 2, // 특정 횟수 이상 흔들릴 때만 감지
      // shakeTimeout: const Duration(milliseconds: 500), // 흔들림 타임아웃
    );
    super.initState();
  }

  @override
  void dispose() {
    shakeDetector.stopListening();
    _waitingLottieController.dispose();
    _weaklyShakingLottieController.dispose();
    _stronglyShakingLottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shakingClamsState = ref.watch(shakingClamsViewProvider);
    bool isPlayingMission =
        shakingClamsState.showMission &&
        !shakingClamsState.isCompleted &&
        !shakingClamsState.isFailed;

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 40),
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
                        "assets/lotties/mission_shaking_seashell_waiting_2x.json",
                    controller: _waitingLottieController,
                    repeat: true,
                    visible:
                        _currentClamAnimation == ClamAnimationState.waiting,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: buildLottieWidget(
                    assetPath:
                        "assets/lotties/mission_shaking_seashell_weakly_2x.json",
                    controller: _weaklyShakingLottieController,
                    repeat: false,
                    visible:
                        _currentClamAnimation ==
                        ClamAnimationState.weaklyShaking,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: buildLottieWidget(
                    assetPath:
                        "assets/lotties/mission_shaking_seashell_strongly_2x.json",
                    controller: _stronglyShakingLottieController,
                    repeat: false,
                    visible:
                        _currentClamAnimation ==
                        ClamAnimationState.stronglyShaking,
                  ),
                ),
                isPlayingMission ? Container() : Gaps.v24,
              ],
            ),
          )
          .animate(target: shakingClamsState.isStart ? 1 : 0)
          .fadeIn(begin: 0, duration: 0.5.seconds, curve: Curves.easeInOut),
    );
  }
}
