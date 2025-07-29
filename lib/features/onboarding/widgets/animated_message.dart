import 'package:alarmi/features/onboarding/vms/onboard_view_model.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnimatedMessage extends ConsumerStatefulWidget {
  const AnimatedMessage({super.key});

  @override
  ConsumerState<AnimatedMessage> createState() => _AnimatedMessage();
}

class _AnimatedMessage extends ConsumerState<AnimatedMessage> {
  bool _isTypingFinished = false;
  String _currentMessage = '';

  @override
  void initState() {
    super.initState();
    // 초기 메시지를 설정하고 타이핑 애니메이션이 완료될 때까지 _isTypingFinished = false 유지
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final onboardState = ref.read(onboardViewProvider);
      _currentMessage = onboardState.message;
      _isTypingFinished = false; // 초기 상태는 타이핑 미완료
    });
  }

  @override
  void didUpdateWidget(covariant AnimatedMessage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 메시지가 변경되었을 때만 애니메이션 리셋 / _isTypingFinished = false 재설정
    final onboardState = ref.read(onboardViewProvider);
    if (_currentMessage != onboardState.message) {
      setState(() {
        _currentMessage = onboardState.message;
        _isTypingFinished = false; // 새 메시지 시작 시 타이핑 미완료로 리셋
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final onboardState = ref.watch(onboardViewProvider);

    // '▾' 문자 분리 로직
    String displayMessage = onboardState.message;
    bool hasSpecialIndicator = false;
    final String specialIndicator = '\n▾'; // 줄바꿈까지 제거

    if (onboardState.message.endsWith(specialIndicator)) {
      displayMessage = onboardState.message.substring(
        0,
        onboardState.message.length - specialIndicator.length,
      );
      hasSpecialIndicator = true;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color:
            onboardState.stage < 11
                ? Colors.white.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          AnimatedTextKit(
            key: ValueKey(onboardState.message),
            isRepeatingAnimation: false,
            animatedTexts: [
              TyperAnimatedText(
                displayMessage,
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
                speed: onboardState.message.length > 18 ? 50.ms : 80.ms,
              ),
            ],
            onFinished: () {
              setState(() {
                _isTypingFinished = true;
              });
            },
          ),
          if (hasSpecialIndicator && _isTypingFinished)
            Padding(
              padding: const EdgeInsets.only(top: 13.0, bottom: 3.0),
              child: Image.asset(
                'assets/images/etc/open.png',
              ).animate().scale(duration: 0.4.seconds),
            ),
        ],
      ),
    );
  }
}
