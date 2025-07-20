import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/features/onboarding/widgets/color_options.dart';
import 'package:alarmi/features/onboarding/widgets/color_pallet_options.dart';
import 'package:alarmi/features/onboarding/widgets/personality_options.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NextBtn extends ConsumerWidget {
  const NextBtn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ColorOptions(),
        Gaps.v24,
        ColorPalletOptions(),
        PersonalityOptions(),
        Gaps.v16,
        Container(
          width: getWinWidth(context),
          height: 58,
          padding: EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: Sizes.size14),
              child: Center(
                child: Text(
                  '다음',
                  style: TextStyle(
                    fontSize: Sizes.size18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
