import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/common/consts/raw_data/haptic_patterns.dart';
import 'package:alarmi/features/alarm/widgets/vibrate.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class Vibrates extends StatefulWidget {
  const Vibrates({super.key});

  @override
  State<Vibrates> createState() => _VibratesState();
}

class _VibratesState extends State<Vibrates> with TickerProviderStateMixin {
  bool _canVibrate = false; // 기기 진동 지원 여부
  String? _currentlyPlayingPresetId;

  // 기기의 진동 지원 여부 및 커스텀 패턴 지원 여부 확인
  Future<void> _checkVibrationCapabilities() async {
    _canVibrate = (await Vibration.hasVibrator());
    setState(() {}); // 상태 업데이트하여 UI에 반영 (예: 진동 지원하지 않을 때 경고 메시지)
  }

  void onVibrationStateChanged(String? id) {
    setState(() {
      _currentlyPlayingPresetId = id;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkVibrationCapabilities();
  }

  @override
  Widget build(BuildContext context) {
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
