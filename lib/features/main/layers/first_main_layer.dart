import 'dart:math';

import 'package:alarmi/common/consts/raw_data/cat_random_speeches.dart';
import 'package:alarmi/common/consts/raw_data/cat_regular_speeches.dart';
import 'package:alarmi/common/widgets/speech_bubble.dart';
import 'package:alarmi/features/main/constants/cat_animation_state.dart';
import 'package:alarmi/features/onboarding/services/character_service.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

class FirstMainLayer extends StatefulWidget {
  final Uint8List catSitComposition;
  final Uint8List catWaveComposition;
  final Uint8List catHiComposition;
  final Uint8List cloudComposition;
  final Uint8List sunlightComposition;
  final Uint8List seaComposition;
  final AnimationController bgLottieController;
  final String backgroundImgPath;
  final String? situation;

  const FirstMainLayer({
    super.key,
    required this.catSitComposition,
    required this.catWaveComposition,
    required this.catHiComposition,
    required this.cloudComposition,
    required this.sunlightComposition,
    required this.seaComposition,
    required this.bgLottieController,
    required this.backgroundImgPath,
    this.situation,
  });

  @override
  State<FirstMainLayer> createState() => _FirstMainLayerState();
}

class _FirstMainLayerState extends State<FirstMainLayer>
    with TickerProviderStateMixin {
  late String message = '';

  late AnimationController _catSitController;
  late AnimationController _catWaveController;
  late AnimationController _catHiController;

  CatAnimationState _currentCatAnimation = CatAnimationState.sit;

  final Random _random = Random();

  @override
  void initState() {
    _catSitController = AnimationController(vsync: this, duration: 2.1.seconds);
    _catWaveController = AnimationController(
      vsync: this,
      duration: 2.1.seconds,
    );
    _catHiController = AnimationController(vsync: this, duration: 2.1.seconds);

    _setInitialCatMotion();
    super.initState();
  }

  @override
  void dispose() {
    _catSitController.dispose();
    _catWaveController.dispose();
    _catHiController.dispose();
    super.dispose();
  }

  void _setInitialCatMotion() async {
    // 초기 로드 후 바로 'Hi' 애니메이션 재생
    setState(() {
      _currentCatAnimation = CatAnimationState.hi;
    });
    setRegularSpeech();

    _catHiController
      ..reset()
      ..forward();

    Future.delayed(3.1.seconds, () {
      if (!mounted) return;
      setState(() {
        message = '';
        _currentCatAnimation = CatAnimationState.sit;
      });
      _catSitController
        ..reset()
        ..repeat();
    });
  }

  void setRandomSpeech() async {
    if (!mounted) return;

    setState(() {
      message = '';
    });

    String? personality = await CharacterService.getCharacterPersonality();

    if (personality != null) {
      RandomSpeech targetRandomSpeech =
          randomSpeech
              .where((speech) => personality == speech.personality)
              .first;

      debugPrint(targetRandomSpeech.personality);
      int randomIdx = _random.nextInt(targetRandomSpeech.message.length);

      setState(() {
        message = targetRandomSpeech.message[randomIdx];
      });
    }
  }

  void setRegularSpeech() async {
    if (!mounted) return;

    setState(() {
      message = '';
    });

    String? personality = await CharacterService.getCharacterPersonality();

    if (personality != null) {
      final now = DateTime.now();
      final currentHour = now.hour;

      String situation =
          widget.situation != 'null'
              ? widget.situation!
              : currentHour >= 6 && currentHour < 12
              ? 'good_morning'
              : currentHour >= 12 && currentHour < 20
              ? 'good_afternoon'
              : 'good_evening';

      RegularSpeech targetRegularSpeech =
          regularSpeech
              .where(
                (speech) =>
                    personality == speech.personality &&
                    situation == speech.situation,
              )
              .first;

      debugPrint(targetRegularSpeech.personality);

      setState(() {
        message = targetRegularSpeech.message;
      });
    }
  }

  void changeRegularMotion({bool initialLoad = false}) {
    setState(() {
      _currentCatAnimation = CatAnimationState.hi;
    });
    setRegularSpeech();

    _catHiController
      ..reset()
      ..forward();

    Future.delayed(3.1.seconds, () {
      setState(() {
        message = '';
        _currentCatAnimation = CatAnimationState.sit;
      });
      _catSitController
        ..reset()
        ..repeat();
    });
  }

  void changeMotion() {
    setState(() {
      _currentCatAnimation = CatAnimationState.wave;
    });
    setRandomSpeech();

    _catWaveController
      ..reset()
      ..forward();

    Future.delayed(2.1.seconds, () {
      setState(() {
        message = '';
        _currentCatAnimation = CatAnimationState.sit;
      });
      _catSitController
        ..reset()
        ..repeat();
    });
  }

  Widget _buildLottieWidget({
    required Uint8List? lottieBytes,
    required AnimationController controller,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    bool repeat = true,
    bool animate = true,
    bool visible = true,
  }) {
    if (lottieBytes == null) {
      return const CircularProgressIndicator();
    }

    return Visibility(
      visible: visible,
      maintainState: true, // 보이지 않아도 위젯 상태 유지
      maintainAnimation: true, // 보이지 않아도 애니메이션 상태 유지
      maintainSize: true, // 보이지 않아도 공간 차지하도록 유지
      child: LottieBuilder.memory(
        lottieBytes,
        controller: controller,
        width: width,
        height: height,
        fit: fit,
        repeat: repeat,
        animate: animate,
        onLoaded: (composition) {
          controller.duration = composition.duration;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: changeMotion,
      child: Stack(
        children: [
          Positioned.fill(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    widget.backgroundImgPath,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: getWinHeight(context) * 0.26,
                  child:
                      message.isNotEmpty
                          ? SpeechBubble(message: message)
                          : Container(),
                ),
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: _buildLottieWidget(
                      lottieBytes: widget.cloudComposition,
                      controller: widget.bgLottieController,
                      repeat: true,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: _buildLottieWidget(
                      lottieBytes: widget.sunlightComposition,
                      controller: widget.bgLottieController,
                      repeat: true,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: _buildLottieWidget(
                    lottieBytes: widget.seaComposition,
                    controller: widget.bgLottieController,
                    repeat: true,
                  ),
                ),
                // 가시성 제어가 적용된 고양이 Lottie 위젯들
                Align(
                  alignment: Alignment.center,
                  child: _buildLottieWidget(
                    lottieBytes: widget.catSitComposition,
                    controller: _catSitController,
                    width: getWinWidth(context) * 0.7,
                    height: getWinWidth(context) * 0.7,
                    repeat: true,
                    visible: _currentCatAnimation == CatAnimationState.sit,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: _buildLottieWidget(
                    lottieBytes: widget.catWaveComposition,
                    controller: _catWaveController,
                    width: getWinWidth(context) * 0.7,
                    height: getWinWidth(context) * 0.7,
                    repeat: false, // Wave는 자동 반복 금지
                    visible: _currentCatAnimation == CatAnimationState.wave,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: _buildLottieWidget(
                    lottieBytes: widget.catHiComposition,
                    controller: _catHiController,
                    width: getWinWidth(context) * 0.7,
                    height: getWinWidth(context) * 0.7,
                    repeat: false, // Hi는 자동 반복 금지
                    visible: _currentCatAnimation == CatAnimationState.hi,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
