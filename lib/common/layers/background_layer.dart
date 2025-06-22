import 'dart:ui';

import 'package:flutter/material.dart';

class BackgroundLayer extends StatelessWidget {
  final String image;

  const BackgroundLayer({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Image.asset(image, fit: BoxFit.cover)),
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
