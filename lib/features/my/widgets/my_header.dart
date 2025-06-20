import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/material.dart';

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
              Row(
                children: [
                  Image.asset('assets/images/fish_icon.png'),
                  Gaps.h8,
                  Text('보관함', style: TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
              Row(
                children: [
                  Image.asset('assets/images/shopping_icon.png'),
                  Gaps.h8,
                  Text('상점', style: TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
              Row(
                children: [
                  Image.asset('assets/images/bell_icon.png'),
                  Gaps.h8,
                  Text('알림', style: TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ),
        Image.asset('assets/images/thumb.png'),
      ],
    );
  }
}
