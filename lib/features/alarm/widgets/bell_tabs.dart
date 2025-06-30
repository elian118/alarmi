import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/common/consts/raw_data/bells.dart';
import 'package:alarmi/features/alarm/widgets/bell_tab.dart';
import 'package:flutter/material.dart';

class BellTabs extends StatefulWidget {
  const BellTabs({super.key});

  @override
  State<BellTabs> createState() => _BellTabsState();
}

class _BellTabsState extends State<BellTabs> with TickerProviderStateMixin {
  late final TabController _bellTabController;

  @override
  void initState() {
    _bellTabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _bellTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TabBar(
            controller: _bellTabController,
            labelColor: Colors.white,
            labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            unselectedLabelColor: Colors.white.withValues(alpha: 0.5),
            dividerHeight: 0,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            indicator: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(10),
            ),
            // indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(text: '기본'),
              Tab(text: '신호음'),
              Tab(text: '자연'),
              Tab(text: '에너지'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _bellTabController,
            children: <Widget>[
              ...bellCategories.map(
                (category) => SingleChildScrollView(
                  child: Column(
                    spacing: 14,
                    children: [
                      Gaps.v12,
                      ...bells
                          .where((bell) => bell.category == category)
                          .map((e) => BellTab(title: e.name)),
                      Gaps.v12,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
