import 'package:alarmi/common/layers/background_layer.dart';
import 'package:alarmi/features/main/layers/my_alarm_ui_layer.dart';
import 'package:alarmi/features/main/layers/my_cat_layer.dart';
import 'package:flutter/material.dart';

class MyAlarmScreen extends StatelessWidget {
  const MyAlarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: BackgroundLayer(image: 'assets/images/my_alarm_bg.png'),
          ),
          Positioned.fill(child: MyAlarmUiLayer()),
          Positioned.fill(child: MyCatLayer()),
        ],
      ),
    );
  }
}
