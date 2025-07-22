import 'package:alarmi/features/onboarding/vms/onboard_view_model.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnimatedMessage extends ConsumerWidget {
  const AnimatedMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardState = ref.watch(onboardViewProvider);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
      decoration: BoxDecoration(
        color:
            onboardState.stage < 11
                ? Colors.white.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: AnimatedTextKit(
        key: GlobalKey(),
        isRepeatingAnimation: false,
        animatedTexts: [
          TyperAnimatedText(
            onboardState.message,
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            speed: onboardState.message.length > 18 ? 50.ms : 80.ms,
          ),
        ],
      ),
    );
  }
}
