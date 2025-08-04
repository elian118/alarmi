import 'dart:async';

import 'package:alarmi/utils/helper_utils.dart';
import 'package:alarmi/utils/toast_utils.dart';
import 'package:alarmi/utils/vibrate_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:marquee/marquee.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration/vibration_presets.dart';

class Vibrate extends StatefulWidget {
  final String title;
  final String presetId;
  final VibrationPreset preset;
  final bool canVibrate;
  final String? currentlyPlayingPresetId;
  final Function(String? id) onVibrationStateChanged;
  final bool isDialogActivatedVibrate;

  const Vibrate({
    super.key,
    required this.title,
    required this.preset,
    required this.canVibrate,
    required this.onVibrationStateChanged,
    required this.presetId,
    required this.currentlyPlayingPresetId,
    required this.isDialogActivatedVibrate,
  });

  @override
  State<Vibrate> createState() => _VibrateState();
}

class _VibrateState extends State<Vibrate> with TickerProviderStateMixin {
  late final AnimationController _playPauseController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 500),
  );

  bool _isThisPatternPlaying = false; // 현재 이 위젯의 햅틱 패턴 재생 중 여부
  Timer? _vibrationRepeatTimer;

  // 햅틱 패턴 재생 로직
  Future<void> _playHapticPattern() async {
    // 진동 활성화 여부 확인
    if (!widget.isDialogActivatedVibrate) {
      callToast(context, '진동 설정이 비활성화되어 있습니다.');
      _stopVibration();
      return;
    }

    if (!widget.canVibrate) {
      callToast(context, "이 기기는 진동 기능을 지원하지 않습니다.");
      return;
    }

    // 현재 진동 중이면 멈추고 토글
    if (_isThisPatternPlaying) {
      _stopVibration();
      return;
    }

    // 새로운 진동 시작 전, 다른 모든 진동을 취소
    Vibration.cancel();
    _vibrationRepeatTimer?.cancel(); // 기존 타이머가 있다면 취소

    widget.onVibrationStateChanged(widget.presetId);

    // 이 패턴이 재생 중임을 표시하고 애니메이션 시작
    setState(() {
      _isThisPatternPlaying = true;
    });
    _playPauseController.forward(); // 애니메이션을 pause 아이콘으로

    try {
      _vibrationRepeatTimer = VibrateUtils.playRepeatVibration(widget.preset);
    } catch (e) {
      if (mounted) {
        _stopVibration();
      }
      widget.onVibrationStateChanged(null);
    }
  }

  void _stopVibration() {
    VibrateUtils.stopRepeatVibration(_vibrationRepeatTimer);
    setState(() {
      _isThisPatternPlaying = false;
    });
    _playPauseController.reverse();
    widget.onVibrationStateChanged(null);
  }

  @override
  void didUpdateWidget(covariant Vibrate oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 1. 전역 스위치 변경에 반응
    if (widget.isDialogActivatedVibrate != oldWidget.isDialogActivatedVibrate &&
        !widget.isDialogActivatedVibrate) {
      _stopVibration(); // 끄면 즉시 타이머 중지
      return;
    }

    // 2. 재생/일시정지 애니메이션 컨트롤
    if (widget.currentlyPlayingPresetId != oldWidget.currentlyPlayingPresetId) {
      final bool shouldBePlaying =
          (widget.currentlyPlayingPresetId == widget.presetId);

      if (shouldBePlaying && !_isThisPatternPlaying) {
        // 현재 멈춰있다면 재생 시작
        setState(() {
          _isThisPatternPlaying = true;
        });
        _playPauseController.forward();
        // 진동 활성화 상태에서만 타이머 재시작
        _vibrationRepeatTimer?.cancel();
        if (widget.isDialogActivatedVibrate) {
          _vibrationRepeatTimer = Timer.periodic(1.seconds, (timer) {
            Vibration.vibrate(preset: widget.preset, duration: 1000);
          });
        }
      } else if (!shouldBePlaying && _isThisPatternPlaying) {
        _stopVibration();
      }
    }
  }

  @override
  void initState() {
    _isThisPatternPlaying =
        (widget.currentlyPlayingPresetId == widget.presetId);
    // 진동 활성화 상태만 타이머 시작
    if (_isThisPatternPlaying &&
        widget.currentlyPlayingPresetId != null &&
        widget.isDialogActivatedVibrate) {
      _playPauseController.forward();
      _vibrationRepeatTimer = Timer.periodic(1.seconds, (timer) {
        Vibration.vibrate(preset: widget.preset, duration: 1000);
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _playPauseController.dispose();
    _vibrationRepeatTimer?.cancel(); // 타이머도 취소
    Vibration.cancel(); // 재생중인 모든 진동 취소
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _playHapticPattern,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
      ),
      child: AnimatedBuilder(
        animation: _playPauseController,
        builder: (context, child) {
          final double currentAlpha = 0.07 * _playPauseController.value;
          final Color iconContainerColor = Colors.white.withValues(
            alpha:
                _playPauseController.value < 0.1
                    ? 0.1
                    : _playPauseController.value,
          );

          return AnimatedContainer(
            duration: 500.ms,
            curve: Curves.easeInOut,
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: currentAlpha),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 25,
              children: [
                Container(
                  height: 30,
                  width: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: currentAlpha),
                  ),
                  child: Text('🐷'),
                ),
                Expanded(
                  child:
                      _isThisPatternPlaying
                          ? Marquee(
                            text: widget.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            blankSpace: getWinWidth(context) * 0.6,
                          )
                          : Text(
                            widget.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                ),
                Container(
                  width: 26,
                  height: 26,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: iconContainerColor,
                    shape: BoxShape.circle,
                  ),
                  child: AnimatedIcon(
                    icon: AnimatedIcons.play_pause,
                    progress: _playPauseController,
                    size: 20,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
