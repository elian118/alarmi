class ShakingClamsState {
  final bool isStart;
  final int countdown;
  final bool showMission;
  final double openCount;
  final String message;
  final bool isCompleted;
  final bool isFailed;

  ShakingClamsState({
    this.isStart = false,
    this.countdown = 3,
    this.showMission = false,
    this.openCount = 0.0,
    this.message = '흔들어 주세요',
    this.isCompleted = false,
    this.isFailed = false,
  });

  ShakingClamsState copyWith({
    bool? isStart,
    int? countdown,
    bool? showMission,
    double? openCount,
    String? message,
    bool? isCompleted,
    bool? isFailed,
  }) {
    return ShakingClamsState(
      isStart: isStart ?? this.isStart,
      countdown: countdown ?? this.countdown,
      showMission: showMission ?? this.showMission,
      openCount: openCount ?? this.openCount,
      message: message ?? this.message,
      isCompleted: isCompleted ?? this.isCompleted,
      isFailed: isFailed ?? this.isFailed,
    );
  }
}
