class GlobalViewState {
  final bool isEvening;

  GlobalViewState({this.isEvening = false});

  GlobalViewState copyWith({bool? isEvening}) {
    return GlobalViewState(isEvening: isEvening ?? this.isEvening);
  }
}
