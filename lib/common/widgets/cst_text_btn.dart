import 'package:flutter/material.dart';

class CstTextBtn extends StatelessWidget {
  final String label;
  final TextStyle style;
  final double? width;
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
    Widget? buildIcons(Object? ic) {
      return ic is String
          ? Image.asset(ic)
          : ic is Widget
          ? ic
          : null;
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
        children: [buildIcons(icon) ?? Container(), Text(label, style: style)],
      ),
    );
  }
}
