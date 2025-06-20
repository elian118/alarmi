import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void focusout(BuildContext context) {
  FocusScope.of(context).unfocus();
}

double getWinWidth(BuildContext context) => MediaQuery.of(context).size.width;

double getWinHeight(BuildContext context) => MediaQuery.of(context).size.height;

bool isWebScreen(BuildContext context) => kIsWeb;

bool isDarkMode(BuildContext context) =>
    MediaQuery.of(context).platformBrightness == Brightness.dark;

bool isKorean(BuildContext context) =>
    Localizations.localeOf(context).toString() == 'ko';
