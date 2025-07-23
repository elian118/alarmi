import 'dart:async';

import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/common/consts/raw_data/haptic_patterns.dart';
import 'package:alarmi/common/widgets/cst_part_loading.dart';
import 'package:alarmi/features/alarm/widgets/vibrate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';

class Vibrates extends StatefulWidget {
  final String? selectedVibrateId;
  final Function(String? patternId) onChangeCurrentPlayingPatternId;
  final Function(String? patternId) setToUpdateVibrateId;
  final bool isDialogActivatedVibrate;

  const Vibrates({
    super.key,
    this.selectedVibrateId,
    required this.onChangeCurrentPlayingPatternId,
    required this.setToUpdateVibrateId,
    required this.isDialogActivatedVibrate,
  });

  @override
  State<Vibrates> createState() => _VibratesState();
}

class _VibratesState extends State<Vibrates> with TickerProviderStateMixin {
  bool _canVibrate = false; // 기기 진동 지원 여부
  String? _currentlyPlayingPresetId; // 내부에서 상태 변경 시 리랜더링 위해 사용하는 별도 변수
  bool _isVibrationChecked = false; // 기기 진동 지원 여부 검사 완료 여부

  // 기기의 진동 지원 여부 및 커스텀 패턴 지원 여부 확인
  Future<void> _checkVibrationCapabilities() async {
    _canVibrate = (await Vibration.hasVibrator());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isVibrationChecked = true;
          _currentlyPlayingPresetId = widget.selectedVibrateId;
        });
      }
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
      return CstPartLoading();
    }

    return SingleChildScrollView(
          child: Column(
            spacing: 14,
            children: [
              Gaps.v12,
              ...hapticPatterns.map(
                (h) => Vibrate(
                  key: UniqueKey(),
                  title: h.name,
                  preset: h.preset!,
                  canVibrate: _canVibrate,
                  currentlyPlayingPresetId: _currentlyPlayingPresetId,
                  onVibrationStateChanged: onVibrationStateChanged,
                  isDialogActivatedVibrate: widget.isDialogActivatedVibrate,
                  presetId: h.id,
                ),
              ),
              Gaps.v12,
            ],
          ),
        )
        .animate(target: widget.isDialogActivatedVibrate ? 1 : 0)
        .fade(begin: 0, end: 1, curve: Curves.easeInOut, duration: 0.6.seconds);
  }
}
