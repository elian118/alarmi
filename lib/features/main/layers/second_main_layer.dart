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
                colors: [Color(0xFF2b6fa5), Color(0xFF02365a)],
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
