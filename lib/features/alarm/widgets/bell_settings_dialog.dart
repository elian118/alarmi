import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/features/alarm/widgets/bell_tabs.dart';
import 'package:alarmi/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BellSettingsDialog extends StatefulWidget {
  static const String routeName = 'bell_settings_dialog';
  static const String routeURL = '/bell_settings';

  final Function(String? bellId, double volmue) onSaveBellSettings;
  final String? selectedBellId;

  const BellSettingsDialog({
    super.key,
    required this.onSaveBellSettings,
    this.selectedBellId,
  });

  @override
  State<BellSettingsDialog> createState() => _BellSettingsDialogState();
}

class _BellSettingsDialogState extends State<BellSettingsDialog> {
  late String? _selectedBellId = widget.selectedBellId;
  double _volume = 0.8;

  void onChangeVolume(double value) {
    setState(() {
      _volume = value;
    });
  }

  void saveAlarm() {
    widget.onSaveBellSettings(_selectedBellId, _volume);
    Navigator.pop(context); // 닫기
  }

  void onChangeCurrentPlyingBellId(String? bellId) {
    setState(() {
      _selectedBellId = bellId;
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
            colors: [
              Color(isEvening() ? 0xFF101841 : 0xFF2b6fa5),
              Color(0xFF02365a),
            ],
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
              '알람음',
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
                Row(
                  children: [
                    IconButton(
                      onPressed: () => onChangeVolume(_volume == 0 ? 0.8 : 0.0),
                      icon: Icon(
                        _volume > 0 ? Icons.volume_down : Icons.volume_mute,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbColor: Colors.white,
                          thumbShape: RoundSliderThumbShape(
                            enabledThumbRadius: 13.0,
                          ),
                          inactiveTrackColor: Colors.grey.shade600,
                          trackHeight: 4,
                        ),
                        child: Slider(
                          value: _volume,
                          onChanged: onChangeVolume,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => onChangeVolume(1),
                      icon: Icon(
                        Icons.volume_up,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: BellTabs(
                    selectedBellId: _selectedBellId,
                    onChangeCurrentPlyingBellId: onChangeCurrentPlyingBellId,
                    volume: _volume,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => saveAlarm(),
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
