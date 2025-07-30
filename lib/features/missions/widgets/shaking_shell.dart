import 'dart:math';

import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/features/missions/constants/enums/clam_animation_state.dart';
import 'package:alarmi/features/missions/vms/shaking_clams_view_model.dart';
import 'package:alarmi/utils/format_utils.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:alarmi/utils/lottie_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

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
  late AnimationController _popAnimationController;
  late Animation _popOffsetAnimation;

  // 팝업 숫자 애니메이션을 위한 상태 변수
  double _currentPopValue = 0.0;
  bool _showPopNumber = false;
  Color _popColor = Colors.white;
  final Random _random = Random();

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
    _popAnimationController = AnimationController(
      vsync: this,
      duration: 0.4.seconds,
    );
    _popOffsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _popAnimationController,
        curve: Curves.easeOutExpo,
      ),
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

  void _triggerPopNumber(double changeValue) {
    _popAnimationController.stop();
    _popAnimationController.reset();

    setState(() {
      _currentPopValue = changeValue;
      _popColor = changeValue > 0 ? Colors.white : Colors.redAccent;
      _showPopNumber = true;

      final double verticalOffset = changeValue > 0 ? -80.0 : 180.0;
      final double horizontalOffset =
          changeValue > 0
              ? _random.nextBool()
                  ? -100.0
                  : 100.0
              : 80;

      final startOffset = changeValue > 0 ? Offset.zero : Offset(80, 120);
      final endOffset = Offset(horizontalOffset, verticalOffset);

      _popOffsetAnimation = Tween<Offset>(
        begin: startOffset,
        end: endOffset,
      ).animate(
        CurvedAnimation(
          parent: _popAnimationController,
          curve: Curves.easeOutExpo,
        ),
      );

      _popAnimationController.forward(from: 0.0).then((_) {
        if (mounted) {
          setState(() {
            _showPopNumber = false;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _waitingLottieController.dispose();
    _weaklyShakingLottieController.dispose();
    _stronglyShakingLottieController.dispose();
    _shakingCompletedLottieController.dispose();
    _popAnimationController.dispose();
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

    ref.listen<double>(
      shakingClamsViewProvider.select((state) => state.openCount),
      (previousOpenCount, newOpenCount) {
        if (previousOpenCount != null && mounted) {
          final double change = newOpenCount - previousOpenCount;
          if (change != 0) {
            // 실제 변화가 있을 때만 트리거
            _triggerPopNumber(change);
          }
        }
      },
    );

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
              // print('onTap');
              // ref.read(shakingClamsViewProvider.notifier).handleShakeEvent();
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
                      // 증감치 팝업
                      Positioned(
                        top: 80,
                        left: getWinWidth(context) * 0.33,
                        child: Center(
                          child: AnimatedOpacity(
                            opacity: _showPopNumber ? 1.0 : 0.0,
                            duration: 0.4.seconds,
                            curve: Curves.easeOutExpo,
                            child: AnimatedBuilder(
                              // ✅ AnimatedBuilder 사용
                              animation: _popOffsetAnimation,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset:
                                      _popOffsetAnimation.value, // 애니메이션 값 적용
                                  child: Text(
                                    _currentPopValue > 0
                                        ? getNumberFormat(
                                          (_currentPopValue * 100000),
                                          decimalDigits: 0,
                                        )
                                        : '-${getNumberFormat((_currentPopValue * 100000), decimalDigits: 0)}',
                                    style: GoogleFonts.passionOne(
                                      color: _popColor,
                                      fontSize:
                                          currentClamAnimationFromVM ==
                                                  ClamAnimationState
                                                      .stronglyShaking
                                              ? 48
                                              : 28,
                                      fontWeight: FontWeight.bold,
                                      shadows: const [
                                        Shadow(
                                          blurRadius: 5.0,
                                          color: Colors.black,
                                          offset: Offset(2.0, 2.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
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
