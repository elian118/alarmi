import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/common/widgets/cst_text_btn.dart';
import 'package:alarmi/features/my/screens/notifications_screen.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:alarmi/utils/route_utils.dart';
import 'package:alarmi/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MyHeader extends StatelessWidget {
  const MyHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            vertical: Sizes.size8,
            horizontal: Sizes.size28,
          ),
          width: getWinWidth(context) * 0.6,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CstTextBtn(
                imgIconSrc: 'assets/images/fish_icon.png',
                padding: EdgeInsets.zero,
                spacing: 8,
                label: '보관함',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                onPressed: () => callSimpleToast("보관함 클릭"),
              ),
              CstTextBtn(
                imgIconSrc: 'assets/images/shopping_icon.png',
                padding: EdgeInsets.zero,
                spacing: 8,
                label: '상점',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                onPressed: () => callSimpleToast("상점 클릭"),
              ),
              CstTextBtn(
                imgIconSrc: 'assets/images/bell_icon.png',
                padding: EdgeInsets.zero,
                spacing: 8,
                label: '알림',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                // onPressed: () => callSimpleToast("알림 클릭"),
                onPressed:
                    () => navPagePush(context, NotificationsScreen(), true),
              ),
            ],
          ),
        ).animate().slideX(
          begin: -1,
          end: 0,
          duration: 0.6.seconds,
          curve: Curves.easeInOut,
        ),
        Image.asset('assets/images/thumb.png').animate().scale(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        ),
      ],
    );
  }
}
