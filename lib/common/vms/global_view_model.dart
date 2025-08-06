import 'dart:async';

import 'package:alarmi/common/model/global_view_state.dart';
import 'package:alarmi/utils/date_utils.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GlobalViewModel extends Notifier<GlobalViewState> {
  Timer? _themeCheckTimer;

  @override
  GlobalViewState build() {
    state = GlobalViewState(isEvening: isEvening());
    _startThemeCheckTimer();

    ref.onDispose(() {
      _themeCheckTimer?.cancel();
    });

    return state;
  }

  void setIsEvening(bool value) {
    state = state.copyWith(isEvening: value);
  }

  void _startThemeCheckTimer() {
    _themeCheckTimer?.cancel();
    _themeCheckTimer = Timer.periodic(1.minutes, (timer) {
      final bool currentIsEvening = isEvening();

      if (state.isEvening != currentIsEvening) {
        setIsEvening(currentIsEvening);
      }
    });
  }
}

final globalViewProvider = NotifierProvider<GlobalViewModel, GlobalViewState>(
  () => GlobalViewModel(),
);
