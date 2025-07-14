import 'dart:async';

import 'package:alarmi/features/shaking_clams/models/ShakingClamsState.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShakingClamsViewModel extends Notifier<ShakingClamsState> {
  Timer? _countdownTimer;
  final int _initialCountdown = 3;
  final List<String> shellMessages = [
    '흔들어 주세요!',
    '조금만 더\n힘을 내세요!',
    '조개가\n열리고 있어요!',
  ];

  @override
  ShakingClamsState build() {
    return ShakingClamsState();
  }

  void initStates() {
    state = ShakingClamsState();
  }

  void setIsStart(bool value) {
    state = state.copyWith(isStart: value);
  }

  void setCountdown(int value) {
    state = state.copyWith(countdown: value);
  }

  void setOpenCount(double value) {
    int progressStage = 0;
    progressStage =
        value > 0.5 && value <= 0.8
            ? 1
            : value > 0.8 && value <= 1.0
            ? 2
            : 0;
    // 진행 단계별로 메시지 변경
    state = state.copyWith(
      openCount: value,
      message: shellMessages[progressStage],
    );
  }

  void setShowMission(bool value) {
    state = state.copyWith(showMission: value);
  }

  void setMessage(String value) {
    state = state.copyWith(message: value);
  }

  // 카운트다운 시작
  void startCountdown() {
    _countdownTimer?.cancel();

    setIsStart(true);
    setCountdown(_initialCountdown);

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.countdown > 1) {
        setCountdown(state.countdown - 1);
      } else {
        timer.cancel();
        setShowMission(true);
        if (kDebugMode) {
          print('Countdown finished!');
        }
      }
    });
  }
}

final shakingClamsViewProvider =
    NotifierProvider<ShakingClamsViewModel, ShakingClamsState>(
      () => ShakingClamsViewModel(),
    );
