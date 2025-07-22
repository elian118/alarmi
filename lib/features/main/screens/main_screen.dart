import 'dart:ui';

import 'package:alarmi/features/main/layers/first_main_layer.dart';
import 'package:alarmi/features/main/layers/my_alarms_layer.dart';
import 'package:alarmi/features/main/layers/second_main_layer.dart';
import 'package:alarmi/features/main/widgets/create_alarm_button.dart';
import 'package:alarmi/features/test/screens/alarm_test_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

const String _catSitLottiePath = 'assets/lotties/home_day_cat_sit_x2_opti.json';
const String _catWaveLottiePath =
    'assets/lotties/home_day_cat_wave_x2_opti.json';
const String _catHiLottiePath = 'assets/lotties/home_day_cat_hi_x2_opti.json';
const String _cloudLottiePath = 'assets/lotties/home_day_bg_cloud_2x.json';
const String _sunlightLottiePath =
    'assets/lotties/home_day_bg_sunlight_2x.json';
const String _seaLottiePath = 'assets/lotties/home_day_bg_sea_1x_02.json';
const String _backgroundImgPath = 'assets/images/backgrounds/home_day_bg.png';

class MainScreen extends StatefulWidget {
  static const String routeName = 'main';
  static const String routeURL = '/main';

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController(initialPage: 0);

  int _currentPageIndex = 0; // 현재 페이지 인덱스

  // 캐싱된 Lottie 컴포지션 객체들
  Uint8List? _catSitComposition;
  Uint8List? _catWaveComposition;
  Uint8List? _catHiComposition;
  Uint8List? _cloudComposition;
  Uint8List? _sunlightComposition;
  Uint8List? _seaComposition;

  bool _isBackgroundLoaded = false;
  bool _areLottiesLoaded = false;
  bool _didPreloadAssets = false;

  late final AnimationController _bgLottieController;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.hasClients) {
        int newPageIndex = _pageController.page?.round() ?? 0;
        if (_currentPageIndex != newPageIndex) {
          setState(() {
            _currentPageIndex = newPageIndex;
          });
        }
      }
    });

    // 로티 컨트롤러 초기화
    _bgLottieController = AnimationController(
      vsync: this,
      duration: 2.1.seconds,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didPreloadAssets) {
      _preloadAssets();
      _didPreloadAssets = true;
    }
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
        _areLottiesLoaded = true;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    // _catLottieController.dispose();
    _bgLottieController.dispose();
    super.dispose();
  }

  Future<Uint8List> _loadLottieBytes(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    return data.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isBackgroundLoaded || !_areLottiesLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    final double blurSigma = _currentPageIndex == 0 ? 1.0 : 0.0; // 블러 강도 조절

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(), // PageView 기본 스크롤 비활성화
            children: <Widget>[
              FirstMainLayer(
                catSitComposition: _catSitComposition!,
                catWaveComposition: _catWaveComposition!,
                catHiComposition: _catHiComposition!,
                cloudComposition: _cloudComposition!,
                sunlightComposition: _sunlightComposition!,
                seaComposition: _seaComposition!,
                bgLottieController: _bgLottieController,
                backgroundImgPath: _backgroundImgPath,
              ),
              SecondMainLayer(),
            ],
          ),
          MyAlarmsLayer(
            currentPageIndex: _currentPageIndex,
            pageController: _pageController,
          ),
          Positioned(
            bottom: 40,
            left: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
                child: CreateAlarmButton(),
              ),
            ),
          ),
          // 테스트 스크린으로 이동하는 버튼
          Positioned(
            top: 50,
            right: 20,
            child: GestureDetector(
              onTap: () => context.push(AlarmTestScreen.routeURL),
              child: Image.asset(
                'assets/images/characters/thumb.png',
              ).animate().scale(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
