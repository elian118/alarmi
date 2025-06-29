import 'package:alarmi/common/layers/background_layer.dart';
import 'package:alarmi/features/main/layers/my_alarm_ui_layer.dart';
import 'package:alarmi/features/main/layers/my_cat_layer.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  static const String routeName = 'main';
  static const String routeURL = '/main';

  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: BackgroundLayer(
              image: 'assets/images/backgrounds/my_alarm_bg.png',
            ),
          ),
          Positioned.fill(child: MyAlarmUiLayer()),
          Positioned.fill(child: MyCatLayer()),
        ],
      ),
    );
  }
}
