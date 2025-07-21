import 'package:alarmi/features/onboarding/models/onboard_state.dart';
import 'package:alarmi/features/onboarding/vms/onboard_view_model.dart';
import 'package:alarmi/features/onboarding/widgets/animated_message.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:alarmi/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageLayer extends ConsumerWidget {
  const MessageLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardState = ref.watch(onboardViewProvider);

    ref.listen<OnboardState>(onboardViewProvider, (previous, next) {
      if (next.stage == 9 && previous?.stage != 9) {
        callToast(context, '캐릭터 설정 완료');
      }
    });

    return onboardState.stage != 3
        ? Positioned(
          top: getWinHeight(context) * 0.2,
          left: 0,
          child: Container(
            width: getWinWidth(context),
            alignment: Alignment.center,
            child:
                !onboardState.isNarration ||
                        (onboardState.isNarration &&
                            onboardState.stage == 8 &&
                            onboardState.selectedPersonality != null)
                    ? onboardState.stage == 10
                        ? AnimatedMessage()
                            .animate(key: GlobalKey())
                            .fadeOut(
                              begin: 1.0,
                              duration: 1.seconds,
                              curve: Curves.easeInOut,
                              delay: 2.seconds,
                            )
                        : AnimatedMessage()
                    : Text(
                          onboardState.message,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        )
                        .animate(
                          key: ValueKey(onboardState.message),
                          onPlay: (controller) => controller.forward(from: 0.0),
                        )
                        .fade(
                          begin: 0.0,
                          end: 1.0,
                          duration: 1.seconds,
                          curve: Curves.easeIn,
                        ),
          ),
        )
        : Container();
  }
}
