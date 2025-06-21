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
