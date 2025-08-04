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
    _shakingCompletedLottieController = AnimationController(
      vsync: this,
      duration: 1.seconds,
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

  void _triggerPopNumber(double changeValue) {
    _popAnimationController.stop();
    _popAnimationController.reset();

    setState(() {
      _currentPopValue = changeValue;
      _popColor = changeValue > 0 ? Colors.greenAccent : Colors.redAccent;
      _showPopNumber = true;

      final double verticalOffset = changeValue > 0 ? -80.0 : 180.0;
      final double horizontalOffset =
          changeValue > 0
              ? _random.nextBool()
                  ? -80.0
                  : 80.0
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
    final int shakeTriggerCountFromVM = shakingClamsState.shakeTriggerCount;

    ref.listen<double>(
      shakingClamsViewProvider.select((state) => state.openCount),
      (previousOpenCount, newOpenCount) {
        if (previousOpenCount != null && mounted) {
          final double change = newOpenCount - previousOpenCount;
          if (change != 0) {
            _triggerPopNumber(change);
          }
        }
      },
    );

    return Consumer(
      builder: (context, ref, child) {
        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 40),
          child: GestureDetector(
            onTap: () {
              // todo 에뮬레이터 테스트 편의 기능 - 배포 시 비활성 처리
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
                                  "assets/lotties/mission_shaking_seashell_waiting_2x_02.json",
                              controller: _waitingLottieController,
                              repeat: true,
                              visible:
                                  currentClamAnimationFromVM ==
                                      ClamAnimationState.waiting ||
                                  currentClamAnimationFromVM ==
                                      ClamAnimationState.weaklyShaking ||
                                  currentClamAnimationFromVM ==
                                      ClamAnimationState.stronglyShaking,
                            ),
                          )
                          .animate(
                            key: ValueKey('shake-${shakeTriggerCountFromVM}'),
                            // target: shakeAnimationTargetFromVM,
                            target: 1.0,
                          )
                          .shake(
                            hz:
                                currentClamAnimationFromVM ==
                                        ClamAnimationState.weaklyShaking
                                    ? 4 // 초당 4회 흔들림
                                    : currentClamAnimationFromVM ==
                                        ClamAnimationState.stronglyShaking
                                    ? 12 // 초당 8회 흔들림
                                    : 0,
                            duration: 1.seconds, // 1초 동안 흔들림
                            offset: Offset(
                              currentClamAnimationFromVM ==
                                      ClamAnimationState.weaklyShaking
                                  ? 5 // 좌우 5픽셀 흔들림
                                  : currentClamAnimationFromVM ==
                                      ClamAnimationState.stronglyShaking
                                  ? 15 // 좌우 10픽셀 흔들림
                                  : 0,
                              0,
                            ),
                          ),
                      Align(
                            alignment: Alignment.center,
                            child:
                            // riv 이미지 사용
                            // RiveAnimation.asset(
                            //   'assets/rives/mission_shaking_etc_phone_2x.riv',
                            //   fit: BoxFit.cover,
                            // ),
                            // 로티 이미지 사용
                            buildLottieWidget(
                              assetPath:
                                  "assets/lotties/mission_shaking_seashell_complete_2x_opti.json",
                              controller: _shakingCompletedLottieController,
                              repeat: false,
                              visible:
                                  currentClamAnimationFromVM ==
                                  ClamAnimationState.opened,
                            ),
                          )
                          .animate(
                            key: ValueKey(
                              currentClamAnimationFromVM ==
                                  ClamAnimationState.opened,
                            ),
                            target:
                                currentClamAnimationFromVM ==
                                        ClamAnimationState.opened
                                    ? 1.0
                                    : 0.0,
                          )
                          .fadeIn(
                            begin: 0.0,
                            duration: 500.ms,
                            curve: Curves.easeOut,
                          )
                          // 로티 이미지 사용 시 활성화(riv 사용 시 두번 연속 재생의 원인이 되므로 그땐 비활성화)
                          .swap(
                            // 애니메이션이 완료될 때 Lottie 재생 트리거
                            builder: (context, child) {
                              if (currentClamAnimationFromVM ==
                                  ClamAnimationState.opened) {
                                if (_shakingCompletedLottieController
                                        .isAnimating ==
                                    false) {
                                  _shakingCompletedLottieController.forward(
                                    from: 0.0,
                                  );
                                }
                              } else {
                                _shakingCompletedLottieController.stop();
                                _shakingCompletedLottieController.value = 0.0;
                              }
                              return child!;
                            },
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
