import 'package:alarmi/common/consts/raw_data/navs.dart';
import 'package:alarmi/common/widgets/nav_tab.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/material.dart';

class CustomNavigation extends StatelessWidget {
  final int selectedIndex;
  final void Function(int selectedIdx) onTap;

  const CustomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    return Container(
      color: isDark ? Colors.black : Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var nav in navs)
            NavTab(
              text: nav['title'],
              icon: nav['icon'],
              isSelected: selectedIndex == navs.indexOf(nav),
              onTap: () => onTap(navs.indexOf(nav)),
              selectedIndex: selectedIndex,
            ),
        ],
      ),
    );
  }
}
