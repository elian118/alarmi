import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/features/alarm/widgets/alarm_date_picker.dart';
import 'package:alarmi/features/alarm/widgets/alarm_settings.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(Sizes.size18),
        child: Column(
          children: [
            AlarmDatePicker(),
            AlarmSettings(),
            Spacer(),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: Sizes.size14),
                child: Center(
                  child: Text(
                    '저장',
                    style: TextStyle(
                      fontSize: Sizes.size18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            Gaps.v32,
          ],
        ),
      ),
    );
  }
}
