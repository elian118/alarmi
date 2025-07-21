import 'package:alarmi/features/onboarding/constants/color_sets.dart';
import 'package:alarmi/features/onboarding/constants/personalities.dart';
import 'package:alarmi/features/onboarding/constants/stage_types.dart';
import 'package:alarmi/features/onboarding/models/onboard_state.dart';
import 'package:flutter/cupertino.dart';
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
    if (stageTypes.map((stage) => stage.index).contains(value)) {
      debugPrint(state.stage.toString());
      state = state.copyWith(
        stage: value,
        message:
            value == 4
                ? '${state.name}..\n${messages[value]}'
                : messages[value],
        isNarration: stageTypes[value].type == 'narration',
      );
    }
  }

  void prev() {
    setStage(state.stage - 1);
  }

  void next() {
    setStage(state.stage + 1);
  }

  void setName(String value) {
    state = state.copyWith(name: value);
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
