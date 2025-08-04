import 'package:alarmi/features/main/models/main_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainViewModel extends Notifier<MainState> {
  @override
  MainState build() {
    return MainState();
  }

  void setCurrentPage(int value) {
    state = state.copyWith(currentPageIndex: value);
  }

  void setDragStartY(double value) {
    state = state.copyWith(dragStartY: value);
  }

  void setAlarmsTopOffset(double value) {
    state = state.copyWith(alarmsTopOffset: value);
  }

  void setHasNoAlarms(bool value) {
    state = state.copyWith(hasNoAlarms: value);
  }
}

final mainViewProvider = NotifierProvider<MainViewModel, MainState>(
  () => MainViewModel(),
);
