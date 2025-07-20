import 'package:flutter/material.dart';

class BackgroundLayer extends StatelessWidget {
  const BackgroundLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.asset(
        'assets/images/backgrounds/onboard_bg.png',
        fit: BoxFit.cover,
      ),
    );
  }
}
