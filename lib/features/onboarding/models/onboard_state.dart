import 'dart:ui';

import 'package:alarmi/features/onboarding/constants/color_sets.dart';
import 'package:alarmi/features/onboarding/constants/personalities.dart';

class OnboardState {
  final int stage;
  final String message;
  final String name;
  final bool isNarration;
  final ColorSet selectedColor;
  final Personality? selectedPersonality;

  OnboardState({
    this.stage = 0,
    this.message = '바다 깊은 곳에서\n고양이가 깨어나고 있어요.',
    this.name = '',
    this.isNarration = true,
    this.selectedColor = const ColorSet(
      color: Color(0xffF9B9FF),
      colorName: '핑크색',
    ),
    this.selectedPersonality,
  });

  OnboardState copyWith({
    int? stage,
    String? narration,
    String? message,
    String? name,
    bool? isNarration,
    ColorSet? selectedColor,
    Personality? selectedPersonality,
  }) {
    return OnboardState(
      stage: stage ?? this.stage,
      message: message ?? this.message,
      name: name ?? this.name,
      isNarration: isNarration ?? this.isNarration,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedPersonality: selectedPersonality ?? this.selectedPersonality,
    );
  }
}
