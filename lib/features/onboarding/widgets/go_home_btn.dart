import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/features/main/screens/main_screen.dart';
import 'package:alarmi/features/onboarding/services/character_service.dart';
import 'package:alarmi/features/onboarding/vms/onboard_view_model.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GoHomeBtn extends ConsumerWidget {
  const GoHomeBtn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardState = ref.watch(onboardViewProvider);

    void goHome() {
      String name = onboardState.name;
      String personality = onboardState.selectedPersonality!.key;
      CharacterService.setCharacterName(name);
      CharacterService.setCharacterPersonality(personality);
      context.go(MainScreen.routeURL);
    }

    return Container(
      width: getWinWidth(context),
      height: 58,
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () => goHome(),
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
              '알람 생성하기',
              style: TextStyle(
                fontSize: Sizes.size18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
