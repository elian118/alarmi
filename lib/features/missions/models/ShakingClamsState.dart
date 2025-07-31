import 'package:alarmi/features/missions/constants/enums/clam_animation_state.dart';

class ShakingClamsState {
  final bool isStart;
  final int countdown;
  final bool showMission;
  final double openCount;
  final String message;
  final bool isCompleting;
  final bool isCompleted;
  final bool isFailed;
  final ClamAnimationState currentClamAnimation;
  final int shakeTriggerCount;

  ShakingClamsState({
    this.isStart = false,
    this.countdown = 3,
    this.showMission = false,
    this.openCount = 0.0,
    this.message = '흔들어 주세요',
    this.isCompleting = false,
    this.isCompleted = false,
    this.isFailed = false,
    this.currentClamAnimation = ClamAnimationState.waiting,
    this.shakeTriggerCount = 0,
  });

  ShakingClamsState copyWith({
    bool? isStart,
    int? countdown,
    bool? showMission,
    double? openCount,
    String? message,
    bool? isCompleting,
    bool? isCompleted,
    bool? isFailed,
    ClamAnimationState? currentClamAnimation,
    int? shakeTriggerCount,
  }) {
    return ShakingClamsState(
      isStart: isStart ?? this.isStart,
      countdown: countdown ?? this.countdown,
      showMission: showMission ?? this.showMission,
      openCount: openCount ?? this.openCount,
      message: message ?? this.message,
      isCompleting: isCompleting ?? this.isCompleting,
      isCompleted: isCompleted ?? this.isCompleted,
      isFailed: isFailed ?? this.isFailed,
      currentClamAnimation: currentClamAnimation ?? this.currentClamAnimation,
      shakeTriggerCount: shakeTriggerCount ?? this.shakeTriggerCount,
    );
  }
}
