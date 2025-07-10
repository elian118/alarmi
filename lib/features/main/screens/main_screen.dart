import 'dart:ui';

import 'package:alarmi/features/main/layers/first_main_layer.dart';
import 'package:alarmi/features/main/layers/my_alarms_layer.dart';
import 'package:alarmi/features/main/layers/second_main_layer.dart';
import 'package:alarmi/features/main/widgets/create_alarm_button.dart';
import 'package:flutter/material.dart';

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
          // Positioned(
          //   top: 50,
          //   right: 20,
          //   child: GestureDetector(
          //     onTap: () => context.push(AlarmTestScreen.routeURL),
          //     child: Image.asset(
          //       'assets/images/characters/thumb.png',
          //     ).animate().scale(
          //       duration: Duration(milliseconds: 500),
          //       curve: Curves.easeInOut,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
