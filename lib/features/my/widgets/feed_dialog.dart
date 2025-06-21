import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/common/consts/raw_data/fishes.dart';
import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/common/widgets/cst_divider.dart';
import 'package:alarmi/features/my/widgets/fish_tile.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/material.dart';

class FeedDialog extends StatefulWidget {
  const FeedDialog({super.key});

  @override
  State<FeedDialog> createState() => _FeedDialogState();
}

class _FeedDialogState extends State<FeedDialog> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
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
                '에너지 25%',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Gaps.v8,
          LinearProgressIndicator(
            color: colorScheme.primary,
            backgroundColor: Colors.grey,
            value: 0.25,
            borderRadius: BorderRadius.circular(20),
            minHeight: 15,
          ),
          Gaps.v16,
          Container(
            height: size.height * 0.57,
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 14,
                runSpacing: 14,
                children: [
                  ...[
                    ...fishes,
                    ...fishes,
                    ...fishes,
                  ].map((fish) => FishTile(fish: fish)),
                ],
              ),
            ),
          ),
          Gaps.v8,
          ElevatedButton(
            onPressed: () {},
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
