import 'dart:math';

import 'package:flutter/material.dart';

class CountdownPainter extends CustomPainter {
  final double countdownProgress; // 0.0 ~ 1.0
  final Color progressColor;
  final Color backgroundColor;
  final double strokeWidth;

  CountdownPainter({
    required this.countdownProgress,
    this.progressColor = Colors.white,
    this.backgroundColor = Colors.white24,
    this.strokeWidth = 22.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final center = Offset(radius, radius);
    final startingAngle = -0.478 * pi;

    // 배경 트랙 페인트 설정
    final Paint backgroundPaint =
        Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round; // 배경 트랙도 둥글게

    // 진행 바 페인트 설정
    final Paint progressPaint =
        Paint()
          ..color = progressColor
          ..style = PaintingStyle.stroke
          ..strokeCap =
              StrokeCap
                  .round // 핵심: 선의 끝을 둥글게!
          ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, backgroundPaint);

    // 진행 바 아크 그리기
    final double sweepAngle = countdownProgress * 2 * pi;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startingAngle,
      sweepAngle,
      false, // center를 포함하지 않음 (선으로만 그림)
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CountdownPainter oldDelegate) {
    // 진행도 값이 변경될 때만 다시 그리기
    return oldDelegate.countdownProgress != countdownProgress ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
