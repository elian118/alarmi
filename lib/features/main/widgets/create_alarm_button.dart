import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/features/alarm/screens/create_alarm_screen.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class CreateAlarmButton extends StatelessWidget {
  const CreateAlarmButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getWinWidth(context),
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed:
            () => context.pushNamed(
              CreateAlarmScreen.routeName,
              pathParameters: {'type': 'my', 'alarmId': 'null'},
            ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 0),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
          elevation: 0,
        ),
        child: Stack(
          children: [
            SizedBox(
              width: 146,
              height: 56,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  // 안쪽 그림자 색상
                  final Color innerShadowColor = Color(0xFFA7C4FF);
                  return RadialGradient(
                    colors: <Color>[
                      // Colors.white,
                      innerShadowColor.withValues(alpha: 0.0),
                      innerShadowColor.withValues(alpha: 0.8),
                    ],
                    stops: const [0.0, 1.0], // 시작과 끝 지점
                    radius: 0.8,
                    tileMode: TileMode.clamp,
                  ).createShader(bounds);
                },
                blendMode: BlendMode.srcATop,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    border: Border.all(width: 1, color: Colors.white),
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
