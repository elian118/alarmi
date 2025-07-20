import 'package:alarmi/features/onboarding/models/onboard_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/messages.dart';

class OnboardViewModel extends Notifier<OnboardState> {
  @override
  OnboardState build() {
    return OnboardState();
  }

  void initStates() {
    state = OnboardState();
  }

  void setStage(int value) {
    print(value);
    state = state.copyWith(
      stage: value,
      message: messages[value],
      isNarration: !(value >= 2 && value <= 6) && value < 10,
    );
  }
}

final onboardViewProvider = NotifierProvider<OnboardViewModel, OnboardState>(
  () => OnboardViewModel(),
);
