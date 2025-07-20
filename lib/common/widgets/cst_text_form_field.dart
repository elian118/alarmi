import 'package:flutter/material.dart';

class CstTextFormField extends StatelessWidget {
  final String? hintText;
  final String? Function(String?)? validator;
  final void Function(String value)? onChanged;
  final void Function(String?)? onSaved;

  const CstTextFormField({
    Key? key,
    this.hintText,
    this.validator,
    this.onSaved,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.white.withValues(alpha: 0.5),
          fontSize: 26,
          fontWeight: FontWeight.w400,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).disabledColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).focusColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.0,
          ), // 빨간색 선 두께 2.0
        ),
        errorStyle: const TextStyle(
          color: Colors.red, // 텍스트 색상 빨간색
          fontSize: 14, // 폰트 크기
          fontWeight: FontWeight.w500, // 폰트 두께
        ),
      ),
      cursorColor: Colors.blueAccent,
      validator: validator,
      onChanged: onChanged,
      onSaved: onSaved,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 26,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
