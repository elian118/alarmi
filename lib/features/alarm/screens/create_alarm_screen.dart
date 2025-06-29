import 'package:flutter/material.dart';

class CreateAlarmScreen extends StatelessWidget {
  static const String routeName = 'createAlarm';
  static const String routeURL = '/create-alarm';
  final String type;

  const CreateAlarmScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${type == 'my' ? '내' : '팀'} 알림 설정')),
      body: Column(children: []),
    );
  }
}
