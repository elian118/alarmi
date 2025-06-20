import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NavTab extends StatelessWidget {
  const NavTab({
    super.key,
    required this.text,
    required this.isSelected,
    required this.icon,
    required this.onTap,
    required this.selectedIndex,
    this.selectedIcon,
  });

  final String text;
  final bool isSelected;
  final String icon;
  final VoidCallback onTap;
  final int selectedIndex;
  final IconData? selectedIcon;

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    final Color targetColor =
        isSelected ? (!isDark ? Colors.black : Colors.white) : Colors.grey;
    ColorTween colorTween = ColorTween(
      begin: isSelected ? (!isDark ? Colors.black : Colors.white) : Colors.grey,
      end: targetColor,
    );

    return Expanded(
      child: GestureDetector(
        onTap: onTap, // Function onTap 선언 시, () => onTap
        child: Container(
          color: isDark ? Colors.black : Colors.white,
          child: AnimatedOpacity(
            opacity: isSelected ? 1 : 0.6,
            duration: const Duration(milliseconds: 300),
            child: Column(
              mainAxisSize: MainAxisSize.min, // 자식위젯이 차지하는 만큼을 최대 높이로 지정
              children: [
                TweenAnimationBuilder(
                  duration: Duration(milliseconds: 300),
                  builder:
                      (context, color, child) => SvgPicture.asset(
                        icon,
                        width: 34,
                        height: 34,
                        fit: BoxFit.contain,
                        colorFilter: ColorFilter.mode(color!, BlendMode.srcIn),
                      ),
                  tween: colorTween,
                ),
                Gaps.v5,
                Text(
                  text,
                  style: TextStyle(
                    color: !isDark ? Colors.black : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
