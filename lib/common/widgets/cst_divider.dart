import 'package:flutter/material.dart';

class CstDivider extends StatelessWidget {
  final double width;
  final double thickness;

  const CstDivider({super.key, required this.width, required this.thickness});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: thickness,
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
