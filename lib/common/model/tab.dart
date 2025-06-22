import 'package:flutter/material.dart';

class Tab {
  final String key;
  final String name;
  final String iconAsset;
  final Widget target;

  Tab({
    required this.key,
    required this.name,
    required this.iconAsset,
    required this.target,
  });
}
