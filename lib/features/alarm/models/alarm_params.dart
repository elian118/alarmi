class AlarmParams {
  final String type;
  final String register;
  final List<int> alarmKeys;
  final String alarmTime;

  AlarmParams({
    required this.type,
    required this.register,
    required this.alarmKeys,
    required this.alarmTime,
  });

  AlarmParams.fromJson(Map<String, dynamic> json)
    : type = json['type'],
      register = json['register'],
      alarmKeys = json['alarmKeys'],
      alarmTime = json['alarmTime'];

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "register": register,
      "alarmKeys": alarmKeys,
      "alarmTime": alarmTime,
    };
  }

  @override
  String toString() {
    return 'AlarmParams(type: $type, register: $register, alarmKeys: $alarmKeys, alarmTime: $alarmTime)';
  }
}
