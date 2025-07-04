class Weekday {
  final int id;
  final String name;
  bool isSelected;

  Weekday({required this.id, required this.name, required this.isSelected});

  Weekday copyWith({String? name, bool? isSelected}) {
    return Weekday(
      name: name ?? this.name,
      id: id,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
