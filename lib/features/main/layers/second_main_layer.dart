import 'package:alarmi/common/consts/raw_data/bg_gradation_color_set.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/material.dart';

class SecondMainLayer extends StatelessWidget {
  const SecondMainLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: bgGradationColorSet,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
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
