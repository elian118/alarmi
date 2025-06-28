import 'package:alarmi/features/alarm/screens/alarms_screen.dart';
import 'package:alarmi/features/main/widgets/main_header_menus.dart';
import 'package:alarmi/utils/route_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MyHeader extends StatefulWidget {
  const MyHeader({super.key});

  @override
  State<MyHeader> createState() => _MyHeaderState();
}

class _MyHeaderState extends State<MyHeader> {
  bool _isFold = true;
  double _foldedHeaderWidth = 90.0;
  double _unfoldedHeaderWidth = 260.0;

  void toggleFold() {
    setState(() {
      _isFold = !_isFold;
    });
  }

  Widget? getMatchedHeaderMenus(String currentPath) {
    switch (currentPath) {
      case AlarmsScreen.routeURL:
        return null;
      case '/main':
        return MainHeaderMenus(
          isFold: _isFold,
          foldedHeaderWidth: _foldedHeaderWidth,
          unfoldedHeaderWidth: _unfoldedHeaderWidth,
          toggleFold: toggleFold,
        );
      default:
        Container();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    String currentPath = getCurrentPath(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        getMatchedHeaderMenus(currentPath) ?? Container(),
        Image.asset('assets/images/characters/thumb.png').animate().scale(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        ),
      ],
    );
  }
}
