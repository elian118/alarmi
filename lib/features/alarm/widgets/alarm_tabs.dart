import 'package:alarmi/common/consts/raw_data/weekdays.dart';
import 'package:alarmi/features/alarm/models/alarm_params.dart';
import 'package:alarmi/features/alarm/models/weekday.dart';
import 'package:alarmi/features/alarm/services/alarm_service.dart';
import 'package:alarmi/features/main/widgets/alarm.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class AlarmTabs extends StatefulWidget {
  const AlarmTabs({super.key});

  @override
  State<AlarmTabs> createState() => _AlarmTabsState();
}

class _AlarmTabsState extends State<AlarmTabs> with TickerProviderStateMixin {
  late final TabController _tabController;
  final AlarmService _alarmService = AlarmService();
  late Future<List<Map<String, dynamic>>> _alarms;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _alarms = _alarmService.getAlarms();
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
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              FutureBuilder(
                future: _alarms,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '알람을 불러오는 데 오류가 발생했습니다. ${snapshot.error}',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        "저장된 알람이 없습니다.",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    );
                  } else {
                    final List<Map<String, dynamic>> alarms = snapshot.data!;
                    return SingleChildScrollView(
                      child: Column(
                        children:
                            alarms.map((alarm) {
                              final AlarmParams? alarmParams;
                              alarmParams = AlarmParams.fromJson(alarm);

                              // weekdays 리스트가 유효한지 확인하고 안전하게 사용
                              final List<String> repeatDayNames =
                                  alarmParams.weekdays.map((wId) {
                                    final Weekday? weekday = weekdays
                                        .firstWhereOrNull((wd) => wd.id == wId);
                                    return weekday?.name ??
                                        ''; // 찾지 못하면 빈 문자열 반환
                                  }).toList();

                              return Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                      width: 0.6,
                                    ),
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 20,
                                ),
                                child: Alarm(
                                  isDisabled: false,
                                  time: alarm['alarmTime'],
                                  repeatDays: repeatDayNames,
                                ),
                              );
                            }).toList(),
                      ),
                    );
                  }
                },
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
