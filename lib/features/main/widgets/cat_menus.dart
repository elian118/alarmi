import 'package:alarmi/common/consts/gaps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';

class CatMenus extends StatelessWidget {
  final Function(bool) setOpenCatMenus;
  final bool isOpenCatMenus;

  const CatMenus({
    super.key,
    required this.setOpenCatMenus,
    required this.isOpenCatMenus,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 0),
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
                      setOpenCatMenus(false);
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
                      setOpenCatMenus(false);
                      /*showModalBottomSheet(
                  context: context,
                  builder:
                      (context) => FeedDialog(
                    toggleLight: _toggleLight,
                    setMessage: _setMessage,
                  ),
                  isScrollControlled: true,
                );*/
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
        .animate(target: isOpenCatMenus ? 1 : 0)
        .slideY(
          begin: -0.5,
          end: 0.0,
          curve: Curves.easeInOut,
          duration: 0.5.seconds,
        )
        .fadeIn();
  }
}
