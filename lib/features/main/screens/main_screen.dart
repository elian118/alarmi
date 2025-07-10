import 'dart:ui';

import 'package:alarmi/features/main/layers/first_main_layer.dart';
import 'package:alarmi/features/main/layers/my_alarms_layer.dart';
import 'package:alarmi/features/main/layers/second_main_layer.dart';
import 'package:alarmi/features/main/widgets/create_alarm_button.dart';
import 'package:alarmi/features/test/screens/alarm_test_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatefulWidget {
  static const String routeName = 'main';
  static const String routeURL = '/main';

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController(initialPage: 0);

  int _currentPageIndex = 0; // 현재 페이지 인덱스
  // 예: 250 -> 350으로 변경

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

  @override
  Widget build(BuildContext context) {
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
          MyAlarmsLayer(
            currentPageIndex: _currentPageIndex,
            pageController: _pageController,
          ),
          // AnimatedPositioned(
          //   duration: animationDuration,
          //   curve: Curves.easeInOut,
          //   top: _alarmsTopOffset,
          //   height: getWinHeight(context),
          //   child: GestureDetector(
          //     // ✨ 여기에 GestureDetector 추가
          //     onVerticalDragStart: _onVerticalDragStart,
          //     onVerticalDragUpdate: _onVerticalDragUpdate,
          //     onVerticalDragEnd: _onVerticalDragEnd,
          //     child: Container(
          //       padding: const EdgeInsets.symmetric(horizontal: 20),
          //       width: getWinWidth(context),
          //       color: Colors.transparent,
          //       child: SafeArea(
          //         child: Column(
          //           children: [
          //             SvgPicture.asset(
          //               'assets/images/icons/double_up_arrow_icon.svg',
          //               height: 30, // 아이콘 크기 적절히 조절
          //             ).animate().fade(
          //               begin: _currentPageIndex == 0 ? 0.0 : 1.0,
          //               end: _currentPageIndex == 0 ? 1.0 : 0.0,
          //               duration: 300.ms,
          //               curve: Curves.easeInOut,
          //             ),
          //             Text(
          //               '알림',
          //               style: TextStyle(
          //                 fontSize: 16,
          //                 color: Colors.white,
          //                 fontWeight: FontWeight.w700,
          //               ),
          //             ).animate().fade(
          //               begin: _currentPageIndex == 0 ? 1.0 : 0.0,
          //               end: _currentPageIndex == 0 ? 0.0 : 1.0,
          //               duration: 300.ms,
          //               curve: Curves.easeInOut,
          //             ),
          //             _currentPageIndex == 1 ? Gaps.v28 : Container(),
          //             Expanded(child: AlarmTabContent(type: 'my')),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
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
