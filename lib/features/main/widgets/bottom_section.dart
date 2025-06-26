import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/features/main/widgets/feed_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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

  void toggleCatMenus() {
    setState(() {
      _isOpenCatMenus = !_isOpenCatMenus;
    });
  }

  void toggleGenAlarms() {
    setState(() {
      _isOpenGenAlarms = !_isOpenGenAlarms;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: 12,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '낚시하기',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Gaps.h12,
                      IconButton(
                        onPressed: () {
                          toggleCatMenus();
                        },
                        // 복잡해서 그런지, svg 형식 인식 못함 -> png로 변경
                        icon: Image.asset(
                          "assets/images/icons/fishing_rod_icon.png",
                          width: 18,
                          height: 18,
                          fit: BoxFit.contain,
                        ),
                        style: IconButton.styleFrom(
                          padding: EdgeInsets.all(13),
                          backgroundColor: Colors.white,
                          shape: CircleBorder(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '고양이 밥 주기',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Gaps.h12,
                      IconButton(
                        onPressed: () {
                          toggleCatMenus();
                          showModalBottomSheet(
                            context: context,
                            builder:
                                (context) => FeedDialog(
                                  toggleLight: _toggleLight,
                                  setMessage: _setMessage,
                                ),
                            isScrollControlled: true,
                          );
                        },
                        icon: SvgPicture.asset(
                          "assets/images/icons/feed.svg",
                          width: 18,
                          height: 18,
                          fit: BoxFit.contain,
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
              ),
            )
            .animate(target: _isOpenCatMenus ? 1 : 0)
            .slideY(begin: -0.5, end: 0.0)
            .fadeIn(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 14,
          children: [
            ElevatedButton(
              onPressed: () {},
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
            ),
            ElevatedButton(
              onPressed: () => context.go('/alarm-test'),
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
                  onPressed: toggleCatMenus,
                  icon: Icon(Icons.close, size: 30),
                  style: IconButton.styleFrom(backgroundColor: Colors.white),
                )
                : IconButton(
                  onPressed: toggleCatMenus,
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
