import 'package:alarmi/features/onboarding/constants/color_sets.dart';
import 'package:alarmi/features/onboarding/constants/personalities.dart';
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
    if (value <= 13) {
      state = state.copyWith(
        stage: value,
        message:
            value == 4
                ? '${state.name}\n${messages[value]}..'
                : messages[value],
        isNarration: !(value >= 2 && value <= 6) && value < 9,
      );
    }
  }

  void setName(String value) {
    state = state.copyWith(name: value);
    print(state.name);
  }

  void setMessage(String value) {
    state = state.copyWith(message: value);
  }

  void setColor(int value) {
    state = state.copyWith(selectedColor: colorSets[value]);
  }

  void setPersonality(int value) {
    state = state.copyWith(
      selectedPersonality: personalities[value],
      message: personalities[value].message,
    );
  }
}

final onboardViewProvider = NotifierProvider<OnboardViewModel, OnboardState>(
  () => OnboardViewModel(),
);
