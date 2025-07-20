import 'package:alarmi/features/onboarding/vms/onboard_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CharacterLayer extends ConsumerWidget {
  const CharacterLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardState = ref.watch(onboardViewProvider);
    final onboardNotifier = ref.read(onboardViewProvider.notifier);

    return Positioned.fill(
      child: GestureDetector(
        onTap: () => onboardNotifier.setStage(onboardState.stage + 1),
        child: Container(
          alignment: Alignment.center,
          child: Image.asset(
            'assets/images/characters/${onboardState.stage >= 2 && onboardState.stage < 12 ? 'wakeup_cat' : 'sleepy_cat'}.png',
          ),
        ),
      ),
    );
  }
}
