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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isTapEnabled = true;

    final onboardState = ref.watch(onboardViewProvider);
    final onboardNotifier = ref.read(onboardViewProvider.notifier);

    ref.listen<OnboardState>(onboardViewProvider, (previous, next) {
      // 탭 가능 상태 초기화(허용)
      if (previous?.stage != next.stage) {
        setState(() {
          isTapEnabled = true;
        });
      }

      if (stageTypes[next.stage].isClickable) {
        // 자동 이동 로직 비활성화(사유: 광클 버그 야기)
        // Future.delayed(3.seconds, () => onboardNotifier.next());
      } else {
        bool isStage0 = next.stage == 0 && previous?.stage != 0;
        bool isStage10 = next.stage == 10 && previous?.stage != 10;
        bool isStage11 = next.stage == 11 && previous?.stage != 11;

        if (isStage0) {
          ref.read(onboardViewProvider.notifier).initStates(); // 초기화
        } else if (isStage10) {
          Future.delayed(11.seconds, () => onboardNotifier.next());
        } else if (isStage11) {
          Future.delayed(4.seconds, () => onboardNotifier.next());
        }
      }
    });

    void onTab() {
      if (isTapEnabled && stageTypes[onboardState.stage].isClickable) {
        setState(() {
          isTapEnabled = false;
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
              isTapEnabled = false;
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
          ],
        ),
      ),
    );
  }
}
