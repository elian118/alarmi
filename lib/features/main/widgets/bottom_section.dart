import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/features/main/widgets/cat_menus.dart';
import 'package:alarmi/features/main/widgets/gen_alarm_menus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class BottomSection extends StatefulWidget {
  const BottomSection({super.key});

  @override
  State<BottomSection> createState() => _BottomSectionState();
}

class _BottomSectionState extends State<BottomSection> {
  bool _isOpenCatMenus = false;
  bool _isOpenGenAlarms = false;
  bool _isOpenGenAlarmMenus = false;
  bool _isLight = false;
  String _message = '좋은 아침!';

  void _toggleLight() {
    setState(() {
      _isLight = !_isLight;
    });
  }

  void _setMessage(newMsg) {
    setState(() {
      _message = newMsg;
    });
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _message = '좋은 아침!';
      });
    });
  }

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

  @override
  Widget build(BuildContext context) {
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

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 14,
          children: [
            !_isOpenGenAlarmMenus
                ? ElevatedButton(
                  onPressed: () {
                    setOpenGenAlarmMenus(!_isOpenGenAlarmMenus);
                    setOpenCatMenus(false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 13),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/images/icons/gen_alarm_icon.svg",
                          width: 18,
                          height: 18,
                          fit: BoxFit.contain,
                          colorFilter: ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                        Gaps.h12,
                        Text(
                          '알람 생성',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                : ElevatedButton(
                  onPressed: () {
                    setOpenGenAlarmMenus(!_isOpenGenAlarmMenus);
                    setOpenCatMenus(false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade800,
                    foregroundColor: Colors.white,
                  ),
                  child: Container(
                    width: 82,
                    padding: EdgeInsets.symmetric(vertical: 13),
                    child: Row(
                      children: [
                        Icon(Icons.close),
                        Gaps.h20,
                        Text(
                          '취소',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ElevatedButton(
              onPressed: () => context.push('/alarm-test'),
              style: ElevatedButton.styleFrom(foregroundColor: Colors.black),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 13),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/images/icons/my_alarm_icon.svg",
                      width: 18,
                      height: 18,
                      fit: BoxFit.contain,
                      colorFilter: ColorFilter.mode(
                        Colors.black,
                        BlendMode.srcIn,
                      ),
                    ),
                    Gaps.h12,
                    Text(
                      '내 알람',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
      ],
    );
  }
}
