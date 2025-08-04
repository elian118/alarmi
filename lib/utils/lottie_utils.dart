import 'package:alarmi/common/widgets/cst_part_loading.dart';
import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart';

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

Widget buildRivWidget({
  required String assetPath,
  BoxFit fit = BoxFit.cover,
  // Rive는 Lottie의 repeat, animate 대신 animationName, stateMachineName, loopMode 등을 사용합니다.
  String? animationName, // 재생할 특정 애니메이션 이름
  String? stateMachineName, // 사용할 상태 머신 이름
  bool autoplay = true, // 애니메이션 자동 재생 여부
  bool visible = true,
  Widget? loading,
  Widget? errorWidget,
  Function(Artboard)? onInit, // Rive 애니메이션 로드 후 초기화 콜백
}) {
  if (assetPath.isEmpty) {
    return loading ?? CstPartLoading();
  }

  return Visibility(
    visible: visible,
    maintainState: true,
    maintainAnimation: true,
    maintainSize: true,
    child: RiveAnimation.asset(
      assetPath,
      fit: fit,
      artboard: null, // 특정 아트보드가 필요하다면 여기에 이름을 지정
      onInit: (artboard) {
        if (onInit != null) {
          onInit(artboard);
        }
      },
    ),
  );
}
