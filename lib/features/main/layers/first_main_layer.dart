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
  late final AnimationController _catLottieController;
  late final AnimationController _bgLottieController;

  late String message = '';
  String _currentCatLottiePath = _catSitLottiePath;

  // 캐싱된 Lottie 컴포지션 객체들
  Uint8List? _catSitComposition;
  Uint8List? _catWaveComposition;
  Uint8List? _catHiComposition;
  Uint8List? _cloudComposition;
  Uint8List? _sunlightComposition;
  Uint8List? _seaComposition;

  bool _isBackgroundLoaded = false;
  final Random _random = Random();

  bool _areLottiesLoaded = false;
  bool _didPreloadAssets = false;

  @override
  void initState() {
    _catLottieController = AnimationController(vsync: this);
    _bgLottieController = AnimationController(vsync: this);
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
    _catLottieController.dispose();
    _bgLottieController.dispose();
    super.dispose();
  }

  Future<Uint8List> _loadLottieBytes(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    return data.buffer.asUint8List();
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

    // 로티 이미지 미리 로드
    final List<Future<Uint8List>> lottieLoadFutures = [
      _loadLottieBytes(_catSitLottiePath),
      _loadLottieBytes(_catWaveLottiePath),
      _loadLottieBytes(_catHiLottiePath),
      _loadLottieBytes(_cloudLottiePath),
      _loadLottieBytes(_sunlightLottiePath),
      _loadLottieBytes(_seaLottiePath),
    ];

    // 모든 컴포지션이 로드될 때까지 기다림
    final List<Uint8List> loadedCompositions = await Future.wait(
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
      _currentCatLottiePath = _catHiLottiePath;
    });
    setRegularSpeech();

    _catLottieController
      ..reset()
      ..forward();

    Future.delayed(3.1.seconds, () {
      setState(() {
        message = '';
        _currentCatLottiePath = _catSitLottiePath;
      });
      _catLottieController
        ..reset()
        ..repeat();
    });
  }

  void changeMotion() {
    setState(() {
      _currentCatLottiePath = _catWaveLottiePath;
    });
    setRandomSpeech();

    _catLottieController
      ..reset()
      ..forward();

    Future.delayed(2.1.seconds, () {
      setState(() {
        message = '';
        _currentCatLottiePath = _catSitLottiePath;
      });
      _catLottieController
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
        if (repeat) {
          controller.repeat();
        } else {
          controller.forward();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 모든 에셋이 로드될 때까지 로딩 스피너 표시
    if (!_isBackgroundLoaded || !_areLottiesLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    Uint8List? currentCatLottieBytes;
    bool currentCatRepeat = true;

    if (_currentCatLottiePath == _catSitLottiePath) {
      currentCatLottieBytes = _catSitComposition;
      currentCatRepeat = true;
    } else if (_currentCatLottiePath == _catWaveLottiePath) {
      currentCatLottieBytes = _catWaveComposition;
      currentCatRepeat = false;
    } else if (_currentCatLottiePath == _catHiLottiePath) {
      currentCatLottieBytes = _catHiComposition;
      currentCatRepeat = false;
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
                Positioned.fill(
                  top: -410,
                  child: _buildLottieWidget(
                    lottieBytes: _cloudComposition,
                    controller: _bgLottieController, // 배경 애니메이션용 컨트롤러 사용
                    repeat: true,
                  ),
                ),
                Positioned.fill(
                  top: -410,
                  child: _buildLottieWidget(
                    lottieBytes: _sunlightComposition,
                    controller: _bgLottieController, // 배경 애니메이션용 컨트롤러 사용
                    repeat: true,
                  ),
                ),
                Positioned.fill(
                  child: _buildLottieWidget(
                    lottieBytes: _seaComposition,
                    controller: _bgLottieController, // 배경 애니메이션용 컨트롤러 사용
                    repeat: true,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: _buildLottieWidget(
                    lottieBytes: currentCatLottieBytes, // 현재 선택된 고양이 애니메이션
                    controller: _catLottieController, // 고양이 애니메이션용 컨트롤러 사용
                    width: getWinWidth(context) * 0.7,
                    height: getWinWidth(context) * 0.7,
                    repeat: currentCatRepeat, // 고양이 애니메이션은 기본적으로 반복
                  ),
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
}
