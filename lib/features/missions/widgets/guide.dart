import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/features/missions/vms/shaking_clams_view_model.dart';
import 'package:alarmi/utils/lottie_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Guide extends ConsumerStatefulWidget {
  const Guide({super.key});

  @override
  ConsumerState<Guide> createState() => _GuideState();
}

class _GuideState extends ConsumerState<Guide>
    with SingleTickerProviderStateMixin {
  late final AnimationController lottieController;

  @override
  void initState() {
    lottieController = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shakingClamsState = ref.watch(shakingClamsViewProvider);
    final shakingClamsNotifier = ref.read(shakingClamsViewProvider.notifier);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '핸드폰을 있는 힘껏',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          '흔들어 주세요!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        Gaps.v8,
        // 로티 이미지 사용
        buildLottieWidget(
          assetPath: 'assets/lotties/mission_shaking_etc_phone_2x.json',
          controller: lottieController,
          repeat: true,
        ),
        // riv 이미지 사용
        // Expanded(
        //   child: RiveAnimation.asset(
        //     'assets/rives/mission_shaking_etc_phone_2x.riv',
        //     fit: BoxFit.cover,
        //   ),
        // ),
        Gaps.v8,
        ElevatedButton(
          onPressed: () {
            shakingClamsNotifier.setIsStart(true);
            shakingClamsNotifier.startCountdown();
          },
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
                '바로 시작 (${shakingClamsState.popCountdown}s)',
                style: TextStyle(
                  fontSize: Sizes.size18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
