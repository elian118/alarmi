import 'package:alarmi/common/vms/global_view_model.dart';
import 'package:alarmi/features/main/layers/first_main_layer.dart';
import 'package:alarmi/features/main/layers/my_alarms_layer.dart';
import 'package:alarmi/features/main/layers/second_main_layer.dart';
import 'package:alarmi/features/main/widgets/create_alarm_button.dart';
import 'package:alarmi/features/test/screens/alarm_test_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

const String _backgroundImgPath = 'assets/images/backgrounds/home_day_bg.png';
const String _nightBackgroundImgPath =
    'assets/images/backgrounds/home_night_bg.png';

class MainScreen extends ConsumerStatefulWidget {
  static const String routeName = 'main';
  static const String routeURL = '/main';

  final String? situation;

  const MainScreen({super.key, required String? situationParam})
    : situation = situationParam == 'null' ? null : situationParam;

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController(initialPage: 0);

  bool _didPreloadAssets = false;

  late final AnimationController _bgCloudLottieController;
  late final AnimationController _bgSunlightLottieController;
  late final AnimationController _bgSeaLottieController;

  @override
  void initState() {
    super.initState();
    // 배경 로티 컨트롤러 초기화
    _bgCloudLottieController = AnimationController(vsync: this);
    _bgSunlightLottieController = AnimationController(vsync: this);
    _bgSeaLottieController = AnimationController(vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> _preloadAssets(bool isEvening) async {
    // 1. 배경 이미지 미리 로드
    final ImageProvider backgroundProvider = AssetImage(
      isEvening ? _nightBackgroundImgPath : _backgroundImgPath,
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
    final isEvening = ref.watch(
      globalViewProvider.select((state) => state.isEvening),
    );

    if (!_didPreloadAssets) {
      _preloadAssets(isEvening); // isEvening 값을 전달
      _didPreloadAssets = true;
    }

    const double initialBottomOffset = 300.0;

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
            pageController: _pageController,
            initialBottomOffset: initialBottomOffset,
          ),
          Positioned(bottom: 50, left: 0, child: CreateAlarmButton()),
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
