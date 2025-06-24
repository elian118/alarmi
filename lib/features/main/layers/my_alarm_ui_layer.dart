import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/features/main/widgets/bottom_section.dart';
import 'package:alarmi/features/main/widgets/my_header.dart';
import 'package:flutter/material.dart';

class MyAlarmUiLayer extends StatelessWidget {
  const MyAlarmUiLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.size28),
        child: Column(
          children: [
            MyHeader(),
            Gaps.v80,
            Spacer(),
            BottomSection() /*MyAlarms()*/,
          ],
        ),
      ),
    );
  }
}
