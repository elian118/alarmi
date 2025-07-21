import 'dart:math';

import 'package:alarmi/common/consts/raw_data/cat_random_speeches.dart';
import 'package:alarmi/common/consts/raw_data/cat_regular_speeches.dart';
import 'package:alarmi/common/widgets/speech_bubble.dart';
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
  final AnimationController catLottieController;
  final AnimationController bgLottieController;
  final String backgroundImgPath;

  const FirstMainLayer({
    super.key,
    required this.catSitComposition,
    required this.catWaveComposition,
    required this.catHiComposition,
    required this.cloudComposition,
    required this.sunlightComposition,
    required this.seaComposition,
    required this.catLottieController,
    required this.bgLottieController,
    required this.backgroundImgPath,
  });

  @override
  State<FirstMainLayer> createState() => _FirstMainLayerState();
}

class _FirstMainLayerState extends State<FirstMainLayer> {
  late String message = '';
  late Uint8List? _currentCatLottieBytes;
  final Random _random = Random();

  @override
  void initState() {
    _currentCatLottieBytes = widget.catSitComposition; // 초기 고양이 애니메이션 설정
    _setInitialCatMotion();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _setInitialCatMotion() async {
    // 초기 로드 후 바로 'Hi' 애니메이션 재생
    setState(() {
      _currentCatLottieBytes = widget.catHiComposition;
    });
    setRegularSpeech();

    widget.catLottieController
      ..reset()
      ..forward();

    Future.delayed(3.1.seconds, () {
      if (!mounted) return;
      setState(() {
        message = '';
        _currentCatLottieBytes = widget.catSitComposition;
      });
      widget.catLottieController
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
          currentHour >= 6 && currentHour < 12
              ? 'good morning'
              : currentHour >= 12 && currentHour < 20
              ? 'good afternoon'
              : 'good evening';

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
      _currentCatLottieBytes = widget.catHiComposition;
    });
    setRegularSpeech();

    widget.catLottieController
      ..reset()
      ..forward();

    Future.delayed(3.1.seconds, () {
      setState(() {
        message = '';
        _currentCatLottieBytes = widget.catSitComposition;
      });
      widget.catLottieController
        ..reset()
        ..repeat();
    });
  }

  void changeMotion() {
    setState(() {
      _currentCatLottieBytes = widget.catWaveComposition;
    });
    setRandomSpeech();

    widget.catLottieController
      ..reset()
      ..forward();

    Future.delayed(2.1.seconds, () {
      setState(() {
        message = '';
        _currentCatLottieBytes = widget.catSitComposition;
      });
      widget.catLottieController
        ..reset()
        ..repeat();
    });
  }

  Widget _buildLottieWidget({
    required Uint8List? lottieBytes, // Lottie Bytes 데이터
    required AnimationController controller, // 해당 애니메이션 컨트롤러
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    bool repeat = true,
    bool animate = true,
  }) {
    if (lottieBytes == null) {
      return const CircularProgressIndicator(); // 데이터가 아직 로드되지 않았으면 로딩 표시
    }
    return LottieBuilder.memory(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    bool currentCatRepeat =
        (_currentCatLottieBytes == widget.catSitComposition);

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
                Align(
                  alignment: Alignment.center,
                  child: _buildLottieWidget(
                    lottieBytes:
                        _currentCatLottieBytes!, // 이미 null 체크되었으므로 ! 사용
                    controller: widget.catLottieController,
                    width: getWinWidth(context) * 0.7,
                    height: getWinWidth(context) * 0.7,
                    repeat: currentCatRepeat,
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
