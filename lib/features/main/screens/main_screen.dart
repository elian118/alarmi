import 'dart:ui';

import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/features/alarm/widgets/alarm_tab_content.dart';
import 'package:alarmi/features/main/layers/first_main_layer.dart';
import 'package:alarmi/features/main/layers/second_main_layer.dart';
import 'package:alarmi/features/main/widgets/create_alarm_button.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainScreen extends StatefulWidget {
  static const String routeName = 'main';
  static const String routeURL = '/main';

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  double _alarmsTopOffset = 0.0;
  double _dragStartY = 0.0; // 드래그 시작 시 Y 좌표
  int _currentPageIndex = 0; // 현재 페이지 인덱스
  static const double _initialBottomOffset = 350.0; // 예: 250 -> 350으로 변경

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
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // 이하 GestureDetector 콜백 함수들
  void _onVerticalDragStart(DragStartDetails details) {
    _dragStartY = details.globalPosition.dy;
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      final double screenHeight = getWinHeight(context);
      final double startPosition =
          screenHeight - _initialBottomOffset; // 0페이지에서의 AlarmTabContent 시작 위치
      final double dragDelta = details.globalPosition.dy - _dragStartY;

      // 현재 페이지에 따라 이동 로직 변경
      _alarmsTopOffset =
          _currentPageIndex == 0 ? startPosition + dragDelta : dragDelta;

      // 위치 제한 (화면 맨 위 0.0, 초기 시작 위치 startPosition)
      if (_alarmsTopOffset < 0) {
        _alarmsTopOffset = 0;
      }
      if (_alarmsTopOffset > startPosition) {
        _alarmsTopOffset = startPosition;
      }
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    final double screenHeight = getWinHeight(context);
    final double startPosition = screenHeight - _initialBottomOffset;
    final double dragThreshold = screenHeight * 0.15; // 화면 높이 15%를 임계값 설정

    // 드래그 속도 고려
    final double velocity = details.primaryVelocity ?? 0.0;
    final double minVelocity = 600.0; // 최소 속도 임계값

    if (_currentPageIndex == 0) {
      // 0 페이지에서 1 페이지로 (위로 스와이프)
      _pageController.animateToPage(
        _alarmsTopOffset <= startPosition - dragThreshold ||
                velocity < -minVelocity
            ? 1
            : 0,
        duration: 300.ms,
        curve: Curves.easeInOut,
      );
    } else {
      // 1 페이지에서 0 페이지로 (아래로 스와이프)
      _pageController.animateToPage(
        _alarmsTopOffset >= dragThreshold || velocity > minVelocity ? 0 : 1,
        duration: 300.ms,
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 위젯이 처음 빌드되거나, 페이지 인덱스가 0일 때 _alarmsTopOffset을 초기 위치로 설정
    if (_currentPageIndex == 0 && _alarmsTopOffset == 0.0) {
      _alarmsTopOffset = getWinHeight(context) - _initialBottomOffset;
    } else if (_currentPageIndex == 1 && _alarmsTopOffset != 0.0) {
      _alarmsTopOffset = 0.0;
    }

    final Duration animationDuration =
        _pageController.hasClients &&
                _pageController.page?.round() != _currentPageIndex
            ? 0
                .ms // PageController로 제어될 때 즉시 이동
            : 300.ms; // 사용자 드래그 시에는 300ms 애니메이션 적용

    final double blurSigma = _currentPageIndex == 0 ? 1.0 : 0.0; // 블러 강도 조절

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(), // PageView 기본 스크롤 비활성화
            children: <Widget>[FirstMainLayer(), SecondMainLayer()],
          ),
          AnimatedPositioned(
            duration: animationDuration,
            curve: Curves.easeInOut,
            top: _alarmsTopOffset,
            height: getWinHeight(context),
            child: GestureDetector(
              // ✨ 여기에 GestureDetector 추가
              onVerticalDragStart: _onVerticalDragStart,
              onVerticalDragUpdate: _onVerticalDragUpdate,
              onVerticalDragEnd: _onVerticalDragEnd,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: getWinWidth(context),
                color: Colors.transparent,
                child: SafeArea(
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/images/icons/double_up_arrow_icon.svg',
                        height: 30, // 아이콘 크기 적절히 조절
                      ).animate().fade(
                        begin: _currentPageIndex == 0 ? 0.0 : 1.0,
                        end: _currentPageIndex == 0 ? 1.0 : 0.0,
                        duration: 300.ms,
                        curve: Curves.easeInOut,
                      ),
                      Text(
                        '알림',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ).animate().fade(
                        begin: _currentPageIndex == 0 ? 1.0 : 0.0,
                        end: _currentPageIndex == 0 ? 0.0 : 1.0,
                        duration: 300.ms,
                        curve: Curves.easeInOut,
                      ),
                      _currentPageIndex == 1 ? Gaps.v28 : Container(),
                      Expanded(
                        child: IgnorePointer(
                          ignoring: _currentPageIndex == 0,
                          child: AlarmTabContent(type: 'my'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 85,
            left: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
                child: CreateAlarmButton(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
