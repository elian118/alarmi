import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/features/shaking_clams/vms/shaking_clams_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shake/shake.dart';

class ShakingShell extends ConsumerStatefulWidget {
  const ShakingShell({super.key});

  @override
  ConsumerState<ShakingShell> createState() => _ShakingShellState();
}

class _ShakingShellState extends ConsumerState<ShakingShell> {
  late final ShakingClamsViewModel shakingClamsNotifier;
  late ShakeDetector shake;
  AnimationController? _shakeAnimateController;

  @override
  void initState() {
    shakingClamsNotifier = ref.read(shakingClamsViewProvider.notifier);
    super.initState();
  }

  @override
  void dispose() {
    shake.stopListening();
    _shakeAnimateController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shakingClamsState = ref.watch(shakingClamsViewProvider);
    bool isPlayingMission =
        shakingClamsState.showMission &&
        !shakingClamsState.isCompleted &&
        !shakingClamsState.isFailed;

    return Container(
      alignment: Alignment.center,
      child: SizedBox(
            width: 330,
            height: 360,
            child: Column(
              children: [
                !isPlayingMission ? Container() : Gaps.v48,
                Image.asset(
                      'assets/images/backgrounds/${shakingClamsState.openCount <= 80 ? 'seashell' : 'open_big_seashell'}.png',
                      fit: BoxFit.contain,
                      width: isPlayingMission ? 250 : 330,
                      height: isPlayingMission ? 250 : 330,
                    )
                    .animate(
                      autoPlay: false,
                      controller: _shakeAnimateController,
                    )
                    .shake(
                      duration: 150.ms,
                      hz: 10,
                      offset: Offset(5, 0),
                      curve: Curves.elasticOut,
                    ),
                isPlayingMission ? Container() : Gaps.v24,
              ],
            ),
          )
          .animate(target: shakingClamsState.isStart ? 1 : 0)
          .fadeIn(begin: 0, duration: 0.5.seconds, curve: Curves.easeInOut),
    );
  }
}
