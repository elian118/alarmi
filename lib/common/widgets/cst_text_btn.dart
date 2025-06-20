import 'dart:ffi';

import 'package:alarmi/common/consts/sizes.dart';
import 'package:flutter/material.dart';

class CstTextBtn extends StatelessWidget {
  final String label;
  final TextStyle style;
  final Double? width;
  final String? imgIconSrc;
  final void Function()? onPressed;

  const CstTextBtn({
    super.key,
    required this.label,
    required this.style,
    this.width,
    this.imgIconSrc,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: Sizes.size24),
      ),
      onPressed: onPressed,
      child: Row(
        spacing: 12,
        children: [
          if (imgIconSrc != null) Image.asset(imgIconSrc!),
          Text(label, style: style),
        ],
      ),
    );
  }
}
