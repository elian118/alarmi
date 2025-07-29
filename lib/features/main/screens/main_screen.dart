import 'dart:ui';

import 'package:alarmi/features/main/layers/first_main_layer.dart';
import 'package:alarmi/features/main/layers/my_alarms_layer.dart';
import 'package:alarmi/features/main/layers/second_main_layer.dart';
import 'package:alarmi/features/main/widgets/create_alarm_button.dart';
import 'package:alarmi/features/test/screens/alarm_test_screen.dart';
import 'package:alarmi/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

const String _backgroundImgPath = 'assets/images/backgrounds/home_day_bg.png';
const String _nightBackgroundImgPath =
    'assets/images/backgrounds/home_night_bg.png';

class MainScreen extends StatefulWidget {
  static const String routeName = 'main';
  static const String routeURL = '/main';

  final String? situation;

  const MainScreen({super.key, required String? situationParam})
    : situation = situationParam == 'null' ? null : situationParam;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController(initialPage: 0);

  int _currentPageIndex = 0; // 현재 페이지 인덱스
  bool _didPreloadAssets = false;

  late final AnimationController _bgCloudLottieController;
  late final AnimationController _bgSunlightLottieController;
  late final AnimationController _bgSeaLottieController;

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

    // 배경 로티 컨트롤러 초기화
    _bgCloudLottieController = AnimationController(vsync: this);
    _bgSunlightLottieController = AnimationController(vsync: this);
    _bgSeaLottieController = AnimationController(vsync: this);
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
    final ImageProvider backgroundProvider = AssetImage(
      isEvening() ? _nightBackgroundImgPath : _backgroundImgPath,
    );

    if (mounted) {
      await precacheImage(backgroundProvider, context);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bgCloudLottieController.dispose();
    _bgSunlightLottieController.dispose();
    _bgSeaLottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double blurSigma = _currentPageIndex == 0 ? 3.0 : 0.0; // 블러 강도 조절

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(), // PageView 기본 스크롤 비활성화
            children: <Widget>[
              FirstMainLayer(
                bgCloudLottieController: _bgCloudLottieController,
                bgSunlightLottieController: _bgSunlightLottieController,
                bgSeaLottieController: _bgSeaLottieController,
                backgroundImgPath: _backgroundImgPath,
                nightBackgroundImgPath: _nightBackgroundImgPath,
                situation: widget.situation,
              ),
              SecondMainLayer(),
            ],
          ),
          MyAlarmsLayer(
            currentPageIndex: _currentPageIndex,
            pageController: _pageController,
          ),
          Positioned(
            bottom: 50,
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
