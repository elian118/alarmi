import 'package:alarmi/common/widgets/cst_text_btn.dart';
import 'package:alarmi/features/main/screens/notifications_screen.dart';
import 'package:alarmi/utils/route_utils.dart';
import 'package:alarmi/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MainHeaderMenus extends StatelessWidget {
  final bool isFold;
  final double foldedHeaderWidth;
  final double unfoldedHeaderWidth;
  final Function()? toggleFold;

  const MainHeaderMenus({
    super.key,
    required this.isFold,
    required this.foldedHeaderWidth,
    required this.unfoldedHeaderWidth,
    this.toggleFold,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        width: isFold ? foldedHeaderWidth : unfoldedHeaderWidth,
        height: 47,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(40.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: OverflowBox(
                maxWidth: unfoldedHeaderWidth - foldedHeaderWidth + 120,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
                      transitionBuilder:
                          (child, animation) => SizeTransition(
                            sizeFactor: animation,
                            axis: Axis.horizontal,
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          ),
                      child:
                          isFold
                              ? IconButton(
                                key: ValueKey<String>('menu_btn_visible'),
                                onPressed: () {},
                                icon: Icon(Icons.menu),
                              )
                              : SizedBox(
                                key: ValueKey<String>('menu_btn_hidden'),
                                width: 24,
                              ),
                    ),
                    Row(
                      children: [
                        CstTextBtn(
                          imgIconSrc: 'assets/images/icons/fish_icon.png',
                          padding: EdgeInsets.zero,
                          spacing: 8,
                          label: '보관함',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          onPressed: () => callSimpleToast("보관함 클릭"),
                        ),
                        CstTextBtn(
                          imgIconSrc: 'assets/images/icons/shopping_icon.png',
                          padding: EdgeInsets.zero,
                          spacing: 8,
                          label: '상점',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          onPressed: () => callSimpleToast("상점 클릭"),
                        ),
                        CstTextBtn(
                          imgIconSrc: 'assets/images/icons/bell_icon.png',
                          padding: EdgeInsets.zero,
                          spacing: 8,
                          label: '알림',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          // onPressed: () => callSimpleToast("알림 클릭"),
                          onPressed:
                              () => navPagePush(
                                context,
                                NotificationsScreen(),
                                true,
                              ),
                        ),
                      ],
                    ).animate(target: isFold ? 0 : 1).fadeIn(),
                  ],
                ),
              ),
            ),

            Container(
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: toggleFold,
                icon:
                    isFold
                        ? Icon(Icons.chevron_right)
                        : Icon(Icons.chevron_left),
              ),
            ),
          ],
        ),
      ),
    ).animate().slideX(begin: -1, end: 0);
  }
}
