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

const String _catSitLottiePath = 'assets/lotties/home_day_cat_sit_x3_opti.json';
const String _catWaveLottiePath =
    'assets/lotties/home_day_cat_wave_x3_opti.json';
const String _catHiLottiePath = 'assets/lotties/home_day_cat_hi_x3_opti.json';
const String _cloudLottiePath = 'assets/lotties/home_day_bg_cloud_2x.json';
const String _sunlightLottiePath =
    'assets/lotties/home_day_bg_sunlight_2x.json';
const String _seaLottiePath = 'assets/lotties/home_day_bg_sea_1x_02.json';

const String _backgroundImgPath = 'assets/images/backgrounds/home_day_bg.png';

class FirstMainLayer extends StatefulWidget {
  const FirstMainLayer({super.key});

  @override
  State<FirstMainLayer> createState() => _FirstMainLayerState();
}

class _FirstMainLayerState extends State<FirstMainLayer>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late String message = '';
  String _currentCatLottiePath = _catSitLottiePath;

  // 캐싱된 Lottie 컴포지션 객체들
  LottieComposition? _catSitComposition;
  LottieComposition? _catWaveComposition;
  LottieComposition? _catHiComposition;
  LottieComposition? _cloudComposition;
  LottieComposition? _sunlightComposition;
  LottieComposition? _seaComposition;

  bool _isBackgroundLoaded = false;
  final Random _random = Random();

  bool _areLottiesLoaded = false;
  bool _didPreloadAssets = false;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didPreloadAssets) {
      _preloadAssets();
      _didPreloadAssets = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _preloadAssets() async {
    // 1. 배경 이미지 미리 로드
    final ImageProvider backgroundProvider = AssetImage(_backgroundImgPath);

    if (mounted) {
      await precacheImage(backgroundProvider, context);
      setState(() {
        _isBackgroundLoaded = true;
      });
    }

    print('_catSitLottiePath: $_catSitLottiePath');
    // 로티 이미지 미리 로드
    final List<Future<LottieComposition>> lottieLoadFutures = [
      LottieComposition.fromByteData(await rootBundle.load(_catSitLottiePath)),
      LottieComposition.fromByteData(await rootBundle.load(_catWaveLottiePath)),
      LottieComposition.fromByteData(await rootBundle.load(_catHiLottiePath)),
      LottieComposition.fromByteData(await rootBundle.load(_cloudLottiePath)),
      LottieComposition.fromByteData(
        await rootBundle.load(_sunlightLottiePath),
      ),
      LottieComposition.fromByteData(await rootBundle.load(_seaLottiePath)),
    ];

    // 모든 컴포지션이 로드될 때까지 기다림
    final List<LottieComposition> loadedCompositions = await Future.wait(
      lottieLoadFutures,
    );

    if (mounted) {
      setState(() {
        _catSitComposition = loadedCompositions[0];
        _catWaveComposition = loadedCompositions[1];
        _catHiComposition = loadedCompositions[2];
        _cloudComposition = loadedCompositions[3];
        _sunlightComposition = loadedCompositions[4];
        _seaComposition = loadedCompositions[5];

        _currentCatLottiePath = _catSitLottiePath; // 초기 경로 설정
        _areLottiesLoaded = true;
      });
      changeRegularMotion(initialLoad: true);
    }
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
      int randomIdx = _random.nextInt(targetRandomSpeech.message.length - 1);

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
      _currentCatLottiePath = _catHiLottiePath;
    });
    setRegularSpeech();

    Future.delayed(3.1.seconds, () {
      setState(() {
        message = '';
        _currentCatLottiePath = _catSitLottiePath;
      });
    });
  }

  void changeMotion() {
    setState(() {
      _currentCatLottiePath = _catWaveLottiePath;
    });
    setRandomSpeech();

    Future.delayed(2.1.seconds, () {
      setState(() {
        message = '';
        _currentCatLottiePath = _catSitLottiePath;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // 모든 에셋이 로드될 때까지 로딩 스피너 표시
    if (!_isBackgroundLoaded || !_areLottiesLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onTap: changeMotion,
      child: Stack(
        children: [
          Positioned.fill(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(_backgroundImgPath, fit: BoxFit.cover),
                ),
                Positioned(
                  top: getWinHeight(context) * 0.26,
                  child:
                      message.isNotEmpty
                          ? SpeechBubble(message: message)
                          : Container(),
                ),
                Lottie(composition: _cloudComposition!, repeat: true),
                Positioned.fill(
                  child: Lottie(
                    composition: _sunlightComposition!,
                    repeat: true,
                  ),
                ),
                Positioned.fill(
                  child: Lottie(composition: _seaComposition!, repeat: true),
                ),
                Container(
                  alignment: Alignment.center,
                  child: _getCatLottieWidget(),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: getWinHeight(context),
              color: Colors.transparent,
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getCatLottieWidget() {
    LottieComposition? currentComposition;
    if (_currentCatLottiePath == _catSitLottiePath) {
      currentComposition = _catSitComposition;
    } else if (_currentCatLottiePath == _catWaveLottiePath) {
      currentComposition = _catWaveComposition;
    } else if (_currentCatLottiePath == _catHiLottiePath) {
      currentComposition = _catHiComposition;
    }

    return Lottie(
      key: ValueKey(_currentCatLottiePath),
      composition: currentComposition!,
      width: getWinWidth(context) * 0.7,
      height: getWinWidth(context) * 0.7,
      repeat: true,
    );
  }
}
