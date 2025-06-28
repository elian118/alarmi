import 'package:alarmi/features/alarm/layers/alarms_ui_layer.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/material.dart';

class AlarmsScreen extends StatelessWidget {
  static const String routeName = 'alarms';
  static const String routeURL = '/alarms';

  const AlarmsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              width: getWinWidth(context),
              height: getWinHeight(context),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.lightBlue, Colors.black87],
                ),
              ),
            ),
          ),
          Positioned.fill(child: AlarmsUiLayer()),
        ],
      ),
    );
  }
}
