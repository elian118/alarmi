import 'package:alarmi/common/consts/curves/cst_curves.dart';
import 'package:alarmi/features/onboarding/vms/onboard_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CharacterLayer extends ConsumerWidget {
  const CharacterLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardState = ref.watch(onboardViewProvider);

    String imageAsset =
        'assets/images/characters/${onboardState.stage >= 2 && onboardState.stage < 12 ? 'wakeup_cat' : 'sleepy_cat'}.png';

    Widget character =
        onboardState.stage == 7
            ? ColorFiltered(
              colorFilter: ColorFilter.mode(
                onboardState.selectedColor.color, // 변경하고 싶은 색상
                BlendMode.srcIn, // 투명하지 않은 픽셀에만 색상 적용
              ),
              child: Image.asset(imageAsset),
            )
            : Image.asset(imageAsset);

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
