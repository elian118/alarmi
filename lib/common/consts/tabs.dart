import 'package:alarmi/common/model/tab.dart';
import 'package:alarmi/features/my/screens/my_alarm_screen.dart';
import 'package:alarmi/features/my/screens/new_alarm_screen.dart';
import 'package:alarmi/features/my/screens/team_alarm_screen.dart';

List<Tab> tabs = [
  Tab(
    key: "my",
    name: "개인 알람",
    iconAsset: "assets/images/bi_person-fill.svg",
    target: MyAlarmScreen(),
  ),
  Tab(
    key: "new",
    name: "알람 생성",
    iconAsset: "assets/images/tabler_alarm-plus-filled.svg",
    target: NewAlarmScreen(),
  ),
  Tab(
    key: "team",
    name: "팀 알람",
    iconAsset: "assets/images/tabler_submarine.svg",
    target: TeamAlarmScreen(),
  ),
];
