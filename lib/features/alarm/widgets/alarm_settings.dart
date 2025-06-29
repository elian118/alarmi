import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/common/consts/raw_data/weekdays.dart';
import 'package:alarmi/common/consts/sizes.dart';
import 'package:flutter/material.dart';

class AlarmSettings extends StatefulWidget {
  const AlarmSettings({super.key});

  @override
  State<AlarmSettings> createState() => _AlarmSettingsState();
}

class _AlarmSettingsState extends State<AlarmSettings> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '요일 설정',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Gaps.h56,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Checkbox(value: true, onChanged: (value) {}),
                    Text(
                      '매일',
                      style: TextStyle(
                        fontSize: Sizes.size16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  // dense: true,
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ...weekdays.map(
                    (day) => SizedBox(
                      width: 38,
                      height: 38,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(day),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blueAccent, // 버튼 배경색
                          foregroundColor: Colors.white, // 텍스트 색상
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.zero, // 내부 패딩 제거
                          minimumSize: Size.zero,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gaps.v10,
            Divider(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '알림음',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () {}, child: Text('없음')),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ],
            ),
            Divider(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '진동',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () {}, child: Text('없음')),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ],
            ),
            Divider(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '기상 미션',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Switch(value: true, onChanged: (value) {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
