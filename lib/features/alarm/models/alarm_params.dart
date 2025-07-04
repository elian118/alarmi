import 'dart:convert';

class AlarmParams {
  final String type;
  final String register;
  final List<int> alarmKeys;
  final String alarmTime;
  final int isWakeUpMission; // 0 false / 1 true

  AlarmParams({
    required this.type,
    required this.register,
    required this.alarmKeys,
    required this.alarmTime,
    required this.isWakeUpMission,
  });

  AlarmParams.fromJson(Map<String, dynamic> json)
    : type = json['type'],
      register = json['register'],
      alarmKeys =
          json['alarmKeys'] != null
              ? List<int>.from(jsonDecode(json['alarmKeys'] as String))
              : [],
      alarmTime = json['alarmTime'],
      isWakeUpMission = json['isWakeUpMission'];

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "register": register,
      "alarmKeys": jsonEncode(alarmKeys),
      "alarmTime": alarmTime,
      "isWakeUpMission": isWakeUpMission,
    };
  }

  @override
  String toString() {
    return 'AlarmParams(type: $type, register: $register, alarmKeys: $alarmKeys, alarmTime: $alarmTime)';
  }
}
