import 'dart:async';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration/vibration_presets.dart';

class VibrateUtils {
  static Timer? playRepeatVibration(VibrationPreset preset) {
    return Timer.periodic(1.seconds, (timer) {
      Vibration.vibrate(preset: preset, duration: 1000);
    });
  }

  static void stopRepeatVibration(Timer? vibrationRepeatTimer) {
    Vibration.cancel();
    vibrationRepeatTimer?.cancel();
  }
}
