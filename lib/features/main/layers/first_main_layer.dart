import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/material.dart';

class FirstMainLayer extends StatelessWidget {
  const FirstMainLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Stack(
            // fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/backgrounds/bg_1.png',
                  fit: BoxFit.cover,
                ),
              ),
              Transform.scale(
                scale: 1.1,
                child: Image.asset(
                  'assets/images/backgrounds/clouds.png',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            height: getWinHeight(context),
            color: Colors.transparent,
            child: Container(),
          ),
        ),
      ],
    );
  }
}
