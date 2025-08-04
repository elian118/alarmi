import 'package:alarmi/common/widgets/cst_text_btn.dart';
import 'package:alarmi/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AlarmsHeaderMenus extends StatelessWidget {
  const AlarmsHeaderMenus({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 38,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CstTextBtn(
            icon: Icon(Icons.person, color: Colors.white),
            padding: EdgeInsets.zero,
            spacing: 8,
            label: '보관함',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            onPressed: () => callToast(context, "잠수함 클릭"),
          ),
          CstTextBtn(
            icon: Icon(Icons.favorite, color: Colors.red),
            padding: EdgeInsets.zero,
            spacing: 8,
            label: '응원',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            onPressed: () => callToast(context, "응원 클릭"),
          ),
        ],
      ),
    ).animate().slideX(begin: -1, end: 0);
  }
}
