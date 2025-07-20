import 'package:alarmi/features/onboarding/layers/background_layer.dart';
import 'package:alarmi/features/onboarding/layers/button_layer.dart';
import 'package:alarmi/features/onboarding/layers/character_layer.dart';
import 'package:alarmi/features/onboarding/layers/message_layer.dart';
import 'package:alarmi/features/onboarding/layers/naming_layer.dart';
import 'package:alarmi/features/onboarding/vms/onboard_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardScreen extends ConsumerWidget {
  static const String routeName = 'onboard';
  static const String routeURL = '/onboard';

  const OnboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardNotifier = ref.read(
      onboardViewProvider.notifier,
    ); // onboardNotifier 접근

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            // 실제 뒤로가기 대신 onboardNotifier의 setStage 함수 호출
            onboardNotifier.setStage(
              ref.read(onboardViewProvider).stage - 1,
            ); // 현재 스테이지에서 1 감소
          },
        ),
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
