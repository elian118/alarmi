import 'package:alarmi/features/onboarding/vms/onboard_view_model.dart';
import 'package:alarmi/features/onboarding/widgets/next_btn.dart';
import 'package:alarmi/features/onboarding/widgets/set_name_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ButtonLayer extends ConsumerWidget {
  const ButtonLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardState = ref.watch(onboardViewProvider);
    return Positioned(
      bottom: 40,
      child:
          onboardState.stage == 7 || onboardState.stage == 8
              ? NextBtn()
                  .animate(
                    target:
                        onboardState.stage == 7 || onboardState.stage == 8
                            ? 1
                            : 0,
                  )
                  .fadeIn(begin: 0)
              : onboardState.stage == 3
              ? SetNameBtn()
                  .animate(target: onboardState.stage == 3 ? 1 : 0)
                  .fadeIn(begin: 0)
              : Container(),
    );
  }
}
