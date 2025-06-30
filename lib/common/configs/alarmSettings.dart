import 'dart:io';
import 'dart:ui';

import 'package:alarm/model/alarm_settings.dart';
import 'package:alarm/model/notification_settings.dart';
import 'package:alarm/model/volume_settings.dart';

AlarmSettings setAlarmSettings(DateTime dt, double volume, String path) {
  return AlarmSettings(
    id: 42,
    dateTime: dt,
    assetAudioPath: path,
    loopAudio: true,
    vibrate: true,
    warningNotificationOnKill: Platform.isIOS,
    androidFullScreenIntent: true,
    volumeSettings: VolumeSettings.fade(
      volume: volume,
      fadeDuration: Duration(seconds: 5),
      volumeEnforced: true,
    ),
    notificationSettings: const NotificationSettings(
      title: '일어나세요!',
      body: '테스트 알람이 재생중입니다~',
      stopButton: '알람 중지',
      icon: 'notification_icon',
      iconColor: Color(0xff862778),
    ),
  );
}
