import 'package:alarmi/utils/helper_utils.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SpeechBubble extends StatelessWidget {
  final String message;

  const SpeechBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getWinWidth(context),
      alignment: Alignment.center,
      child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: AnimatedTextKit(
              key: GlobalKey(),
              isRepeatingAnimation: false,
              animatedTexts: [
                TyperAnimatedText(
                  message,
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  speed: message.length > 18 ? 50.ms : 80.ms,
                ),
              ],
            ),
          )
          .animate(key: GlobalKey())
          .fadeOut(
            begin: 1.0,
            duration: 1.seconds,
            curve: Curves.easeInOut,
            delay: 2.seconds,
          ),
    );
  }
}
