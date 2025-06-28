import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/common/widgets/bottom_section.dart';
import 'package:alarmi/features/main/widgets/my_header.dart';
import 'package:flutter/material.dart';

class AlarmsUiLayer extends StatelessWidget {
  const AlarmsUiLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(Sizes.size28),
        child: Column(
          children: [MyHeader(), Gaps.v80, Spacer(), BottomSection()],
        ),
      ),
    );
  }
}
