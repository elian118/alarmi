import 'package:alarmi/common/consts/curves/cst_curves.dart';
import 'package:alarmi/features/onboarding/vms/onboard_view_model.dart';
import 'package:alarmi/utils/lottie_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CharacterLayer extends ConsumerStatefulWidget {
  const CharacterLayer({super.key});

  @override
  ConsumerState<CharacterLayer> createState() => _CharacterLayerState();
}

class _CharacterLayerState extends ConsumerState<CharacterLayer>
    with TickerProviderStateMixin {
  late AnimationController characterController;

  @override
  void initState() {
    characterController = AnimationController(vsync: this, duration: 3.seconds);
    _updateLottieAnimation();
    super.initState();
  }

  @override
  void didUpdateWidget(CharacterLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateLottieAnimation();
  }

  // 애니메이션 업데이트 - 로티 애니메이션별 제어권 분리 목적
  void _updateLottieAnimation() {
    final onboardState = ref.read(onboardViewProvider);

    if (onboardState.stage == 1) {
      characterController.forward(from: 0);
    } else if (onboardState.stage >= 2 && onboardState.stage < 10) {
      if (!characterController.isAnimating) {
        characterController.repeat();
      }
    } else {
      characterController.stop();
    }
  }

  @override
  void dispose() {
    characterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onboardState = ref.watch(onboardViewProvider);

    String lottieAsset =
        'assets/lotties/onboarding_cat_${onboardState.stage >= 2 && onboardState.stage < 12
            ? 'wakeup'
            : onboardState.stage == 1
            ? 'wakeup_ing'
            : 'sleep'}_2x_opti.json';

    Widget lottieWidget = buildLottieWidget(
      assetPath: lottieAsset,
      controller: characterController,
      repeat: onboardState.stage != 1,
      width: 300,
      height: 300,
    );

    Widget character =
        onboardState.stage == 7
            ? ColorFiltered(
              colorFilter: ColorFilter.mode(
                onboardState.selectedColor.color, // 변경하고 싶은 색상
                BlendMode.srcIn, // 투명하지 않은 픽셀에만 색상 적용
              ),
              child: lottieWidget,
            )
            : lottieWidget;

    return Positioned.fill(
      child:
          onboardState.stage <= 10
              ? Container(alignment: Alignment.center, child: character)
                  .animate(
                    onPlay:
                        (controller) =>
                            onboardState.stage < 10
                                ? controller.repeat()
                                : controller.forward(),
                  )
                  .custom(
                    duration: 1.ms,
                    builder: (context, value, child) {
                      if (onboardState.stage < 10) {
                        // 둥실둥실 애니메이션 체인
                        return child!
                            .animate(
                              onPlay: (controller) => controller.repeat(),
                            )
                            .slide(
                              begin: const Offset(0, 0.01),
                              end: const Offset(0, -0.01),
                              duration: 1500.ms,
                              curve: Curves.easeInOutSine,
                            )
                            .then(delay: 0.ms)
                            .slide(
                              begin: const Offset(0, -0.01),
                              end: const Offset(0, 0.01),
                              duration: 1500.ms,
                              curve: Curves.easeInOutSine,
                            );
                      } else if (onboardState.stage == 10) {
                        // 위로 서서히 올라가며 사라지는 애니메이션 체인
                        return child!
                            .animate()
                            .slide(
                              begin: const Offset(0, 0),
                              end: const Offset(0, -1.0),
                              duration: 7.seconds,
                              curve: CstCurves.shortBackEaseIn,
                            )
                            .fade(
                              begin: 1.0,
                              end: 0.0,
                              duration: 8.seconds,
                              curve: Curves.easeInCubic,
                            );
                      }
                      return Container();
                    },
                  )
              : Container(),
    );
  }
}
