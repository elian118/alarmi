import 'package:flutter/material.dart';

void callDialog(
  BuildContext context, {
  double? width,
  double? height,
  required Widget child,
}) => showDialog(
  context: context,
  builder:
      (context) => AlertDialog(
        clipBehavior: Clip.hardEdge,
        content: Builder(
          builder:
              (context) => SizedBox(width: width, height: height, child: child),
        ),
      ),
);

/*void showFirebaseErrorSnack(BuildContext context, Object? error) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        (error as FirebaseException).message ?? "Something wen't wrong.",
      ),
    ),
  );
}*/
