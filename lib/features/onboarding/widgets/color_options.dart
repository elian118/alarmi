import 'package:alarmi/features/onboarding/vms/onboard_view_model.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ColorOptions extends ConsumerWidget {
  const ColorOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardState = ref.watch(onboardViewProvider);
    return onboardState.stage == 7
        ? Container(
          width: getWinWidth(context),
          alignment: Alignment.center,
          child: Container(
            width: 87,
            height: 51,
            padding: EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.grey.withValues(alpha: 0.2),
                width: 1.0,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              onboardState.selectedColor.colorName,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
          ),
        ).animate(target: onboardState.stage == 7 ? 1 : 0).fadeIn(begin: 0)
        : Container();
  }
}
