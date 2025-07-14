import 'dart:async';

import 'package:alarmi/features/shaking_clams/models/ShakingClamsState.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShakingClamsViewModel extends Notifier<ShakingClamsState> {
  Timer? _countdownTimer;
  Timer? _inactivityCheckTimer;
  Timer? _inactivityDecrementTimer;

  static const int _inactivityDuration = 10; // 불활성 상태 전환 대기시간 10초
  static const int _decrementInterval = 1; // 감소주기 1초
  double _lastShakeTime = 0.0; // 최근 흔들림이 감지된 시간

  final int _initialCountdown = 3;
  final List<String> shellMessages = [
    '흔들어 주세요!',
    '조금만 더\n힘을 내세요!',
    '조개가\n열리고 있어요!',
    '조개가\n닫히고 있어요!',
  ];

  @override
  ShakingClamsState build() {
    return ShakingClamsState();
  }

  void initStates() {
    state = ShakingClamsState();
    _lastShakeTime = 0.0; // 상태 초기화 시 마지막 흔들림 시간도 초기화
    _stopAllTimers();
  }

  void _stopAllTimers() {
    _countdownTimer?.cancel();
    _inactivityCheckTimer?.cancel();
    _inactivityDecrementTimer?.cancel();
    _countdownTimer = null;
    _inactivityCheckTimer = null;
    _inactivityDecrementTimer = null;
  }

  void disposeViewModel() {
    _stopAllTimers();
  }

  void setIsStart(bool value) {
    state = state.copyWith(isStart: value);
  }

  void setCountdown(int value) {
    state = state.copyWith(countdown: value);
  }

  void setOpenCount(double value) {
    int progressStage = 0;

    if (state.openCount < value) {
      progressStage =
          value > 0.5 && value <= 0.8
              ? 1
              : value > 0.8 && value <= 1.0
              ? 2
              : 0;
    } else {
      progressStage = 3;
    }

    // 진행 단계별로 메시지 변경
    state = state.copyWith(
      openCount: value,
      message: shellMessages[progressStage],
      showMission: value >= 0 && value < 1,
      isFailed: value < 0,
      isCompleted: value >= 1,
    );
  }

  void retryMission() {
    state = state.copyWith(
      openCount: 0,
      message: shellMessages[0],
      showMission: true,
      isFailed: false,
      isCompleted: false,
      isStart: true,
    );
    _lastShakeTime = DateTime.now().millisecondsSinceEpoch / 1000.0;
    _stopInactivityDecrementTimer();
    _startInactivityCheckTimer();
  }

  void setShowMission(bool value) {
    state = state.copyWith(showMission: value);
  }

  void setMessage(String value) {
    state = state.copyWith(message: value);
  }

  void setIsCompleted(bool value) {
    state = state.copyWith(isCompleted: value);
  }

  void setIsFailed(bool value) {
    state = state.copyWith(isFailed: value);
  }

  void onPhoneShakeDetected() {
    if (state.showMission &&
        state.isStart &&
        !state.isCompleted &&
        !state.isFailed) {
      setOpenCount(state.openCount + 0.02); // 흔들림 감지 시 openCount 증가
      _stopInactivityDecrementTimer(); // // 흔들림이 감지되면 감소 타이머 중지
    }

    // 마지막 흔들림 시간 업데이트
    _lastShakeTime = DateTime.now().millisecondsSinceEpoch / 1000.0;
    _startInactivityCheckTimer(); // 불활성 체크 타이머 리셋
  }

  void _startInactivityCheckTimer() {
    _inactivityCheckTimer?.cancel(); // 기존 타이머 취소
    _inactivityCheckTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.showMission &&
          state.isStart &&
          !state.isCompleted &&
          !state.isFailed) {
        final currentTime = DateTime.now().millisecondsSinceEpoch / 1000.0;
        // _lastShakeTime이 0.0이면 (미션 시작 후 첫 체크) 또는 불활성 기간 초과 여부 확인.
        if (_lastShakeTime == 0.0 ||
            (currentTime - _lastShakeTime) >= _inactivityDuration) {
          debugPrint('$_inactivityDuration초 동안 흔들림 없음 감지! 감소 타이머 시작.');
          _stopInactivityCheckTimer(); // 체크 타이머 중지
          _startInactivityDecrementTimer(); // 감소 타이머 시작
        }
      } else {
        // 미션 중이 아니거나, 이미 완료/실패 상태라면 체크 타이머 중지
        _stopInactivityCheckTimer();
      }
    });
  }

  void _startInactivityDecrementTimer() {
    _inactivityDecrementTimer?.cancel(); // 기존 타이머 취소
    _inactivityDecrementTimer = Timer.periodic(
      Duration(seconds: _decrementInterval),
      (timer) {
        if (state.openCount > 0) {
          // openCount가 0보다 클 때만 감소
          setOpenCount(state.openCount - 0.02);
          debugPrint('불활성 상태! openCount 감소: ${state.openCount}');
        } else {
          // openCount가 0 이하가 되면 감소 타이머 중지 및 미션 실패 처리
          setOpenCount(0); // 0 미만으로 내려가지 않도록 보정
          setIsFailed(true);
          _stopInactivityDecrementTimer();
          debugPrint('미션 실패: openCount 0 도달.');
        }
      },
    );
  }

  void _stopInactivityDecrementTimer() {
    _inactivityDecrementTimer?.cancel();
    _inactivityDecrementTimer = null;
  }

  void _stopInactivityCheckTimer() {
    _inactivityCheckTimer?.cancel();
    _inactivityCheckTimer = null;
  }

  // 카운트다운 시작
  void startCountdown() {
    _stopAllTimers();
    setIsStart(true);
    setCountdown(_initialCountdown);

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.countdown > 1) {
        setCountdown(state.countdown - 1);
      } else {
        timer.cancel();
        // 카운트다운 종료 시점도 마지막 흔들림 시간으로 간주
        _lastShakeTime = DateTime.now().millisecondsSinceEpoch / 1000.0;
        setShowMission(true);
        _startInactivityCheckTimer();
        debugPrint('Countdown finished! Mission started.');
      }
    });
  }
}

final shakingClamsViewProvider =
    NotifierProvider<ShakingClamsViewModel, ShakingClamsState>(
      () => ShakingClamsViewModel(),
    );
