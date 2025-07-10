import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';

import '../../alarm/widgets/alarm_tab_content.dart';

class MyAlarmsLayer extends StatefulWidget {
  final PageController pageController;
  final int currentPageIndex;

  const MyAlarmsLayer({
    super.key,
    required this.pageController,
    required this.currentPageIndex,
  });

  @override
  State<MyAlarmsLayer> createState() => _MyAlarmsLayerState();
}

class _MyAlarmsLayerState extends State<MyAlarmsLayer> {
  double _dragStartY = 0.0; // 드래그 시작 시 Y 좌표
  double _alarmsTopOffset = 0.0;
  static const double _initialBottomOffset = 250.0;

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
          widget.currentPageIndex == 0 ? startPosition + dragDelta : dragDelta;

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

    if (widget.currentPageIndex == 0) {
      // 0 페이지에서 1 페이지로 (위로 스와이프)
      widget.pageController.animateToPage(
        _alarmsTopOffset <= startPosition - dragThreshold ||
                velocity < -minVelocity
            ? 1
            : 0,
        duration: 300.ms,
        curve: Curves.easeInOut,
      );
    } else {
      // 1 페이지에서 0 페이지로 (아래로 스와이프)
      widget.pageController.animateToPage(
        _alarmsTopOffset >= dragThreshold || velocity > minVelocity ? 0 : 1,
        duration: 300.ms,
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 위젯이 처음 빌드되거나, 페이지 인덱스가 0일 때 _alarmsTopOffset을 초기 위치로 설정
    if (widget.currentPageIndex == 0 && _alarmsTopOffset == 0.0) {
      _alarmsTopOffset = getWinHeight(context) - _initialBottomOffset;
    } else if (widget.currentPageIndex == 1 && _alarmsTopOffset != 0.0) {
      _alarmsTopOffset = 0.0;
    }

    final Duration animationDuration =
        widget.pageController.hasClients &&
                widget.pageController.page?.round() != widget.currentPageIndex
            ? 0
                .ms // PageController로 제어될 때 즉시 이동
            : 300.ms; // 사용자 드래그 시에는 300ms 애니메이션 적용

    return AnimatedPositioned(
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
                  begin: widget.currentPageIndex == 0 ? 0.0 : 1.0,
                  end: widget.currentPageIndex == 0 ? 1.0 : 0.0,
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
                  begin: widget.currentPageIndex == 0 ? 1.0 : 0.0,
                  end: widget.currentPageIndex == 0 ? 0.0 : 1.0,
                  duration: 300.ms,
                  curve: Curves.easeInOut,
                ),
                widget.currentPageIndex == 1 ? Gaps.v28 : Container(),
                Expanded(child: AlarmTabContent(type: 'my')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
