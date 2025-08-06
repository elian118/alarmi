import 'package:alarmi/features/onboarding/vms/onboard_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FadeLayer extends ConsumerWidget {
  const FadeLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardState = ref.watch(onboardViewProvider);

    final bool shouldBeVisible = onboardState.stage == 10;
    final bool isAnimationActive =
        onboardState.stage == 10 || onboardState.stage == 11;

    return isAnimationActive
        ? Positioned.fill(
          child: Container(color: Colors.white)
              .animate(
                key: ValueKey(onboardState.stage),
                onPlay: (controller) {
                  if (onboardState.stage == 10) {
                    controller.forward(from: 0.0);
                  } else if (onboardState.stage == 11) {
                    controller.reset();
                    controller.forward();
                  }
                },
              )
              .fade(
                // 스테이지 10일 때 나타나고, 11이 아닐 때 사라지도록 페이드 효과 제어
                begin: shouldBeVisible ? 0.0 : 1.0,
                end: shouldBeVisible ? 1.0 : 0.0,
                duration: 1000.ms,
                curve: Curves.easeInQuad,
                delay: shouldBeVisible ? 5.seconds : 0.seconds,
              ),
        )
        : Container();
  }
}
