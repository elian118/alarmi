import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/features/onboarding/vms/onboard_view_model.dart';
import 'package:alarmi/utils/helper_utils.dart';
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
      child: Container(
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
                '이름 지어주기',
                style: TextStyle(
                  fontSize: Sizes.size18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ).animate(target: onboardState.stage > 3 ? 1 : 0).fadeIn(begin: 0),
    );
  }
}
