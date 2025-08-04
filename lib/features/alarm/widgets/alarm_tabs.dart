import 'package:alarmi/features/alarm/widgets/alarm_tab_content.dart';
import 'package:flutter/material.dart';

class AlarmTabs extends StatefulWidget {
  const AlarmTabs({super.key});

  @override
  State<AlarmTabs> createState() => _AlarmTabsState();
}

class _AlarmTabsState extends State<AlarmTabs> with TickerProviderStateMixin {
  late final TabController _tabController;
  final GlobalKey<AlarmTabContentState> _myAlarmTabKey = GlobalKey();
  final GlobalKey<AlarmTabContentState> _teamAlarmTabKey = GlobalKey();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        if (_tabController.index == 0) {
          (_myAlarmTabKey.currentState as dynamic)?.refreshAlarms();
        } else if (_tabController.index == 1) {
          (_teamAlarmTabKey.currentState as dynamic)?.refreshAlarms();
        }
      }
    });
    super.initState();
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
        // Expanded(
        //   child: TabBarView(
        //     controller: _tabController,
        //     children: <Widget>[
        //       AlarmTabContent(key: _myAlarmTabKey, type: 'my'),
        //       AlarmTabContent(key: _teamAlarmTabKey, type: 'team'),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
