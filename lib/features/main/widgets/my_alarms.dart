import 'package:alarmi/common/consts/raw_data/my_alarms.dart';
import 'package:alarmi/features/alarm/models/alarm_params.dart';
import 'package:alarmi/features/main/widgets/alarm.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MyAlarms extends StatelessWidget {
  const MyAlarms({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getWinHeight(context) * 0.28,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ...myAlarms
                .map(
                  (a) => Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Alarm(
                      alarmId: a['id'],
                      params: AlarmParams.fromJson(a),
                    ),
                  ),
                )
                .toList()
                .animate(interval: 0.3.seconds, delay: 0.3.seconds)
                .slideX(
                  begin: -1,
                  end: 0,
                  duration: 0.6.seconds,
                  curve: Curves.easeInOut,
                ),
          ],
        ),
      ),
    );
  }
}
