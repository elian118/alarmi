import 'package:alarmi/common/widgets/cst_part_loading.dart';
import 'package:dotlottie_loader/dotlottie_loader.dart';
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
  Widget? loading,
}) {
  if (assetPath == null) {
    return loading ?? CstPartLoading();
  }

  return Visibility(
    visible: visible,
    maintainState: true, // 보이지 않아도 위젯 상태 유지
    maintainAnimation: true, // 보이지 않아도 애니메이션 상태 유지
    maintainSize: true, // 보이지 않아도 공간 차지
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

Widget buildDotLottieWidget({
  required String assetPath,
  required AnimationController controller,
  BoxFit fit = BoxFit.contain,
  bool repeat = true,
  bool animate = true,
  bool visible = true,
  double? width,
  double? height,
  Widget? loading,
  Widget? errorWidget,
}) {
  if (assetPath.isEmpty) {
    return loading ?? CstPartLoading();
  }

  return Visibility(
    visible: visible,
    maintainState: true,
    maintainAnimation: true,
    maintainSize: true,
    child: DotLottieLoader.fromAsset(
      assetPath,
      frameBuilder: (BuildContext ctx, DotLottie? dotLottie) {
        if (dotLottie != null && dotLottie.animations.isNotEmpty) {
          return Lottie.memory(
            dotLottie.animations.values.single,
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
            errorBuilder: (context, error, stackTrace) {
              debugPrint(
                'Lottie memory load error (dotLottie): $assetPath, Error: $error',
              );
              return errorWidget ??
                  const Center(child: Text('DotLottie Mem Load Failed!'));
            },
          );
        } else {
          return errorWidget ?? const Center(child: Text('No dotLottie data.'));
        }
      },
    ),
  );
}
