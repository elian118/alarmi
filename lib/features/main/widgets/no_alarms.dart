import 'package:flutter/material.dart';

class NoAlarms extends StatelessWidget {
  const NoAlarms({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '아직 알람이 없어요.',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
