import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CstRoundedSlider extends StatelessWidget {
  final ValueNotifier<double> progress;

  const CstRoundedSlider({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: ValueListenableBuilder<double>(
        valueListenable: progress,
        builder:
            (context, currentValue, child) => TweenAnimationBuilder(
              tween: Tween<double>(begin: currentValue, end: currentValue),
              duration: 600.ms,
              curve: Curves.easeInOut,
              builder:
                  (context, animatedValue, child) => CustomPaint(
                    size: Size(size.width, 6),
                    painter: ProgressPainter(progress: animatedValue),
                  ),
            ),
      ),
    );
  }
}

class ProgressPainter extends CustomPainter {
  final double progress;

  ProgressPainter({super.repaint, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = Colors.black87.withValues(alpha: 0.45);
    final bgRect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawRect(bgRect, bgPaint);

    final progressPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    final clampedProgress = progress.clamp(0.0, 1.0); // progress 값 범위 제한

    final progressRect = Rect.fromLTWH(
      0,
      0,
      size.width * clampedProgress,
      size.height,
    );
    final Radius radius = Radius.circular(size.height / 2);
    final RRect progressRRect = RRect.fromRectAndRadius(progressRect, radius);
    canvas.drawRRect(progressRRect, progressPaint);
  }

  @override
  bool shouldRepaint(covariant ProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
