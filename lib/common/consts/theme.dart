import 'package:flutter/material.dart';

ThemeData commonTheme = ThemeData(
  fontFamily: "Pretendard",
  colorScheme: ColorScheme.light().copyWith(
    // UI 배경색
    primary: const Color(0xFF3E7EFF),
    primaryContainer: const Color(0xFF1F5CD5),
    secondary: const Color(0xFF4692C4),
    secondaryContainer: const Color(0xFF36506F),
    tertiary: const Color(0xFF8EB4FF),
    inverseSurface: const Color(0xFF717171),
    error: const Color(0xFFFF5F5F),
    // 폰트 색상
    onPrimary: Colors.white,
    onPrimaryContainer: Colors.white,
    onSecondary: Colors.white,
    onSecondaryContainer: Colors.white,
    onTertiary: const Color(0xFFEBEFFF),
    onInverseSurface: const Color(0xFFACACAC),
  ),
);
