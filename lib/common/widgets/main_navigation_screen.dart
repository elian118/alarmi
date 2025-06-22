import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/common/consts/tabs.dart';
import 'package:alarmi/common/widgets/custom_navigaton.dart';
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
  List<Widget> offStages = [...tabs.map((tab) => tab.target)];
  late int _selectedIndex = [...tabs.map((t) => t.key)].indexOf(widget.tab);

  void _onTap(int index) {
    context.go('/${tabs[index].key}');
    // context.push('/${tabs[index].key}'); // 이동할때마다 새로 스크린 불러옴(초기 애니메이션이 재생됨)
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    if (kIsWeb) tabs.remove("xxxxx");
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
              // 탭 스크린마다 초기 애니메이션이 다시 시작될 수 있도록 각 스크린의 키를 변경해준다.
              child: KeyedSubtree(
                key: ValueKey(
                  tabs[_selectedIndex].key +
                      DateTime.now().microsecondsSinceEpoch.toString(),
                ),
                child: offStage,
              ),
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
