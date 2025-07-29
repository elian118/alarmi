import 'package:alarmi/common/consts/raw_data/bg_gradation_color_set.dart';
import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/features/alarm/widgets/vibrates.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VibrateSettingsDialog extends StatefulWidget {
  static const String routeName = 'vibrate_settings_dialog';
  static const String routeURL = '/vibrate_settings';

  final bool isActivatedVibrate;
  final Function() toggleActivatedVibrate;
  final String? selectedVibrateId;
  final Function(String? patternId) onSaveVibrateSettings;

  const VibrateSettingsDialog({
    super.key,
    required this.isActivatedVibrate,
    required this.toggleActivatedVibrate,
    required this.onSaveVibrateSettings,
    this.selectedVibrateId,
  });

  @override
  State<VibrateSettingsDialog> createState() => _VibrateSettingsDialogState();
}

class _VibrateSettingsDialogState extends State<VibrateSettingsDialog> {
  late String? _selectedVibrateId = widget.selectedVibrateId;
  // late bool _isDialogActivatedVibrate = _selectedVibrateId != null;
  final bool _isDialogActivatedVibrate = true;
  String? _toUpdateVibrateId;

  // 최종 기획에서 삭제됨
  // void _onSwitchChanged(bool newValue) {
  //   setState(() {
  //     _isDialogActivatedVibrate = newValue;
  //   });
  //   // 부모 위젯 상태 업데이트
  //   widget.toggleActivatedVibrate();
  //   // 플레이 상태 반영
  //   if (newValue == false) {
  //     onChangeCurrentPlayingPatternId(null);
  //     Vibration.cancel(); // 재생중인 모든 진동 취소
  //   }
  // }

  void setToUpdateVibrateId(String? patternId) {
    setState(() {
      _toUpdateVibrateId = patternId;
    });
  }

  void saveVibrate() {
    widget.onSaveVibrateSettings(_toUpdateVibrateId);
    Navigator.pop(context);
  }

  void onChangeCurrentPlayingPatternId(String? patternId) {
    setState(() {
      _selectedVibrateId = patternId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        context.pop();
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: bgGradationColorSet,
          ),
          // 일부 기기는 모서리가 각 져 있어 적용 시 보기 흉할 수 있음
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5), // 그림자 색상 및 투명도
              spreadRadius: 5, // 그림자가 얼마나 퍼질지 (음수이면 안쪽으로 들어감)
              blurRadius: 15, // 그림자 블러 강도
              offset: const Offset(0, 8), // 그림자 위치 (X, Y)
            ),
          ],
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: Icon(Icons.chevron_left, size: 24, color: Colors.white),
            ),
            title: Text(
              '진동',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              spacing: 12,
              children: [
                Expanded(
                  child: Vibrates(
                    selectedVibrateId: _selectedVibrateId,
                    onChangeCurrentPlayingPatternId:
                        onChangeCurrentPlayingPatternId,
                    setToUpdateVibrateId: setToUpdateVibrateId,
                    isDialogActivatedVibrate: _isDialogActivatedVibrate,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => saveVibrate(),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: Sizes.size14),
                    child: Center(
                      child: Text(
                        '선택하기',
                        style: TextStyle(
                          fontSize: Sizes.size18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
