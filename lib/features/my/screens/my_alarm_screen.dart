import 'package:alarmi/features/my/layers/my_alarm_background_layer.dart';
import 'package:alarmi/features/my/layers/my_alarm_ui_layer.dart';
import 'package:alarmi/features/my/layers/my_cat_layer.dart';
import 'package:flutter/material.dart';

class MyAlarmScreen extends StatelessWidget {
  const MyAlarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: MyAlarmBackgroundLayer()),
          Positioned.fill(child: MyAlarmUiLayer()),
          Positioned.fill(child: MyCatLayer()),
        ],
      ),
    );
  }
}
