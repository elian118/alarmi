import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/common/widgets/cst_error.dart';
import 'package:alarmi/common/widgets/cst_part_loading.dart';
import 'package:alarmi/features/alarm/services/alarm_notifier.dart';
import 'package:alarmi/features/alarm/widgets/alarm_tab_content.dart';
import 'package:alarmi/features/main/vms/main_view_model.dart';
import 'package:alarmi/features/main/widgets/no_alarms.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class MyAlarmsLayer extends ConsumerStatefulWidget {
  final PageController pageController;

  const MyAlarmsLayer({super.key, required this.pageController});

  @override
  ConsumerState<MyAlarmsLayer> createState() => _MyAlarmsLayerState();
}

class _MyAlarmsLayerState extends ConsumerState<MyAlarmsLayer> {
  static const double _initialBottomOffset = 300.0;

  @override
  void initState() {
    super.initState();
    // PageController의 페이지 변경을 감지하는 리스너 추가
    widget.pageController.addListener(_handlePageChange);
  }

  @override
  void dispose() {
    widget.pageController.removeListener(_handlePageChange);
    super.dispose();
  }

  void _handlePageChange() {
    // PageController 페이지가 변경될 때 MainViewModel 업데이트
    final currentPage = widget.pageController.page?.round() ?? 0;

    if (ref.read(mainViewProvider).currentPageIndex != currentPage) {
      ref.read(mainViewProvider.notifier).setCurrentPage(currentPage);

      // 페이지가 변경될 때 alarmsTopOffset 동기화
      // currentPage가 0이면 초기 위치, 1이면 상단
      final screenHeight = getWinHeight(context);
      final newOffset =
          currentPage == 0 ? screenHeight - _initialBottomOffset : 0.0;
      ref.read(mainViewProvider.notifier).setAlarmsTopOffset(newOffset);
    }
  }

  // 이하 GestureDetector 콜백 함수들
  void _onVerticalDragStart(DragStartDetails details) {
    ref
        .read(mainViewProvider.notifier)
        .setDragStartY(details.globalPosition.dy);
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    final mainNotifier = ref.read(mainViewProvider.notifier);
    final currentMainState = ref.read(mainViewProvider); // 현재 상태 스냅샷

    final double screenHeight = getWinHeight(context);
    final double startPosition = screenHeight - _initialBottomOffset;
    final double dragDelta =
        details.globalPosition.dy - currentMainState.dragStartY;

    double newAlarmsTopOffset =
        currentMainState.currentPageIndex == 0
            ? startPosition + dragDelta
            : dragDelta;

    // 위치 제한
    if (newAlarmsTopOffset < 0) {
      newAlarmsTopOffset = 0;
    }
    if (newAlarmsTopOffset > startPosition) {
      newAlarmsTopOffset = startPosition;
    }

    mainNotifier.setAlarmsTopOffset(newAlarmsTopOffset);
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    final mainState = ref.read(mainViewProvider); // 현재 상태 스냅샷

    if (mainState.hasNoAlarms) return;

    final double screenHeight = getWinHeight(context);
    final double startPosition = screenHeight - _initialBottomOffset;
    final double dragThreshold = screenHeight * 0.15;
    final double velocity = details.primaryVelocity ?? 0.0;
    final double minVelocity = 600.0;

    if (mainState.currentPageIndex == 0) {
      widget.pageController.animateToPage(
        mainState.alarmsTopOffset <= startPosition - dragThreshold ||
                velocity < -minVelocity
            ? 1
            : 0,
        duration: 1000.ms,
        curve: Curves.decelerate,
      );
    } else {
      widget.pageController.animateToPage(
        mainState.alarmsTopOffset >= dragThreshold || velocity > minVelocity
            ? 0
            : 1,
        duration: 1000.ms,
        curve: Curves.decelerate,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mainState = ref.watch(mainViewProvider);
    final currentPageIndex = mainState.currentPageIndex;
    final alarmsTopOffset = mainState.alarmsTopOffset;
    final hasNoAlarms = mainState.hasNoAlarms;

    final AsyncValue<List<Map<String, dynamic>>> alarmAsync = ref.watch(
      alarmListProvider('my'),
    );

    final Duration animationDuration =
        widget.pageController.hasClients &&
                widget.pageController.page?.round() != currentPageIndex
            ? 0.ms
            : 300.ms;

    return AnimatedPositioned(
      duration: animationDuration,
      curve: Curves.easeInOut,
      top: alarmsTopOffset,
      height: getWinHeight(context),
      child: GestureDetector(
        onVerticalDragStart: _onVerticalDragStart,
        onVerticalDragUpdate: _onVerticalDragUpdate,
        onVerticalDragEnd: _onVerticalDragEnd,
        child: Container(
          // padding: const EdgeInsets.symmetric(horizontal: 20),
          width: getWinWidth(context),
          color: Colors.transparent,
          child: SafeArea(
            child: Column(
              children: [
                alarmAsync.when(
                  data: (alarms) {
                    if (hasNoAlarms != alarms.isEmpty) {
                      ref
                          .read(mainViewProvider.notifier)
                          .setHasNoAlarms(alarms.isEmpty);
                    }

                    if (alarms.isEmpty) {
                      return Column(children: [Gaps.v52, NoAlarms()]);
                    } else {
                      return SvgPicture.asset(
                        'assets/images/icons/double_up_arrow_icon.svg',
                        height: 18,
                      ).animate().fade(
                        begin: currentPageIndex == 0 ? 0.0 : 1.0,
                        end: currentPageIndex == 0 ? 1.0 : 0.0,
                        duration: 300.ms,
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  error:
                      (error, stackTrace) => CstError(
                        error: error,
                        errorMessage: '알람을 불러오는 데 오류가 발생했습니다.',
                      ),
                  loading: () => CstPartLoading(),
                ),
                Text(
                  '알림',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ).animate().fade(
                  begin: currentPageIndex == 0 ? 1.0 : 0.0,
                  end: currentPageIndex == 0 ? 0.0 : 1.0,
                  duration: 300.ms,
                  curve: Curves.easeInOut,
                ),
                currentPageIndex == 1 ? Gaps.v28 : Container(),
                Expanded(
                  child: AlarmTabContent(
                    type: 'my',
                    currentPageIndex: currentPageIndex,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
