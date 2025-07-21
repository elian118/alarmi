import 'dart:math';

import 'package:alarmi/common/consts/raw_data/cat_random_speeches.dart';
import 'package:alarmi/common/consts/raw_data/cat_regular_speeches.dart';
import 'package:alarmi/common/widgets/speech_bubble.dart';
import 'package:alarmi/features/onboarding/services/character_service.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

class FirstMainLayer extends StatefulWidget {
  const FirstMainLayer({super.key});

  @override
  State<FirstMainLayer> createState() => _FirstMainLayerState();
}

class _FirstMainLayerState extends State<FirstMainLayer>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late String message = '';
  late String? personality;
  String catImg = 'home_day_cat_sit_x3_opti';

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    changeRegularMotion();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void setRandomSpeech() async {
    if (!mounted) return;

    setState(() {
      message = '';
    });

    String? personality = await CharacterService.getCharacterPersonality();

    if (personality != null) {
      RandomSpeech targetRandomSpeech =
          randomSpeech
              .where((speech) => personality == speech.personality)
              .first;

      debugPrint(targetRandomSpeech.personality);
      int randomIdx = Random().nextInt(targetRandomSpeech.message.length - 1);

      setState(() {
        message = targetRandomSpeech.message[randomIdx];
      });
    }
  }

  void setRegularSpeech() async {
    if (!mounted) return;

    setState(() {
      message = '';
    });

    String? personality = await CharacterService.getCharacterPersonality();

    if (personality != null) {
      final now = DateTime.now();
      final currentHour = now.hour;
      String situation =
          currentHour >= 6 && currentHour < 12
              ? 'good morning'
              : currentHour >= 12 && currentHour < 20
              ? 'good afternoon'
              : 'good evening';
      RegularSpeech targetRegularSpeech =
          regularSpeech
              .where(
                (speech) =>
                    personality == speech.personality &&
                    situation == speech.situation,
              )
              .first;

      debugPrint(targetRegularSpeech.personality);

      setState(() {
        message = targetRegularSpeech.message;
      });
    }
  }

  void changeRegularMotion() {
    setState(() {
      catImg = 'home_day_cat_hi_x3_opti';
    });
    setRegularSpeech();

    Future.delayed(3.1.seconds, () {
      setState(() {
        message = '';
        catImg = 'home_day_cat_sit_x3_opti';
      });
    });
  }

  void changeMotion() {
    setState(() {
      catImg = 'home_day_cat_wave_x3_opti';
    });
    setRandomSpeech();

    Future.delayed(2.1.seconds, () {
      setState(() {
        message = '';
        catImg = 'home_day_cat_sit_x3_opti';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: changeMotion,
      child: Stack(
        children: [
          Positioned.fill(
            child: Stack(
              // fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/backgrounds/home_day_bg.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: getWinHeight(context) * 0.26,
                  child:
                      message != ''
                          ? SpeechBubble(message: message)
                          : Container(),
                ),
                Lottie.asset('assets/lotties/home_day_bg_cloud_2x.json'),
                Positioned.fill(
                  child: Lottie.asset(
                    'assets/lotties/home_day_bg_sunlight_2x.json',
                  ),
                ),
                Positioned.fill(
                  child: Lottie.asset(
                    'assets/lotties/home_day_bg_sea_1x_02.json',
                  ),
                ),

                Container(
                  alignment: Alignment.center,
                  child: Lottie.asset(
                    'assets/lotties/$catImg.json',
                    // 'assets/lotties/home_day_cat_hi_x3_opti.json',
                    // 'assets/lotties/home_day_cat_wave_x3_opti.json',
                    width: getWinWidth(context) * 0.7,
                    height: getWinWidth(context) * 0.7,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: getWinHeight(context),
              color: Colors.transparent,
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }
}
