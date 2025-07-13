import 'package:flutter/material.dart';

class ShakingClamsScreen extends StatelessWidget {
  static const String routeName = 'shaking_clams';
  static const String routeURL = '/shaking_clams';

  const ShakingClamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('조개 흔들기')));
  }
}
