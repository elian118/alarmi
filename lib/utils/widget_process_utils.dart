import 'dart:ui';

import 'package:flutter/material.dart';

List<Widget> buildProgressiveBlurLayers({
  required double blurAreaHeight,
  int stepCount = 10,
  double initialSigma = 0.0,
  double sigmaIncrement = 0.05,
  double heightReductionFactor = 0.7, // 높이 감소 비율 (0.0: 변화 없음, 1.0: 급격 감소)
  // 하단으로 갈수록 top 간격 압축 비율 (0.0: 균등, 1.0: 급격 압축)
  double topCompressionFactor = 1.0,
}) {
  final List<Widget> blurLayers = [];
  double currentTop = 0.0;
  double remainingHeight = blurAreaHeight;

  for (int i = 0; i < stepCount; i++) {
    final double currentSigma = initialSigma + (i * sigmaIncrement);

    // 각 레이어의 상대적인 높이 비율 계산 (하단으로 갈수록 감소)
    final double relativeHeightFactor =
        1.0 - (i / stepCount) * heightReductionFactor;
    double layerHeight = blurAreaHeight / stepCount * relativeHeightFactor;

    // 마지막 레이어는 남은 모든 높이를 차지하도록 보정
    if (i == stepCount - 1) {
      layerHeight = remainingHeight;
    } else if (layerHeight > remainingHeight) {
      layerHeight = remainingHeight;
    }

    // top 위치를 하단으로 갈수록 더 압축하여 계산
    // Math.pow를 사용하여 비선형적인 간격 적용
    final double compressionAdjustment = (i / stepCount); // 0.0 to 1.0
    final double topOffsetIncrement =
        blurAreaHeight /
        stepCount *
        (1.0 - compressionAdjustment * topCompressionFactor);

    currentTop =
        (i == 0) ? 0.0 : currentTop + topOffsetIncrement; // 첫 레이어는 0부터 시작

    // 현재 레이어가 블러 영역을 벗어나지 않도록 클리핑
    if (currentTop >= blurAreaHeight) {
      break;
    }

    blurLayers.add(
      Positioned(
        top: currentTop,
        left: 0,
        right: 0,
        height: layerHeight,
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: currentSigma,
              sigmaY: currentSigma,
            ),
            child: Container(color: Colors.transparent),
          ),
        ),
      ),
    );
    remainingHeight -= layerHeight;
  }

  return blurLayers;
}
