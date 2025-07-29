import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/common/widgets/cst_rounded_elevated_btn.dart';
import 'package:alarmi/features/onboarding/vms/onboard_view_model.dart';
import 'package:alarmi/features/onboarding/widgets/color_options.dart';
import 'package:alarmi/features/onboarding/widgets/color_pallet_options.dart';
import 'package:alarmi/features/onboarding/widgets/personality_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NextBtn extends ConsumerWidget {
  const NextBtn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardState = ref.watch(onboardViewProvider);
    final onboardNotifier = ref.read(onboardViewProvider.notifier);

    return Column(
      children: [
        ColorOptions(),
        Gaps.v24,
        ColorPalletOptions(),
        PersonalityOptions(),
        Gaps.v10,
        CstRoundedElevatedBtn(
          label: '다음',
          height: 58,
          onPressed:
              onboardState.stage == 8 &&
                      onboardState.selectedPersonality == null
                  ? null
                  : () => onboardNotifier.next(),
        ),
      ],
    );
  }
}
