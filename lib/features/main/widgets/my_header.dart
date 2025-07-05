import 'package:alarmi/common/widgets/main_navigation_screen.dart';
import 'package:alarmi/features/alarm/screens/alarms_screen.dart';
import 'package:alarmi/features/alarm/widgets/alarms_header_menus.dart';
import 'package:alarmi/features/main/widgets/main_header_menus.dart';
import 'package:alarmi/utils/route_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MyHeader extends ConsumerWidget {
  const MyHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double foldedHeaderWidth = 90.0;
    double unfoldedHeaderWidth = 260.0;

    String currentPath = getCurrentPath(context);

    late Widget? headerMenusWidget;

    switch (currentPath) {
      case AlarmsScreen.routeURL:
        headerMenusWidget = AlarmsHeaderMenus();
        break;
      case MainNavigationScreen.routeURL:
        headerMenusWidget = MainHeaderMenus(
          foldedHeaderWidth: foldedHeaderWidth,
          unfoldedHeaderWidth: unfoldedHeaderWidth,
        );
        break;
      default:
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        headerMenusWidget ?? Container(),
        GestureDetector(
          onTap: () => context.push('/alarm-test'),
          child: Image.asset(
            'assets/images/characters/thumb.png',
          ).animate().scale(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          ),
        ),
      ],
    );
  }
}
