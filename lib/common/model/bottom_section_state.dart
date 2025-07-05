class BottomSectionState {
  final bool isOpenCatMenus;
  final bool isOpenGenAlarms;
  final bool isOpenCreateAlarmMenus;

  BottomSectionState({
    this.isOpenCatMenus = false,
    this.isOpenGenAlarms = false,
    this.isOpenCreateAlarmMenus = false,
  });

  // 상태를 변경할 때 새로운 BottomSectionState 객체를 생성하기 위한 copyWith 메서드
  BottomSectionState copyWith({
    bool? isOpenCatMenus,
    bool? isOpenGenAlarms,
    bool? isOpenCreateAlarmMenus,
  }) {
    return BottomSectionState(
      isOpenCatMenus: isOpenCatMenus ?? this.isOpenCatMenus,
      isOpenGenAlarms: isOpenGenAlarms ?? this.isOpenGenAlarms,
      isOpenCreateAlarmMenus:
          isOpenCreateAlarmMenus ?? this.isOpenCreateAlarmMenus,
    );
  }
}
