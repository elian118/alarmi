import 'package:alarmi/common/model/bottom_section_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomSectionViewModel extends Notifier<BottomSectionState> {
  @override
  BottomSectionState build() {
    return BottomSectionState();
  }

  void initStates() {
    state = BottomSectionState();
  }

  void setOpenCatMenus(bool value) {
    state = state.copyWith(
      isOpenCatMenus: value,
      isOpenCreateAlarmMenus: value ? false : state.isOpenCreateAlarmMenus,
    );
  }

  void toggleGenAlarms() {
    state = state.copyWith(isOpenGenAlarms: !state.isOpenGenAlarms);
  }

  void setOpenCreateAlarmMenus(bool value) {
    state = state.copyWith(
      isOpenCreateAlarmMenus: value,
      isOpenCatMenus: value ? false : state.isOpenCatMenus,
    );
    // 알람 생성 메뉴가 열리면 카테고리 메뉴는 닫힘
    state = state.copyWith(isOpenCreateAlarmMenus: value);
  }

  void toggleCreateAlarmAndCloseCatMenus() {
    state = state.copyWith(
      isOpenCreateAlarmMenus: !state.isOpenCreateAlarmMenus,
      isOpenCatMenus: false, // 항상 닫음
    );
  }

  void toggleCatMenusAndCloseCreateAlarmMenus() {
    state = state.copyWith(
      isOpenCatMenus: !state.isOpenCatMenus,
      isOpenCreateAlarmMenus: false, // 항상 닫음
    );
  }
}

final bottomSectionProvider =
    NotifierProvider<BottomSectionViewModel, BottomSectionState>(
      () => BottomSectionViewModel(),
    );
