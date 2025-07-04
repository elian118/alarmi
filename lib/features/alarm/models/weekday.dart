class Weekday {
  final String name;
  final int dateTime;
  bool isSelected;

  Weekday({
    required this.name,
    required this.dateTime,
    required this.isSelected,
  });

  Weekday copyWith({String? name, bool? isSelected}) {
    return Weekday(
      name: name ?? this.name,
      dateTime: dateTime,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
