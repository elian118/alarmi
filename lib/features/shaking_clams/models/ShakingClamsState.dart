class ShakingClamsState {
  final bool isStart;
  final int countdown;
  final bool showMission;
  final double openCount;
  final String message;

  ShakingClamsState({
    this.isStart = false,
    this.countdown = 3,
    this.showMission = false,
    this.openCount = 0.0,
    this.message = '흔들어 주세요',
  });

  ShakingClamsState copyWith({
    bool? isStart,
    int? countdown,
    bool? showMission,
    double? openCount,
    String? message,
  }) {
    return ShakingClamsState(
      isStart: isStart ?? this.isStart,
      countdown: countdown ?? this.countdown,
      showMission: showMission ?? this.showMission,
      openCount: openCount ?? this.openCount,
      message: message ?? this.message,
    );
  }
}
