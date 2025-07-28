import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void callSimpleToast(String msg) => Fluttertoast.showToast(
  msg: msg,
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.BOTTOM,
  timeInSecForIosWeb: 1,
  backgroundColor: Colors.black54, // 배경색
  textColor: Colors.white,
  fontSize: 16.0, // 폰트 크기
);

void callToast(BuildContext context, String msg, {Widget? icon}) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: Duration(seconds: 3), // 3초 동안 표시
        behavior: SnackBarBehavior.floating, // 바닥에 붙지 않고 플로팅
        content: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Color(0xFF2C3E50),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[icon, SizedBox(width: 10)],
                Text(
                  msg,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
