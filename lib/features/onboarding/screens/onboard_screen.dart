import 'package:alarmi/features/onboarding/layers/background_layer.dart';
import 'package:alarmi/features/onboarding/layers/button_layer.dart';
import 'package:alarmi/features/onboarding/layers/character_layer.dart';
import 'package:alarmi/features/onboarding/layers/fade_layer.dart';
import 'package:alarmi/features/onboarding/layers/message_layer.dart';
import 'package:alarmi/features/onboarding/layers/naming_layer.dart';
import 'package:alarmi/features/onboarding/models/onboard_state.dart';
import 'package:alarmi/features/onboarding/vms/onboard_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardScreen extends ConsumerStatefulWidget {
  static const String routeName = 'onboard';
  static const String routeURL = '/onboard';

  const OnboardScreen({super.key});

  @override
  ConsumerState<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends ConsumerState<OnboardScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(onboardViewProvider.notifier).initStates();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final onboardNotifier = ref.read(onboardViewProvider.notifier);

    ref.listen<OnboardState>(onboardViewProvider, (previous, next) {
      if (next.stage == 10 && previous?.stage != 10) {
        Future.delayed(11.seconds, () {
          onboardNotifier.next();
        });
      } else if (next.stage == 11 && previous?.stage != 11) {
        Future.delayed(5.seconds, () {
          onboardNotifier.next();
        });
      }
    });

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
          onPressed: () => onboardNotifier.prev(),
        ),
      ),
      body: GestureDetector(
        onTap: () => onboardNotifier.next(),
        child: Stack(
          children: [
            BackgroundLayer(),
            FadeLayer(),
            CharacterLayer(),
            MessageLayer(),
            NamingLayer(),
            ButtonLayer(),
          ],
        ),
      ),
    );
  }
}
