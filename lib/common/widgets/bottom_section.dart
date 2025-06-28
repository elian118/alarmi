import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/common/widgets/cst_round_btn.dart';
import 'package:alarmi/features/alarm/screens/alarms_screen.dart';
import 'package:alarmi/features/main/widgets/cat_menus.dart';
import 'package:alarmi/features/main/widgets/gen_alarm_menus.dart';
import 'package:alarmi/utils/route_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'main_navigation_screen.dart';

class BottomSection extends StatefulWidget {
  const BottomSection({super.key});

  @override
  State<BottomSection> createState() => _BottomSectionState();
}

class _BottomSectionState extends State<BottomSection> {
  bool _isOpenCatMenus = false;
  bool _isOpenGenAlarms = false;
  bool _isOpenGenAlarmMenus = false;

  void setOpenCatMenus(value) {
    setState(() {
      _isOpenCatMenus = value;
    });
  }

  void toggleGenAlarms() {
    setState(() {
      _isOpenGenAlarms = !_isOpenGenAlarms;
    });
  }

  void setOpenGenAlarmMenus(value) {
    setState(() {
      _isOpenGenAlarmMenus = value;
    });
  }

  Widget? getMatchedBtn(String currentPath) {
    switch (currentPath) {
      case AlarmsScreen.routeURL:
        return CstRoundBtn(
          label: '홈',
          gaps: Gaps.h28,
          onPressed: () => context.go(MainNavigationScreen.routeURL),
          backgroundColor: Colors.grey.shade800,
          icon: Icon(Icons.home),
        );
      case MainNavigationScreen.routeURL:
        return CstRoundBtn(
          label: '내 알람',
          onPressed: () => context.push('/alarm-test'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          icon: SvgPicture.asset(
            "assets/images/icons/my_alarm_icon.svg",
            width: 18,
            height: 18,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
        );
      default:
        Container();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    String currentPath = getCurrentPath(context);

    return Column(
      children: [
        Stack(
          children: [
            Positioned(
              right: 0,
              bottom: 0,
              child: CatMenus(
                setOpenCatMenus: setOpenCatMenus,
                isOpenCatMenus: _isOpenCatMenus,
              ),
            ),
            GenAlarmMenus(
              setOpenGenAlarmMenus: setOpenGenAlarmMenus,
              isOpenGenAlarmMenus: _isOpenGenAlarmMenus,
            ),
          ],
        ),

        Hero(
          tag: 'bottomSection',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 14,
            children: [
              !_isOpenGenAlarmMenus
                  ? CstRoundBtn(
                    label: '알람 생성',
                    icon: SvgPicture.asset(
                      "assets/images/icons/gen_alarm_icon.svg",
                      width: 18,
                      height: 18,
                      fit: BoxFit.contain,
                      colorFilter: ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: () {
                      setOpenGenAlarmMenus(!_isOpenGenAlarmMenus);
                      setOpenCatMenus(false);
                    },
                  )
                  : CstRoundBtn(
                    label: '취소',
                    gaps: Gaps.h20,
                    onPressed: () {
                      setOpenGenAlarmMenus(!_isOpenGenAlarmMenus);
                      setOpenCatMenus(false);
                    },
                    backgroundColor: Colors.grey.shade800,
                    foregroundColor: Colors.white,
                    icon: Icon(Icons.close),
                  ),

              getMatchedBtn(currentPath)!,

              Spacer(),
              _isOpenCatMenus
                  ? IconButton(
                    onPressed: () {
                      setOpenCatMenus(!_isOpenCatMenus);
                      setOpenGenAlarmMenus(false);
                    },
                    icon: Icon(Icons.close, size: 30),
                    style: IconButton.styleFrom(backgroundColor: Colors.white),
                  )
                  : IconButton(
                    onPressed: () {
                      setOpenCatMenus(!_isOpenCatMenus);
                      setOpenGenAlarmMenus(false);
                    },
                    icon: SvgPicture.asset(
                      _isOpenCatMenus
                          ? "assets/images/icons/close.svg"
                          : "assets/images/icons/cat_icon.svg",
                      width: 18,
                      height: 18,
                      fit: BoxFit.contain,
                      colorFilter:
                          _isOpenCatMenus
                              ? null
                              : ColorFilter.mode(Colors.black, BlendMode.srcIn),
                    ),
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.all(13),
                      backgroundColor: Colors.white,
                      shape: CircleBorder(),
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}
