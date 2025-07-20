import 'package:alarmi/features/onboarding/models/onboard_state.dart';
import 'package:alarmi/features/onboarding/vms/onboard_view_model.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:alarmi/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UiLayer extends ConsumerWidget {
  const UiLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardState = ref.watch(onboardViewProvider);

    ref.listen<OnboardState>(onboardViewProvider, (previous, next) {
      if (next.stage == 10 && previous?.stage != 10) {
        // stage가 10으로 변경될 때만 실행
        callToast(context, '캐릭터 설정 완료');
      }
    });

    return Positioned(
      top: getWinHeight(context) * 0.2,
      left: 0,
      child: Container(
        width: getWinWidth(context),
        alignment: Alignment.center,
        child:
            onboardState.isNarration
                ? Text(
                  onboardState.message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                )
                : Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    onboardState.message,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
      ),
    );
  }
}
