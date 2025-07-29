import 'dart:async';

import 'package:alarmi/features/onboarding/constants/color_sets.dart';
import 'package:alarmi/features/onboarding/constants/personalities.dart';
import 'package:alarmi/features/onboarding/constants/stage_types.dart';
import 'package:alarmi/features/onboarding/models/onboard_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/messages.dart';

class OnboardViewModel extends Notifier<OnboardState> {
  Timer? _currentStageTimer;

  @override
  OnboardState build() {
    _startAutoAdvanceTimerIfNeeded(OnboardState());
    return OnboardState();
  }

  void initStates() {
    _startAutoAdvanceTimerIfNeeded(state);
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
      _startAutoAdvanceTimerIfNeeded(state);
    }
  }

  void prev() {
    if (state.stage > 0) setStage(state.stage - 1);
  }

  void next() {
    if (state.stage < stageTypes.length - 1) setStage(state.stage + 1);
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

  // 타이머 시작 및 관리
  void _startAutoAdvanceTimerIfNeeded(OnboardState currentState) {
    _cancelStageTimer(); // 기존 타이머가 있다면 먼저 취소

    final currentStageType = stageTypes[currentState.stage];
    Duration? delayDuration;

    if (currentStageType.isClickable) {
      delayDuration = 3.seconds;
      debugPrint(
        'Set timer for clickable stage: ${currentState.stage} with 3 seconds delay',
      );
    } else {
      if (currentState.stage == 10) {
        delayDuration = 6.seconds;
      } else if (currentState.stage == 11) {
        delayDuration = 3.seconds;
      }
    }

    // 지연시간 설정 시 타이머 시작
    if (delayDuration != null) {
      _currentStageTimer = Timer(delayDuration, () {
        next();
        _currentStageTimer = null;
      });
    }
  }

  void _cancelStageTimer() {
    _currentStageTimer?.cancel();
    _currentStageTimer = null;
  }
}

final onboardViewProvider = NotifierProvider<OnboardViewModel, OnboardState>(
  () => OnboardViewModel(),
);
