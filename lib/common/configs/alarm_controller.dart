// import 'dart:io';
// import 'dart:ui';
//
// import 'package:alarm/model/alarm_settings.dart';
// import 'package:alarm/model/notification_settings.dart';
// import 'package:alarm/model/volume_settings.dart';
//
// class AlarmController {
//   final testAlarmSettings = AlarmSettings(
//     id: 42,
//     dateTime: DateTime.now(),
//     assetAudioPath: 'assets/alarm.mp3',
//     loopAudio: true,
//     vibrate: true,
//     warningNotificationOnKill: Platform.isIOS,
//     androidFullScreenIntent: true,
//     volumeSettings: VolumeSettings.fade(
//       volume: 0.8,
//       fadeDuration: Duration(seconds: 5),
//       volumeEnforced: true,
//     ),
//     notificationSettings: const NotificationSettings(
//       title: '기상 시간입니다!',
//       body: '상쾌한 아침을 시작하세요.',
//       stopButton: '알람 끄기',
//       icon: 'notification_icon',
//       iconColor: Color(0xff862778),
//     ),
//   );
//
//   static AlarmSettings setAlarmSettings(
//     int id,
//     DateTime dt,
//     String soundAsset,
//     bool vibrate,
//   ) {
//     return AlarmSettings(
//       id: id,
//       dateTime: dt,
//       assetAudioPath: soundAsset,
//       loopAudio: true,
//       vibrate: vibrate,
//       warningNotificationOnKill: Platform.isIOS,
//       androidFullScreenIntent: true,
//       volumeSettings: VolumeSettings.fade(
//         volume: 0.8,
//         fadeDuration: Duration(seconds: 5),
//         volumeEnforced: true,
//       ),
//       notificationSettings: const NotificationSettings(
//         title: '기상 시간입니다!',
//         body: '상쾌한 아침을 시작하세요.',
//         stopButton: '알람 끄기',
//         icon: 'notification_icon',
//         iconColor: Color(0xff862778),
//       ),
//     );
//   }
// }
