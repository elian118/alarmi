import 'dart:async';
import 'dart:math';

import 'package:alarmi/features/missions/constants/enums/clam_animation_state.dart';
import 'package:alarmi/features/missions/models/ShakingClamsState.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shake/shake.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration/vibration_presets.dart';

class ShakingClamsViewModel extends Notifier<ShakingClamsState> {
  Timer? _popCountdownTimer; // 팝업 내 3초 타이머
  Timer? _countdownTimer;
  Timer? _inactivityCheckTimer;
  Timer? _inactivityDecrementTimer;
  Timer? _completionTimer;

  ShakeDetector? _shakeDetector;
  final Random _random = Random();

  static const int _inactivityDuration = 1; // 불활성 상태 전환 대기시간 1초
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
    _initializeShakeDetector();
    return ShakingClamsState(
      currentClamAnimation: ClamAnimationState.waiting,
      shakeTriggerCount: 0,
    );
  }

  // ShakeDetector 초기화
  void _initializeShakeDetector() {
    _shakeDetector = ShakeDetector.autoStart(
      onPhoneShake: (event) => handleShakeEvent(), // 흔들림 감지 시 내부 메서드 호출
      shakeThresholdGravity: 1.5, // 필요에 따라 조절 (흔들림 감도)
      shakeSlopTimeMS: 200, // 흔들림 간격
    );
  }

  // 흔들림 감지 이벤트 처리
  void handleShakeEvent() {
    // 미션 중일 때만 흔들림 로직 실행 (ViewModel에서 `isStart`는 카운트다운 시작 여부로만 사용)
    if (state.showMission && !state.isCompleting && !state.isFailed) {
      // 15% 확률로 강하게 흔들었다고 판정
      bool isCritical = _random.nextDouble() < 0.15;
      ClamAnimationState nextAnimationState =
          isCritical
              ? ClamAnimationState.stronglyShaking
              : ClamAnimationState.weaklyShaking;

      state = state.copyWith(
        currentClamAnimation: nextAnimationState,
        shakeTriggerCount: state.shakeTriggerCount + 1, // 카운터 증가
        // shakeAnimationTarget: 1.0 - state.shakeAnimationTarget, // 타겟 토글
      );

      debugPrint(
        'ViewModel: Shake event. State: ${state.currentClamAnimation}, Count: ${state.shakeTriggerCount}',
      );

      if (isCritical) {
        Vibration.vibrate(preset: VibrationPreset.doubleBuzz);
      }
      onPhoneShakeDetected();
    }
  }

  void initStates() {
    state = ShakingClamsState(
      currentClamAnimation: ClamAnimationState.waiting,
      shakeTriggerCount: 0,
    );
    _lastShakeTime = 0.0; // 상태 초기화 시 마지막 흔들림 시간도 초기화
    _stopAllTimers();
    startPopCountdown();
  }

  void disposeViewModel() {
    _shakeDetector?.stopListening();
    _stopAllTimers();
    debugPrint('ShakingClamsViewModel disposed, ShakeDetector stopped.');
  }

  void _stopAllTimers() {
    _popCountdownTimer?.cancel();
    _countdownTimer?.cancel();
    _inactivityCheckTimer?.cancel();
    _inactivityDecrementTimer?.cancel();
    _completionTimer?.cancel();
    _countdownTimer = null;
    _inactivityCheckTimer = null;
    _inactivityDecrementTimer = null;
    _completionTimer = null;
  }

  void setClamAnimationState(ClamAnimationState newState) {
    state = state.copyWith(currentClamAnimation: newState);
  }

  void setIsStart(bool value) {
    state = state.copyWith(isStart: value);
  }

  void setPopCountdown(int value) {
    state = state.copyWith(popCountdown: value);
  }

  void setCountdown(int value) {
    state = state.copyWith(countdown: value);
  }

  void setCountdownProgress(double value) {
    state = state.copyWith(countdownProgress: value);
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
      showMission: value >= 0,
      isFailed: value < 0,
      isCompleting: value >= 1,
      currentClamAnimation:
          value >= 1 ? ClamAnimationState.opened : state.currentClamAnimation,
      // 조개 열리면 리셋
      shakeTriggerCount: value >= 1 ? 0 : state.shakeTriggerCount,
    );

    if (state.isCompleting && !state.isCompleted) {
      debugPrint('조개가 완전히 열리는 중... 2초 후 미션 완료 처리.');
      _completionTimer?.cancel();
      _completionTimer = Timer(const Duration(seconds: 2), () {
        // 타이머 완료 시점에 여전히 isCompleting 상태인지 확인
        if (state.isCompleting) {
          setIsCompleted(true);
          setShowMission(false);
          debugPrint('미션 완료!');
        }
        _completionTimer = null;
      });
    }
  }

  void retryMission() {
    state = state.copyWith(
      openCount: 0,
      message: shellMessages[0],
      showMission: true,
      isFailed: false,
      isCompleting: false,
      isCompleted: false,
      isStart: true,
      currentClamAnimation: ClamAnimationState.waiting,
      // 재시도 시 애니메이션 타겟 리셋
      shakeTriggerCount: 0,
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

  void setIsCompleting(bool value) {
    state = state.copyWith(isCompleting: value);
  }

  void setIsCompleted(bool value) {
    state = state.copyWith(isCompleted: value);
  }

  void setIsFailed(bool value) {
    state = state.copyWith(isFailed: value);
  }

  void onPhoneShakeDetected() {
    double baseCountUnit = 0.045;
    double randomOffset =
        (_random.nextDouble() * 0.01) - 0.005; // -0.005 ~ +0.005
    double fluctuatingCountUnit = baseCountUnit + randomOffset;
    double increaseOpenCount = 0;

    // 현재 애니메이션 상태 (ViewModel의 상태)에 따라 증감치 계산
    if (state.currentClamAnimation == ClamAnimationState.stronglyShaking) {
      increaseOpenCount = fluctuatingCountUnit * 3; // 강하게 흔들면 3배 증가
      debugPrint(
        'Critical Shake! increase: ${increaseOpenCount.toStringAsFixed(3)}',
      );
    } else if (state.currentClamAnimation == ClamAnimationState.weaklyShaking) {
      increaseOpenCount = fluctuatingCountUnit; // 약하게 흔들면 1배 증가
      debugPrint(
        'Weak Shake! increase: ${increaseOpenCount.toStringAsFixed(3)}',
      );
    }

    if (state.showMission &&
        state.isStart &&
        !state.isCompleting &&
        !state.isFailed) {
      setOpenCount(
        state.openCount + increaseOpenCount,
      ); // 흔들림 감지 시 openCount 증가
      _stopInactivityDecrementTimer(); // 흔들림이 감지되면 감소 타이머 중지
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
          !state.isCompleting &&
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
        if (state.openCount > 0 && state.openCount < 1) {
          // openCount가 0~1 때만 감소
          setOpenCount(state.openCount - 0.056);
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

  // 팝업 카운트다운 시작 - 종료 시 자동 카운트다운 시작
  void startPopCountdown() {
    _stopAllTimers();

    _popCountdownTimer = Timer.periodic(1.seconds, (timer) {
      if (state.popCountdown > 0) {
        setPopCountdown(state.popCountdown - 1);
      } else {
        timer.cancel();
        debugPrint('popCountdown finished! startCountdown started.');
        setIsStart(true);
        startCountdown();
      }
    });
  }

  // 카운트다운 시작
  void startCountdown() {
    _stopAllTimers();
    setIsStart(true);
    setCountdown(_initialCountdown);

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.countdown > 1) {
        // 카운트다운 업데이트
        setCountdown(state.countdown - 1);
        // 진행도(애니메이션) 업데이트
        setCountdownProgress(state.countdownProgress - (1 / _initialCountdown));
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
