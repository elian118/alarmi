import 'package:alarmi/features/onboarding/vms/onboard_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BackgroundLayer extends ConsumerWidget {
  const BackgroundLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardState = ref.watch(onboardViewProvider);

    return Positioned.fill(
      child: Image.asset(
        'assets/images/backgrounds/${onboardState.stage >= 11 ? 'bg_onboardingfinished' : 'onboard_bg'}.png',
        fit: BoxFit.cover,
      ),
    );
  }
}
