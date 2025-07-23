import 'package:alarmi/features/onboarding/layers/character_layer.dart';
import 'package:flutter/material.dart';

import '../../features/onboarding/layers/background_layer.dart';

class CstLoading extends StatelessWidget {
  const CstLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundLayer(),
        CharacterLayer(),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 300),
              Text(
                '열심히 불러오고 있어요...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Center(
          child: CircularProgressIndicator(), // 로딩 인디케이터,
        ),
      ],
    );
  }
}
