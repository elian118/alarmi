import 'package:alarmi/features/shaking_clams/layers/guide_layer.dart';
import 'package:flutter/material.dart';

class ShakingClamsScreen extends StatelessWidget {
  static const String routeName = 'shaking_clams';
  static const String routeURL = '/shaking_clams';

  const ShakingClamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgrounds/mission_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          GuideLayer(),
        ],
      ),
    );
  }
}
