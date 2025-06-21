import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/common/consts/raw_data/fishes.dart';
import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/common/widgets/cst_divider.dart';
import 'package:alarmi/features/my/widgets/fish_tile.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/material.dart';

class FeedDialog extends StatefulWidget {
  final void Function() toggleLight;
  final void Function(String newMsg) setMessage;

  const FeedDialog({
    super.key,
    required this.toggleLight,
    required this.setMessage,
  });

  @override
  State<FeedDialog> createState() => _FeedDialogState();
}

class _FeedDialogState extends State<FeedDialog> {
  int total = 0;
  double userEnergy = 0.0;
  double totalExpectEnergy = 0.0;

  void onQuantityChanged(newTotal) {
    setState(() {
      total = newTotal > 0 ? newTotal : 0;
    });
  }

  void onExpectEnergyChange(newTotalExpectEnergy) {
    setState(() {
      totalExpectEnergy = newTotalExpectEnergy;
    });
  }

  @override
  void initState() {
    setState(() {
      userEnergy = 0.25;
      totalExpectEnergy = userEnergy;
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onFeed() {
    if (totalExpectEnergy != userEnergy) {
      int percent =
          (totalExpectEnergy * 100).toInt() > 100
              ? 100
              : (totalExpectEnergy * 100).toInt();
      widget.setMessage('에너지 $percent% 충전 완료!');
    }
    widget.toggleLight();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: getWinHeight(context) * 0.78,
      width: getWinWidth(context),
      padding: EdgeInsets.all(Sizes.size12),
      child: Column(
        children: [
          CstDivider(width: 120, thickness: 8),
          Gaps.v16,
          Row(
            children: [
              Icon(Icons.favorite),
              Gaps.h8,
              Text(
                '에너지 ${(userEnergy * 100).toInt()}%',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Gaps.v8,
          Stack(
            children: [
              // 예상 에너지바
              TweenAnimationBuilder(
                tween: Tween<double>(begin: userEnergy, end: totalExpectEnergy),
                duration: Duration(milliseconds: 500),
                builder:
                    (context, value, child) => LinearProgressIndicator(
                      color: Colors.blue.withValues(alpha: userEnergy),
                      backgroundColor:
                          value > 1
                              ? Colors.red.withValues(alpha: 0.4)
                              : Colors.grey.withValues(alpha: 0.4),
                      value: value,
                      borderRadius: BorderRadius.circular(20),
                      minHeight: 15,
                    ),
              ),
              // 에너지바
              LinearProgressIndicator(
                color: Colors.blue,
                backgroundColor: Colors.white.withValues(alpha: 0.0),
                value: 0.25,
                borderRadius: BorderRadius.circular(20),
                minHeight: 15,
              ),
            ],
          ),
          Gaps.v8,

          Gaps.v16,
          Container(
            height: size.height * 0.57,
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 14,
                runSpacing: 14,
                children: [
                  ...[...fishes, ...fishes, ...fishes].map(
                    (fish) => FishTile(
                      fish: fish,
                      userEnergy: userEnergy,
                      totalExpectEnergy: totalExpectEnergy,
                      onQuantityChanged: onQuantityChanged,
                      onExpectEnergyChange: onExpectEnergyChange,
                      total: total,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Gaps.v8,
          ElevatedButton(
            onPressed: total > 0 ? onFeed : null,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue.shade400,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Container(
              width: getWinWidth(context),
              padding: EdgeInsets.symmetric(vertical: Sizes.size18),
              child: Center(
                child: Text(
                  '밥 주기',
                  style: TextStyle(
                    fontSize: Sizes.size22,
                    fontWeight: FontWeight.w500,
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
