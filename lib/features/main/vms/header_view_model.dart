import 'package:flutter_riverpod/flutter_riverpod.dart';

class HeaderViewModel extends Notifier<bool> {
  @override
  bool build() {
    return true;
  }

  void toggleFold() {
    state = !state;
  }
}

final headerStateProvider = NotifierProvider<HeaderViewModel, bool>(
  () => HeaderViewModel(),
);
