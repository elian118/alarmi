import 'package:alarmi/common/model/tab.dart';
import 'package:alarmi/features/main/screens/my_alarm_screen.dart';
import 'package:alarmi/features/main/screens/new_alarm_screen.dart';
import 'package:alarmi/features/main/screens/team_alarm_screen.dart';

List<Tab> tabs = [
  Tab(
    key: "main",
    name: "개인 알람",
    iconAsset: "assets/images/icons/bi_person_fill.svg",
    target: MyAlarmScreen(),
  ),
  Tab(
    key: "new",
    name: "알람 생성",
    iconAsset: "assets/images/icons/tabler_alarm_plus_filled.svg",
    target: NewAlarmScreen(),
  ),
  Tab(
    key: "team",
    name: "팀 알람",
    iconAsset: "assets/images/icons/tabler_submarine.svg",
    target: TeamAlarmScreen(),
  ),
];
