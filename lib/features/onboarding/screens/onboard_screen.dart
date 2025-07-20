import 'package:alarmi/features/onboarding/layers/background_layer.dart';
import 'package:alarmi/features/onboarding/layers/button_layer.dart';
import 'package:alarmi/features/onboarding/layers/character_layer.dart';
import 'package:alarmi/features/onboarding/layers/message_layer.dart';
import 'package:alarmi/features/onboarding/layers/naming_layer.dart';
import 'package:flutter/material.dart';

class OnboardScreen extends StatelessWidget {
  static const String routeName = 'onboard';
  static const String routeURL = '/onboard';

  const OnboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          '고양이 만들기',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          BackgroundLayer(),
          CharacterLayer(),
          MessageLayer(),
          NamingLayer(),
          ButtonLayer(),
        ],
      ),
    );
  }
}
