import 'dart:math';

import 'package:alarmi/common/consts/raw_data/cat_random_speeches.dart';
import 'package:alarmi/common/consts/raw_data/cat_regular_speeches.dart';
import 'package:alarmi/common/widgets/cst_part_loading.dart';
import 'package:alarmi/common/widgets/speech_bubble.dart';
import 'package:alarmi/features/main/constants/cat_animation_state.dart';
import 'package:alarmi/features/onboarding/services/character_service.dart';
import 'package:alarmi/utils/date_utils.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

class FirstMainLayer extends StatefulWidget {
  final AnimationController bgLottieController;
  final String backgroundImgPath;
  final String nightBackgroundImgPath;
  final String? situation;

  const FirstMainLayer({
    super.key,
    required this.bgLottieController,
    required this.backgroundImgPath,
    required this.nightBackgroundImgPath,
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

  bool _isInitialMotionSet = false;
  bool _isEvening = false;

  @override
  void initState() {
    _catSitController = AnimationController(vsync: this, duration: 2.1.seconds);
    _catWaveController = AnimationController(
      vsync: this,
      duration: 2.1.seconds,
    );
    _catHiController = AnimationController(vsync: this, duration: 2.1.seconds);

    setState(() {
      _isEvening = isEvening();
    });
    // 저녁이 아닐때만 로띠 적용
    // todo - 저녁용 로띠 애니메이션 얻으면 조건절 풀 것!
    if (!_isEvening) {
      _setInitialCatMotionOnInitialLoad();
    }

    super.initState();
  }

  @override
  void didUpdateWidget(covariant FirstMainLayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // widget.situation 값이 이전과 다를 경우 setRegularSpeech 실행
    if (widget.situation != oldWidget.situation) {
      debugPrint(
        'Situation changed: ${oldWidget.situation} -> ${widget.situation}',
      );
      // 새로운 상황 값이 있을 때만 changeRegularMotion 호출
      changeRegularMotion();
    }
  }

  @override
  void dispose() {
    _catSitController.dispose();
    _catWaveController.dispose();
    _catHiController.dispose();
    super.dispose();
  }

  void _setInitialCatMotionOnInitialLoad() async {
    if (_isInitialMotionSet) return;

    _isInitialMotionSet = true; // 플래그 설정

    setState(() {
      _currentCatAnimation = CatAnimationState.hi;
    });
    // 초기 로드 시에도 regular speech 설정
    await setRegularSpeech(); // 메시지 설정 완료 후 애니메이션 진행

    _catHiController
      ..reset()
      ..forward();

    Future.delayed(3.1.seconds, () {
      if (!mounted) return;
      setState(() {
        message = ''; // 메시지 비움
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

  Future<void> setRegularSpeech() async {
    if (!mounted) return;

    setState(() {
      message = '';
    });

    String? personality = await CharacterService.getCharacterPersonality();

    if (personality != null) {
      String situation =
          widget.situation != null ? widget.situation! : getHourCategory();

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

  // situation 변화 시 호출
  void changeRegularMotion() {
    setState(() {
      _currentCatAnimation = CatAnimationState.hi;
    });
    setRegularSpeech();

    _catHiController
      ..reset()
      ..forward();

    Future.delayed(3.1.seconds, () {
      if (!mounted) return; // dispose 후 setState 호출 방지
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
                    // todo 저녁용 로띠가 있으면 아래 조건식 바꾸기
                    !_isEvening
                        ? widget.backgroundImgPath
                        : widget.nightBackgroundImgPath,
                    fit: BoxFit.cover,
                  ),
                ),
                // todo 저녁용 로띠가 있으면 아래 조건식 바꾸기
                // 저녁인 경우 아래 위젯 모두 감추기
                if (!_isEvening) ...[
                  Positioned.fill(
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: _buildLottieWidget(
                        assetPath: 'assets/lotties/home_day_bg_cloud_2x.json',
                        controller: widget.bgLottieController,
                        repeat: true,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: _buildLottieWidget(
                        assetPath:
                            'assets/lotties/home_day_bg_sunlight_2x.json',
                        controller: widget.bgLottieController,
                        repeat: true,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: _buildLottieWidget(
                      assetPath: 'assets/lotties/home_day_bg_sea_1x_02.json',
                      controller: widget.bgLottieController,
                      repeat: true,
                    ),
                  ),
                  Positioned(
                    top: getWinHeight(context) * 0.22,
                    child:
                        message.isNotEmpty
                            ? SpeechBubble(message: message)
                            : Container(),
                  ),
                  // 가시성 제어가 적용된 고양이 Lottie 위젯들
                  Align(
                    alignment: Alignment.center,
                    child: _buildLottieWidget(
                      assetPath: 'assets/lotties/home_day_cat_sit_x2_opti.json',
                      controller: _catSitController,
                      // width: getWinWidth(context) * 0.7,
                      // height: getWinWidth(context) * 0.7,
                      width: 311,
                      height: 284.87,
                      repeat: true,
                      visible: _currentCatAnimation == CatAnimationState.sit,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: _buildLottieWidget(
                      assetPath:
                          'assets/lotties/home_day_cat_wave_x2_opti.json',
                      controller: _catWaveController,
                      // width: getWinWidth(context) * 0.7,
                      // height: getWinWidth(context) * 0.7,
                      width: 311,
                      height: 284.87,
                      repeat: false, // Wave는 자동 반복 금지
                      visible: _currentCatAnimation == CatAnimationState.wave,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: _buildLottieWidget(
                      assetPath: 'assets/lotties/home_day_cat_hi_x2_opti.json',
                      controller: _catHiController,
                      // width: getWinWidth(context) * 0.7,
                      // height: getWinWidth(context) * 0.7,
                      width: 311,
                      height: 284.87,
                      repeat: false, // Hi는 자동 반복 금지
                      visible: _currentCatAnimation == CatAnimationState.hi,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
