import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/common/vms/bottom_section_view_model.dart';
import 'package:alarmi/features/alarm/screens/alarms_screen.dart';
import 'package:alarmi/features/main/widgets/cat_menus.dart';
import 'package:alarmi/features/main/widgets/create_alarm_menus.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:alarmi/utils/route_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'cst_round_btn.dart';
import 'main_navigation_screen.dart';

class BottomSection extends ConsumerWidget {
  const BottomSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomSectionState = ref.watch(bottomSectionProvider);

    final bottomSectionNotifier = ref.read(bottomSectionProvider.notifier);
    final bool isOpenCatMenus = bottomSectionState.isOpenCatMenus;
    final bool isOpenCreateAlarmMenus =
        bottomSectionState.isOpenCreateAlarmMenus;

    Widget? getMatchedBtn(String currentPath) {
      switch (currentPath) {
        case AlarmsScreen.routeURL:
          return CstRoundBtn(
            label: '홈',
            gaps: Gaps.h28,
            onPressed: () => context.go(MainNavigationScreen.routeURL),
            backgroundColor: Colors.grey.shade800,
            icon: const Icon(Icons.home), // const 추가
          );
        case MainNavigationScreen.routeURL:
          return CstRoundBtn(
            label: '내 알람',
            onPressed: () => context.push(AlarmsScreen.routeURL),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            icon: SvgPicture.asset(
              "assets/images/icons/my_alarm_icon.svg",
              width: 18,
              height: 18,
              fit: BoxFit.contain,
              colorFilter: const ColorFilter.mode(
                Colors.black,
                BlendMode.srcIn,
              ),
            ),
          );
        default:
          return const SizedBox.shrink(); // 아무것도 반환하지 않는 대신 빈 SizedBox 반환
      }
    }

    String currentPath = getCurrentPath(context);
    const double maxWidthLimit = 280.0; // const 추가

    return Column(
      children: [
        Stack(
          children: [
            Positioned(
              right: 0,
              bottom: 0,
              child: CatMenus(
                setOpenCatMenus: bottomSectionNotifier.setOpenCatMenus,
                isOpenCatMenus: isOpenCatMenus,
              ),
            ),
            CreateAlarmMenus(),
          ],
        ),
        Hero(
          tag: 'bottomSection',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width:
                    getWinWidth(context) * 0.7 > maxWidthLimit
                        ? maxWidthLimit
                        : getWinWidth(context) * 0.7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    !isOpenCreateAlarmMenus
                        ? CstRoundBtn(
                          label: '알람 생성',
                          icon: SvgPicture.asset(
                            "assets/images/icons/gen_alarm_icon.svg",
                            width: 18,
                            height: 18,
                            fit: BoxFit.contain,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                          onPressed: () {
                            bottomSectionNotifier
                                .toggleCreateAlarmAndCloseCatMenus();
                          },
                        )
                        : CstRoundBtn(
                          label: '취소',
                          gaps: Gaps.h20,
                          onPressed: () {
                            // ViewModel의 통합된 메서드 사용
                            bottomSectionNotifier
                                .toggleCreateAlarmAndCloseCatMenus();
                          },
                          backgroundColor: Colors.grey.shade800,
                          foregroundColor: Colors.white,
                          icon: const Icon(Icons.close),
                        ),
                    getMatchedBtn(currentPath)!,
                  ],
                ),
              ),

              isOpenCatMenus
                  ? IconButton(
                    onPressed: () {
                      // ViewModel의 통합된 메서드 사용
                      bottomSectionNotifier
                          .toggleCatMenusAndCloseCreateAlarmMenus();
                    },
                    icon: const Icon(Icons.close, size: 30), // const 추가
                    style: IconButton.styleFrom(backgroundColor: Colors.white),
                  )
                  : IconButton(
                    onPressed: () {
                      // ViewModel의 통합된 메서드 사용
                      bottomSectionNotifier
                          .toggleCatMenusAndCloseCreateAlarmMenus();
                    },
                    icon: SvgPicture.asset(
                      isOpenCatMenus
                          ? "assets/images/icons/close.svg"
                          : "assets/images/icons/cat_icon.svg",
                      width: 18,
                      height: 18,
                      fit: BoxFit.contain,
                      colorFilter:
                          isOpenCatMenus // 이 조건도 마찬가지
                              ? null
                              : const ColorFilter.mode(
                                Colors.black,
                                BlendMode.srcIn,
                              ),
                    ),
                    style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(13),
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}
