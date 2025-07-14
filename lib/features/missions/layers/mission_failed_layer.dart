import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/features/missions/vms/shaking_clams_view_model.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MissionFailedLayer extends ConsumerWidget {
  const MissionFailedLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shakingClamsNotifier = ref.read(shakingClamsViewProvider.notifier);

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            width: getWinWidth(context),
            height: getWinHeight(context),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 45),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: getWinHeight(context) * 0.33,
                  alignment: Alignment.center,
                  child: Text(
                    '실패했어요.\n다시 한 번 도전해 보세요!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Image.asset(
                  'assets/images/characters/mission_failed.png',
                  width: 206,
                  height: 206,
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () => shakingClamsNotifier.retryMission(),
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
                        '다시 시도',
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
      ],
    );
  }
}
