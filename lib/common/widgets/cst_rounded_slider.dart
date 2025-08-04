import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CstRoundedSlider extends StatelessWidget {
  final ValueNotifier<double> progress;
  final List<Color>? gradientColors;
  final double? sliderHeight;
  final bool? isRoundedProgressBar;

  const CstRoundedSlider({
    super.key,
    required this.progress,
    this.gradientColors,
    this.sliderHeight = 6.0,
    this.isRoundedProgressBar = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double _sliderHeight = sliderHeight ?? 6.0;

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black87.withValues(alpha: 0.45),
      ),
      width: size.width,
      height: _sliderHeight,
      child: ValueListenableBuilder<double>(
        valueListenable: progress,
        builder:
            (context, currentValue, child) => TweenAnimationBuilder(
              tween: Tween<double>(begin: currentValue, end: currentValue),
              duration: 600.ms,
              curve: Curves.easeInOut,
              builder:
                  (context, animatedValue, child) => CustomPaint(
                    size: Size(size.width, _sliderHeight),
                    painter: ProgressPainter(
                      progress: animatedValue,
                      gradientColors: gradientColors,
                      isRoundedProgressBar: isRoundedProgressBar,
                    ),
                  ),
            ),
      ),
    );
  }
}

class ProgressPainter extends CustomPainter {
  final double progress;
  final List<Color>? gradientColors;
  final bool? isRoundedProgressBar;

  ProgressPainter({
    super.repaint,
    required this.progress,
    this.gradientColors,
    this.isRoundedProgressBar,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final clampedProgress = progress.clamp(0.0, 1.0); // progress 값 범위 제한

    // 진행도가 0이면 아무것도 그리지 않음
    if (clampedProgress == 0.0) {
      return;
    }

    final progressPaint = Paint()..style = PaintingStyle.fill;

    // 프로그레스 바 너비 계산
    final currentProgressWidth = size.width * clampedProgress;

    if (gradientColors != null && gradientColors!.length >= 2) {
      // 그라데이션이 전달된 경우
      final gradientRect = Rect.fromLTWH(
        0,
        0,
        currentProgressWidth,
        size.height,
      );
      progressPaint.shader = ui.Gradient.linear(
        Offset(gradientRect.left, gradientRect.center.dy),
        Offset(gradientRect.right, gradientRect.center.dy),
        gradientColors!,
      );
    } else {
      // 그라데이션이 없거나 유효하지 않은 경우, 기본 흰색 진행도 바
      progressPaint.color = Colors.white;
    }

    if (isRoundedProgressBar == true) {
      // 둥근 진행도바
      final Radius radius = Radius.circular(size.height / 2);
      final RRect progressRRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, currentProgressWidth, size.height),
        radius,
      );
      canvas.drawRRect(progressRRect, progressPaint);
    } else {
      // 사각 진행도바
      final Rect progressRectToDraw = Rect.fromLTWH(
        0,
        0,
        currentProgressWidth,
        size.height,
      );
      canvas.drawRect(progressRectToDraw, progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant ProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
