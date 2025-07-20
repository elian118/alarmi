class OnboardState {
  final int stage;
  final String message;
  final bool isNarration;

  OnboardState({
    this.stage = 0,
    this.message = '바다 깊은 곳에서\n고양이가 깨어나고 있어요.',
    this.isNarration = true,
  });

  OnboardState copyWith({
    int? stage,
    String? narration,
    String? message,
    bool? isNarration,
  }) {
    return OnboardState(
      stage: stage ?? this.stage,
      message: message ?? this.message,
      isNarration: isNarration ?? this.isNarration,
    );
  }
}
