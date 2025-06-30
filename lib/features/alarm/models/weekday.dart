class Weekday {
  final String name;
  bool isSelected;

  Weekday({required this.name, required this.isSelected});

  Weekday copyWith({String? name, bool? isSelected}) {
    return Weekday(
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
