import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/features/alarm/widgets/create_alarm.dart';
import 'package:alarmi/utils/date_utils.dart';
import 'package:flutter/material.dart';

class CreateAlarmScreen extends StatelessWidget {
  static const String routeName = 'createAlarm';
  static const String routeURL = '/create-alarm';
  final String type;
  final String? alarmId;

  const CreateAlarmScreen({super.key, required this.type, this.alarmId});

  @override
  Widget build(BuildContext context) {
    bool isEvening = 'good_evening' == getHourCategory();

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '${type == 'my' ? '내' : '팀'} 알람 ${alarmId == 'null' ? '설정' : '수정'}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors:
                        !isEvening
                            ? [
                              Color(0xFF0d77a7),
                              Color(0xFF08588b),
                              Color(0xFF013569),
                            ]
                            : [Color(0xFF182a4e), Color(0xFF0f0923)],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(Sizes.size18),
                child: CreateAlarm(
                  type: 'my',
                  alarmId: alarmId == 'null' ? null : alarmId,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
