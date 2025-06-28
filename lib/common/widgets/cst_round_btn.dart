import 'package:flutter/material.dart';

import '../consts/gaps.dart';

class CstRoundBtn extends StatelessWidget {
  final String label;
  final SizedBox? gaps;
  final Widget? icon;
  final double? width;
  final TextStyle? labelStyle;
  final void Function()? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const CstRoundBtn({
    super.key,
    required this.label,
    this.gaps,
    this.onPressed,
    this.labelStyle,
    this.width,
    this.backgroundColor,
    this.foregroundColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.blue,
        foregroundColor: foregroundColor ?? Colors.white,
      ),
      child: Container(
        width: width ?? 84,
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            icon ?? Icon(Icons.close),
            icon != null ? (gaps ?? Gaps.h12) : SizedBox(width: 0),
            Text(
              label,
              style:
                  labelStyle ??
                  TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
