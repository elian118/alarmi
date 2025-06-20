import 'dart:ui';

import 'package:flutter/material.dart';

class MyAlarmBackgroundLayer extends StatelessWidget {
  const MyAlarmBackgroundLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/my-alarm-bg.png',
            fit: BoxFit.cover,
          ),
        ),
        // 흐리게
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
            child: Center(child: Text('', style: TextStyle(fontSize: 28))),
          ),
        ),
      ],
    );
  }
}
