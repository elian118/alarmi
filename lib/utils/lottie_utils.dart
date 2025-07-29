import 'package:alarmi/common/widgets/cst_part_loading.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget buildLottieWidget({
  required assetPath,
  required AnimationController controller,
  double? width,
  double? height,
  BoxFit fit = BoxFit.contain,
  bool repeat = true,
  bool animate = true,
  bool visible = true,
}) {
  if (assetPath == null) {
    return CstPartLoading();
  }

  return Visibility(
    visible: visible,
    maintainState: true, // 보이지 않아도 위젯 상태 유지
    maintainAnimation: true, // 보이지 않아도 애니메이션 상태 유지
    maintainSize: true, // 보이지 않아도 공간 차지하도록 유지
    child: LottieBuilder.asset(
      assetPath,
      controller: controller,
      width: width,
      height: height,
      fit: fit,
      repeat: repeat,
      animate: animate,
      onLoaded: (composition) {
        controller.duration = composition.duration;
        repeat ? controller.repeat() : controller.forward();
      },
    ),
  );
}
