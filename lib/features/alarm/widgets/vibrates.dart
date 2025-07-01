import 'dart:async';

import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/common/consts/raw_data/haptic_patterns.dart';
import 'package:alarmi/features/alarm/widgets/vibrate.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class Vibrates extends StatefulWidget {
  final String? selectedVibrateId;
  final Function(String? patternId) onChangeCurrentPlayingPatternId;
  final Function(String? patternId) setToUpdateVibrateId;

  const Vibrates({
    super.key,
    this.selectedVibrateId,
    required this.onChangeCurrentPlayingPatternId,
    required this.setToUpdateVibrateId,
  });

  @override
  State<Vibrates> createState() => _VibratesState();
}

class _VibratesState extends State<Vibrates> with TickerProviderStateMixin {
  bool _canVibrate = false; // 기기 진동 지원 여부
  String? _currentlyPlayingPresetId;
  bool _isVibrationChecked = false;

  // 기기의 진동 지원 여부 및 커스텀 패턴 지원 여부 확인
  Future<void> _checkVibrationCapabilities() async {
    _canVibrate = (await Vibration.hasVibrator());
    setState(() {
      _isVibrationChecked = true;
      _currentlyPlayingPresetId = widget.selectedVibrateId;
    });
  }

  void onVibrationStateChanged(String? patternId) {
    setState(() {
      _currentlyPlayingPresetId = patternId;
    });
    widget.setToUpdateVibrateId(patternId);
  }

  @override
  void initState() {
    _checkVibrationCapabilities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVibrationChecked) {
      return Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        spacing: 14,
        children: [
          Gaps.v12,
          ...hapticPatterns.map(
            (h) => Vibrate(
              title: h.name,
              preset: h.preset,
              canVibrate: _canVibrate,
              currentlyPlayingPresetId: _currentlyPlayingPresetId,
              onVibrationStateChanged: onVibrationStateChanged,
              presetId: h.id,
            ),
          ),
          Gaps.v12,
        ],
      ),
    );
  }
}
