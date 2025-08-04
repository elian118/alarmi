import 'package:alarmi/common/widgets/cst_text_btn.dart';
import 'package:alarmi/features/main/screens/notifications_screen.dart';
import 'package:alarmi/features/main/vms/header_view_model.dart';
import 'package:alarmi/utils/route_utils.dart';
import 'package:alarmi/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainHeaderMenus extends ConsumerWidget {
  final double foldedHeaderWidth;
  final double unfoldedHeaderWidth;

  const MainHeaderMenus({
    super.key,
    required this.foldedHeaderWidth,
    required this.unfoldedHeaderWidth,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isFold = ref.watch(headerStateProvider);
    final VoidCallback toggleFold =
        ref.read(headerStateProvider.notifier).toggleFold;

    return ClipRRect(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        width: isFold ? foldedHeaderWidth : unfoldedHeaderWidth,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(40.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                onPressed: toggleFold,
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
                          icon: 'assets/images/icons/fish_icon.png',
                          padding: EdgeInsets.zero,
                          spacing: 8,
                          label: '보관함',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          onPressed: () => callToast(context, "보관함 클릭"),
                        ),
                        CstTextBtn(
                          icon: 'assets/images/icons/shopping_icon.png',
                          padding: EdgeInsets.zero,
                          spacing: 8,
                          label: '상점',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          onPressed: () => callToast(context, "상점 클릭"),
                        ),
                        CstTextBtn(
                          icon: 'assets/images/icons/bell_icon.png',
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

            IconButton(
              onPressed: toggleFold,
              icon:
                  isFold ? Icon(Icons.chevron_right) : Icon(Icons.chevron_left),
            ),
          ],
        ),
      ),
    ).animate().slideX(begin: -1, end: 0);
  }
}
