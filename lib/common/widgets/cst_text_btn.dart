import 'dart:ffi';

import 'package:flutter/material.dart';

class CstTextBtn extends StatelessWidget {
  final String label;
  final TextStyle style;
  final Double? width;
  final String? imgIconSrc;
  final double? spacing;
  final void Function()? onPressed;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  const CstTextBtn({
    super.key,
    required this.label,
    required this.style,
    this.width,
    this.imgIconSrc,
    this.spacing,
    this.onPressed,
    this.padding,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: padding,
      ),
      onPressed: onPressed,
      child: Row(
        spacing: spacing != null ? spacing! : 12,
        children: [
          if (imgIconSrc != null) Image.asset(imgIconSrc!),
          Text(label, style: style),
        ],
      ),
    );
  }
}
