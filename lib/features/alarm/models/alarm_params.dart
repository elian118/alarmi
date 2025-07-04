import 'dart:convert';

class AlarmParams {
  final String type;
  final String register;
  final List<int> alarmKeys;
  final List<int> weekdays;
  final String alarmTime;
  final int isWakeUpMission; // 0 false / 1 true
  final String? bellId;
  final String? vibrateId;

  AlarmParams({
    required this.type,
    required this.register,
    required this.alarmKeys,
    required this.weekdays,
    required this.alarmTime,
    required this.isWakeUpMission,
    this.bellId,
    this.vibrateId,
  });

  AlarmParams.fromJson(Map<String, dynamic> json)
    : type = json['type'],
      register = json['register'],
      alarmKeys =
          json['alarmKeys'] != null
              ? List<int>.from(jsonDecode(json['alarmKeys'] as String))
              : [],
      weekdays =
          json['weekdays'] != null
              ? List<int>.from(jsonDecode(json['weekdays'] as String))
              : [],
      alarmTime = json['alarmTime'],
      isWakeUpMission = json['isWakeUpMission'],
      bellId = json['bellId'],
      vibrateId = json['vibrateId'];

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "register": register,
      "alarmKeys": jsonEncode(alarmKeys),
      "alarmTime": alarmTime,
      "isWakeUpMission": isWakeUpMission,
      "weekdays": jsonEncode(weekdays),
      "bellId": bellId,
      "vibrateId": vibrateId,
    };
  }

  @override
  String toString() {
    return 'AlarmParams(type: $type, register: $register, alarmKeys: $alarmKeys, weekdays: $weekdays, alarmTime: $alarmTime, isWakeUpMission: $isWakeUpMission, bellId: $bellId, vibrateId: $vibrateId)';
  }
}
