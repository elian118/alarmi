import 'package:alarmi/common/consts/tabs.dart';
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
    final List<String> tabKeys = [...tabs.map((t) => t.key)];

    return Container(
      color: isDark ? Colors.black : Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var tab in tabs)
            NavTab(
              text: tab.name,
              icon: tab.iconAsset,
              isSelected: selectedIndex == tabKeys.indexOf(tab.key),
              onTap: () => onTap(tabKeys.indexOf(tab.key)),
              selectedIndex: selectedIndex,
            ),
        ],
      ),
    );
  }
}
