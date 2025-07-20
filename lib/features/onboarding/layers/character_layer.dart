import 'package:alarmi/features/onboarding/vms/onboard_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CharacterLayer extends ConsumerWidget {
  const CharacterLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardState = ref.watch(onboardViewProvider);
    final onboardNotifier = ref.read(onboardViewProvider.notifier);

    String imageAsset =
        'assets/images/characters/${onboardState.stage >= 2 && onboardState.stage < 12 ? 'wakeup_cat' : 'sleepy_cat'}.png';

    Widget character =
        onboardState.stage == 7
            ? ColorFiltered(
              colorFilter: ColorFilter.mode(
                onboardState.selectedColor.color, // 변경하고 싶은 색상
                BlendMode.srcIn, // 투명하지 않은 픽셀에만 색상 적용
              ),
              child: Image.asset(
                'assets/images/characters/${onboardState.stage >= 2 && onboardState.stage < 12 ? 'wakeup_cat' : 'sleepy_cat'}.png',
              ),
            )
            : Image.asset(
              'assets/images/characters/${onboardState.stage >= 2 && onboardState.stage < 12 ? 'wakeup_cat' : 'sleepy_cat'}.png',
            );

    return Positioned.fill(
      child: GestureDetector(
        onTap: () => onboardNotifier.setStage(onboardState.stage + 1),
        child: Container(alignment: Alignment.center, child: character),
      ),
    );
  }
}
