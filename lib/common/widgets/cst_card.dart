import 'package:flutter/material.dart';

class CstCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;

  const CstCard({super.key, required this.child, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.black87.withValues(alpha: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5), // 그림자 색상 및 투명도
            spreadRadius: 5, // 그림자 확장 정도
            blurRadius: 10, // 그림자 흐림 정도
            offset: const Offset(0, 5), // 그림자 위치 (x, y)
          ),
        ],
      ),
      child: child,
    );
  }
}
