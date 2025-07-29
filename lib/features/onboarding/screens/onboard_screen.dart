import 'package:alarmi/features/onboarding/constants/stage_types.dart';
import 'package:alarmi/features/onboarding/layers/background_layer.dart';
import 'package:alarmi/features/onboarding/layers/button_layer.dart';
import 'package:alarmi/features/onboarding/layers/character_layer.dart';
import 'package:alarmi/features/onboarding/layers/fade_layer.dart';
import 'package:alarmi/features/onboarding/layers/message_layer.dart';
import 'package:alarmi/features/onboarding/layers/naming_layer.dart';
import 'package:alarmi/features/onboarding/models/onboard_state.dart';
import 'package:alarmi/features/onboarding/vms/onboard_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardScreen extends ConsumerStatefulWidget {
  static const String routeName = 'onboard';
  static const String routeURL = '/onboard';

  const OnboardScreen({super.key});

  @override
  ConsumerState<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends ConsumerState<OnboardScreen> {
  bool _isTapEnabled = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(onboardViewProvider.notifier).initStates();
      _isTapEnabled = true;
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onboardState = ref.watch(onboardViewProvider);
    final onboardNotifier = ref.read(onboardViewProvider.notifier);

    ref.listen<OnboardState>(onboardViewProvider, (previous, next) {
      // 탭 가능 상태 초기화(허용)
      if (previous?.stage != next.stage) {
        setState(() {
          _isTapEnabled = true;
        });
      }
    });

    void onTab() {
      if (_isTapEnabled && stageTypes[onboardState.stage].isClickable) {
        setState(() {
          _isTapEnabled = false;
        });
        onboardNotifier.next();
      }
    }

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
            setState(() {
              _isTapEnabled = false;
            });
            onboardNotifier.prev();
          },
        ),
      ),
      body: GestureDetector(
        onTap: onTab,
        child: Stack(
          children: [
            BackgroundLayer(),
            FadeLayer(),
            CharacterLayer(),
            MessageLayer(),
            NamingLayer(),
            ButtonLayer(),
            // 테스트 스크린으로 이동하는 버튼
            // Positioned(
            //   top: 50,
            //   right: 20,
            //   child: GestureDetector(
            //     onTap: () => context.push(AlarmTestScreen.routeURL),
            //     child: Image.asset(
            //       'assets/images/characters/thumb.png',
            //     ).animate().scale(
            //       duration: Duration(milliseconds: 500),
            //       curve: Curves.easeInOut,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
