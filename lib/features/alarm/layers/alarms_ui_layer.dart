import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/common/widgets/bottom_section.dart';
import 'package:alarmi/features/alarm/widgets/alarm_tabs.dart';
import 'package:alarmi/features/main/widgets/my_header.dart';
import 'package:flutter/material.dart';

class AlarmsUiLayer extends StatelessWidget {
  const AlarmsUiLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(padding: EdgeInsets.all(Sizes.size28), child: MyHeader()),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(child: AlarmTabs()),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.all(Sizes.size28),
                    child: BottomSection(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
