import 'dart:async';

import 'package:alarmi/common/consts/raw_data/haptic_patterns.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:alarmi/utils/toast_utils.dart';
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

  const Vibrate({
    super.key,
    required this.title,
    required this.preset,
    required this.canVibrate,
    required this.onVibrationStateChanged,
    required this.presetId,
    required this.currentlyPlayingPresetId,
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
  Timer? _hapticOverallTimer; // 5분 전체 재생 시간을 관리하 타이머

  void callVibrate(VibrationPreset preset) async {
    final int vibrateDurationMs = 6000 * 10 * 5;
    await Vibration.vibrate(
      preset: preset,
      duration: vibrateDurationMs, // 5분
      repeat: vibrateDurationMs, // 무한 반복
    );

    _hapticOverallTimer = Timer(Duration(milliseconds: vibrateDurationMs), () {
      if (mounted && _isThisPatternPlaying) {
        Vibration.cancel();
        setState(() {
          _isThisPatternPlaying = false;
        });
        _playPauseController.reverse();
        widget.onVibrationStateChanged(null);
      }
    });
  }

  // 햅틱 패턴 재생 로직
  Future<void> _playHapticPattern() async {
    if (!widget.canVibrate) {
      callSimpleToast("이 기기는 진동 기능을 지원하지 않습니다.");
      return;
    }

    // 현재 진동 중이면 멈추고 토글
    if (_isThisPatternPlaying) {
      _hapticOverallTimer?.cancel();
      Vibration.cancel();
      setState(() {
        _isThisPatternPlaying = false;
      });
      _playPauseController.reverse(); // 애니메이션을 play 아이콘으로
      widget.onVibrationStateChanged(null); // 부모에게 아무것도 재생 중이 아님 알림
      return;
    }

    // 새로운 진동 시작 전, 다른 모든 진동을 취소
    Vibration.cancel();
    _hapticOverallTimer?.cancel();

    widget.onVibrationStateChanged(widget.presetId);

    // 이 패턴이 재생 중임을 표시하고 애니메이션 시작
    setState(() {
      _isThisPatternPlaying = true;
    });
    _playPauseController.forward(); // 애니메이션을 pause 아이콘으로

    try {
      callVibrate(widget.preset);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isThisPatternPlaying = false;
        });
        _playPauseController.reverse();
      }
      _hapticOverallTimer?.cancel();
      widget.onVibrationStateChanged(null);
    }
  }

  @override
  void didUpdateWidget(covariant Vibrate oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 1. 재생/일시정지 애니메이션 컨트롤
    if (widget.currentlyPlayingPresetId != oldWidget.currentlyPlayingPresetId) {
      final bool shouldBePlaying =
          (widget.currentlyPlayingPresetId == widget.presetId);

      if (shouldBePlaying && !_isThisPatternPlaying) {
        // 현재 멈춰있다면 재생 시작
        setState(() {
          _isThisPatternPlaying = true;
        });
        _playPauseController.forward();
        // 실제 진동 시작 로직은 _playHapticPattern에서만 호출되므로 여기서는 UI만 동기화
      } else if (!shouldBePlaying && _isThisPatternPlaying) {
        setState(() {
          _isThisPatternPlaying = false;
        });
        _playPauseController.reverse();
        _hapticOverallTimer?.cancel(); // 혹시 모를 타이머 취소
      }
    }
  }

  @override
  void initState() {
    _isThisPatternPlaying =
        (widget.currentlyPlayingPresetId == widget.presetId);
    if (_isThisPatternPlaying && widget.currentlyPlayingPresetId != null) {
      _playPauseController.forward();
      callVibrate(
        hapticPatterns
            .where((p) => p.id == widget.currentlyPlayingPresetId)
            .first
            .preset,
      );
    }
    super.initState();
  }

  @override
  void dispose() {
    _playPauseController.dispose();
    _hapticOverallTimer?.cancel();
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
            duration: 0.5.ms,
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
