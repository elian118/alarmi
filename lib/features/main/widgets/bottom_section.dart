import 'package:alarmi/common/consts/gaps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomSection extends StatefulWidget {
  const BottomSection({super.key});

  @override
  State<BottomSection> createState() => _BottomSectionState();
}

class _BottomSectionState extends State<BottomSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                      "assets/images/gen_alarm_icon.svg",
                      width: 18,
                      height: 18,
                      fit: BoxFit.contain,
                      colorFilter: ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    Gaps.h8,
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
              onPressed: () {},
              style: ElevatedButton.styleFrom(foregroundColor: Colors.black),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 13),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/images/my_alarm_icon.svg",
                      width: 18,
                      height: 18,
                      fit: BoxFit.contain,
                      colorFilter: ColorFilter.mode(
                        Colors.black,
                        BlendMode.srcIn,
                      ),
                    ),
                    Gaps.h8,
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
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.close),
              style: IconButton.styleFrom(
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
