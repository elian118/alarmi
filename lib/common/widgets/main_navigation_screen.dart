import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/common/widgets/custom_navigaton.dart';
import 'package:alarmi/features/my/screens/my_alarm_screen.dart';
import 'package:alarmi/features/my/screens/new_alarm_screen.dart';
import 'package:alarmi/features/my/screens/team_alarm_screen.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainNavigationScreen extends StatefulWidget {
  static const String routeName = 'mainNavigation';
  final String tab;

  const MainNavigationScreen({super.key, required this.tab});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final List<String> _tabs = [
    "my",
    "new",
    "team", // fake element for video post icon
  ];

  List<Widget> offStages = [
    const MyAlarmScreen(),
    const NewAlarmScreen(),
    const TeamAlarmScreen(),
  ];

  late int _selectedIndex = _tabs.indexOf(widget.tab);

  void _onTap(int index) {
    context.go('/${_tabs[index]}');
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    if (kIsWeb) _tabs.remove("xxxxx");
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          for (var offStage in offStages)
            Offstage(
              offstage: _selectedIndex != offStages.indexOf(offStage),
              child: offStage,
            ),
        ],
      ),
      bottomNavigationBar: Container(
        color: isDark ? Colors.black : Colors.white,
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: Sizes.size12,
            horizontal: Sizes.size28,
          ),
          child: CustomNavigation(selectedIndex: _selectedIndex, onTap: _onTap),
        ),
      ),
    );
  }
}
