import 'package:flutter/material.dart';

class AlarmTabs extends StatefulWidget {
  const AlarmTabs({super.key});

  @override
  State<AlarmTabs> createState() => _AlarmTabsState();
}

class _AlarmTabsState extends State<AlarmTabs> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          indicatorColor: Colors.white,
          unselectedLabelColor: Colors.white.withValues(alpha: 0.5),
          dividerColor: Colors.white.withValues(alpha: 0.1),
          dividerHeight: 3,
          labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          tabs: <Widget>[Tab(text: '개인 알람'), Tab(text: '팀 알람')],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              Center(
                child: Text(
                  "저장된 알람이 없습니다.",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              Center(
                child: Text(
                  "저장된 알람이 없습니다.",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
