import 'package:alarmi/common/widgets/cst_text_btn.dart';
import 'package:alarmi/features/main/screens/notifications_screen.dart';
import 'package:alarmi/utils/route_utils.dart';
import 'package:alarmi/utils/toast_utils.dart';
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

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(40.0),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            width: _isFold ? _foldedHeaderWidth : _unfoldedHeaderWidth,
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
                    maxWidth: _unfoldedHeaderWidth - _foldedHeaderWidth + 120,
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
                              _isFold
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
                              imgIconSrc: 'assets/images/fish_icon.png',
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
                              imgIconSrc: 'assets/images/shopping_icon.png',
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
                              imgIconSrc: 'assets/images/bell_icon.png',
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
                        ).animate(target: _isFold ? 0 : 1).fadeIn(),
                      ],
                    ),
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: IconButton(
                    onPressed: toggleFold,
                    icon:
                        _isFold
                            ? Icon(Icons.chevron_right)
                            : Icon(Icons.chevron_left),
                  ),
                ),
              ],
            ),
          ),
        ).animate().slideX(begin: -1, end: 0),

        Image.asset('assets/images/thumb.png').animate().scale(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        ),
      ],
    );
  }
}
