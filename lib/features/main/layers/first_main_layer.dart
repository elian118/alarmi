import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FirstMainLayer extends StatefulWidget {
  const FirstMainLayer({super.key});

  @override
  State<FirstMainLayer> createState() => _FirstMainLayerState();
}

class _FirstMainLayerState extends State<FirstMainLayer>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
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
                    'assets/lotties/home_day_cat_sit_x3_opti.json',
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
