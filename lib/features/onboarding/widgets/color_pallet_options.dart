import 'package:alarmi/features/onboarding/constants/color_sets.dart';
import 'package:alarmi/features/onboarding/vms/onboard_view_model.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ColorPalletOptions extends ConsumerWidget {
  const ColorPalletOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardState = ref.watch(onboardViewProvider);
    final onboardNotifier = ref.read(onboardViewProvider.notifier);

    return onboardState.stage == 7
        ? Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: getWinWidth(context),
          height: 58,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...colorSets.mapIndexed(
                (idx, colorSet) => Stack(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(56),
                        border: Border.all(
                          color:
                              onboardState.selectedColor == colorSet
                                  ? Colors.white
                                  : Colors.transparent,
                          width: 1.0,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () => onboardNotifier.setColor(idx),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: colorSet.color,
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate(target: onboardState.stage == 7 ? 1 : 0).fadeIn(begin: 0)
        : Container();
  }
}
