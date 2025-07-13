class ShakingClamsState {
  final bool isStart;
  final int countdown;

  ShakingClamsState({this.isStart = false, this.countdown = 3});

  ShakingClamsState copyWith({bool? isStart, int? countdown}) {
    return ShakingClamsState(
      isStart: isStart ?? this.isStart,
      countdown: countdown ?? this.countdown,
    );
  }
}
