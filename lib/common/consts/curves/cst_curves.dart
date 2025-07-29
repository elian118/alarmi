import 'package:flutter/animation.dart';

class ShortBackEaseInCurve extends Curve {
  final double x1;
  final double y1;
  final double x2;
  final double y2;

  const ShortBackEaseInCurve({
    this.x1 = 0.4,
    this.y1 = -0.1,
    this.x2 = 1.0,
    this.y2 = 1.0,
  });

  @override
  double transformInternal(double t) {
    return Cubic(x1, y1, x2, y2).transformInternal(t);
  }
}

abstract class CstCurves {
  // 인스턴스화 방지를 위해 추상 클래스로 만들거나 private 생성자를 가집니다.
  CstCurves._(); // private constructor

  static const Curve shortBackEaseIn = ShortBackEaseInCurve(
    x1: 0.4,
    y1: -0.1,
    x2: 1.0,
    y2: 1.0,
  );
}
