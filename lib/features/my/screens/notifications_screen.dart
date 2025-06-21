import 'package:alarmi/features/my/widgets/noti_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../common/consts/raw_data/notifications.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('알림')),
      // Todo - 실데이터 적용 시 최적화를 위해 AnimatedList + AnimatedListState 사용할 것
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...[
                  ...notifications,
                  ...notifications,
                  ...notifications,
                  ...notifications,
                ]
                .map((noti) => NotiTile(noti: noti))
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
