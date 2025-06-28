import 'dart:ffi';

import 'package:flutter/material.dart';

class CstTextBtn extends StatelessWidget {
  final String label;
  final TextStyle style;
  final Double? width;
  final Object? icon;
  final double? spacing;
  final void Function()? onPressed;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const CstTextBtn({
    super.key,
    required this.label,
    required this.style,
    this.width,
    this.icon,
    this.spacing,
    this.onPressed,
    this.padding,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    late Widget? _icon;

    if (icon is String) {
      _icon = Image.asset(icon as String);
    } else if (icon is Widget) {
      _icon = icon as Widget;
    }

    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        padding: padding,
      ),
      onPressed: onPressed,
      child: Row(
        spacing: spacing != null ? spacing! : 12,
        children: [_icon ?? Container(), Text(label, style: style)],
      ),
    );
  }
}
