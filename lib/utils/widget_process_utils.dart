import 'dart:ui';

import 'package:flutter/material.dart';

// 단일 그라디언트 블러 레이어 생성 - 최적화
Widget buildSingleGradientBlurLayer({
  required double blurAreaHeight,
  required double blurSigma, // 블러 강도 (sigmaX, sigmaY)
}) {
  return SizedBox(
    height: blurAreaHeight,
    child: Stack(
      children: [
        // 1. 전체 영역에 BackdropFilter 적용
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(color: Colors.transparent),
        ),
        // 2. 투명도 마스크(ShaderMask)를 씌워 점진적인 효과 만들기
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              // 투명도 변화(색상 무관)
              colors: [
                Colors.transparent.withValues(alpha: 0.0),
                Colors.transparent.withValues(alpha: 0.15),
                Colors.transparent.withValues(alpha: 0.3),
              ],
              // 투명도가 변하는 위치
              stops: const [0.0, 0.7, 1.0],
            ).createShader(bounds);
          },
          // 마스크를 적용할 위젯 (이 경우, 배경의 색상을 덮는 효과를 위해 Container를 사용)
          blendMode: BlendMode.dstIn, // 마스크 투명도에 따라 BackdropFilter 보임
          child: Container(
            // 마스크의 색상은 중요하지 않음, 투명도를 위해 사용
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}
