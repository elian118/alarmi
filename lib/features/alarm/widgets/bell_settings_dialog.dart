import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/features/alarm/widgets/bell_tabs.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/material.dart';

class BellSettingsDialog extends StatefulWidget {
  const BellSettingsDialog({super.key});

  @override
  State<BellSettingsDialog> createState() => _BellSettingsDialogState();
}

class _BellSettingsDialogState extends State<BellSettingsDialog> {
  double _volume = 0.8;

  void onChangeVolume(double value) {
    setState(() {
      _volume = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(22),
      height: getWinHeight(context) * 0.87,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      width: getWinWidth(context),
      child: Column(
        spacing: 12,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '알람음',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => onChangeVolume(_volume == 0 ? 0.8 : 0.0),
                icon: Icon(
                  _volume > 0 ? Icons.volume_up : Icons.volume_off,
                  color: Colors.white,
                ),
              ),

              Flexible(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbColor: Colors.white,
                    trackHeight: 4,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 13.0),
                  ),
                  child: Slider(value: _volume, onChanged: onChangeVolume),
                ),
              ),
            ],
          ),
          Expanded(child: BellTabs(volume: _volume)),
          ElevatedButton(
            onPressed: () {},
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
                  '완료',
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
    );
  }
}
