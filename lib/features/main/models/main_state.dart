class MainState {
  final double dragStartY; // 드래그 시작 시 Y 좌표
  final double alarmsTopOffset;
  final int currentPageIndex;
  final bool hasNoAlarms;

  MainState({
    this.dragStartY = 0.0,
    this.alarmsTopOffset = 0.0,
    this.currentPageIndex = 0,
    this.hasNoAlarms = false,
  });

  MainState copyWith({
    double? dragStartY,
    double? alarmsTopOffset,
    int? currentPageIndex,
    bool? hasNoAlarms,
  }) {
    return MainState(
      dragStartY: dragStartY ?? this.dragStartY,
      alarmsTopOffset: alarmsTopOffset ?? this.alarmsTopOffset,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      hasNoAlarms: hasNoAlarms ?? this.hasNoAlarms,
    );
  }
}
