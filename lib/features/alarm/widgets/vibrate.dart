import 'package:alarmi/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration/vibration_presets.dart';

class Vibrate extends StatefulWidget {
  final String title;
  final VibrationPreset preset;
  final bool canVibrate;

  const Vibrate({
    super.key,
    required this.title,
    required this.preset,
    required this.canVibrate,
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

  // 햅틱 패턴 재생 로직
  Future<void> _playHapticPattern() async {
    if (!widget.canVibrate) {
      callSimpleToast("이 기기는 진동 기능을 지원하지 않습니다.");
      return;
    }

    // 현재 진동 중이면 멈추고 토글
    if (_isThisPatternPlaying) {
      Vibration.cancel();
      setState(() {
        _isThisPatternPlaying = false;
      });
      _playPauseController.reverse(); // 애니메이션을 play 아이콘으로
      print("중지됨: ${widget.title}");
      return; // 정지했으므로 더 이상 재생하지 않음
    }

    // 새로운 진동 시작 전, 다른 모든 진동을 취소
    Vibration.cancel();

    // 이 패턴이 재생 중임을 표시하고 애니메이션 시작
    setState(() {
      _isThisPatternPlaying = true;
    });
    _playPauseController.forward(); // 애니메이션을 pause 아이콘으로

    print("진동 시작: ${widget.title}");

    try {
      await Vibration.vibrate(preset: widget.preset, repeat: 1000);
      print("재생 완료: '${widget.title}'");
    } catch (e) {
      print("햅틱 재생 중 오류 발생: $e");
    } finally {
      // 진동이 끝나거나 오류 발생 후, 이 패턴이 여전히 '재생 중'으로 표시되어 있다면 상태 초기화
      // `mounted` 확인은 위젯이 dispose된 후 setState 호출 방지
      if (mounted && _isThisPatternPlaying) {
        setState(() {
          _isThisPatternPlaying = false;
        });
        _playPauseController.reverse(); // 애니메이션을 play 아이콘으로
      }
    }
  }

  void dispose() {
    _playPauseController.dispose();
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
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
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
                    icon: AnimatedIcons.pause_play,
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
