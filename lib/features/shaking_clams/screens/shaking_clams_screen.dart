import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/features/shaking_clams/layers/guide_layer.dart';
import 'package:alarmi/features/shaking_clams/layers/mission_completed_layer.dart';
import 'package:alarmi/features/shaking_clams/layers/mission_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../layers/mission_failed_layer.dart';
import '../vms/shaking_clams_view_model.dart';

class ShakingClamsScreen extends ConsumerWidget {
  static const String routeName = 'shaking_clams';
  static const String routeURL = '/shaking_clams';

  const ShakingClamsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shakingClamsState = ref.watch(shakingClamsViewProvider);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgrounds/mission_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              alignment: Alignment.center,
              child: SizedBox(
                    width: 330,
                    height: 360,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/backgrounds/seashell.png',
                          fit: BoxFit.contain,
                        ),
                        Gaps.v24,
                      ],
                    ),
                  )
                  .animate(target: shakingClamsState.isStart ? 1 : 0)
                  .fadeIn(
                    begin: 0,
                    duration: 0.5.seconds,
                    curve: Curves.easeInOut,
                  ),
            ),
          ),
          Positioned.fill(
                child: Container(color: Colors.black.withValues(alpha: 0.6)),
              )
              .animate(
                target:
                    shakingClamsState.showMission &&
                            !shakingClamsState.isCompleted &&
                            !shakingClamsState.isFailed
                        ? 1
                        : 0,
              )
              .fadeOut(begin: 1.0),
          IgnorePointer(
            child: MissionLayer()
                .animate(
                  target:
                      shakingClamsState.showMission &&
                              !shakingClamsState.isCompleted &&
                              !shakingClamsState.isFailed
                          ? 1
                          : 0,
                )
                .fadeIn(begin: 0.0),
          ),
          IgnorePointer(
            ignoring:
                shakingClamsState.showMission &&
                !shakingClamsState.isCompleted &&
                !shakingClamsState.isFailed,
            child: MissionCompletedLayer()
                .animate(target: shakingClamsState.isCompleted ? 1 : 0)
                .fadeIn(begin: 0.0),
          ),
          IgnorePointer(
            ignoring:
                shakingClamsState.showMission &&
                !shakingClamsState.isCompleted &&
                !shakingClamsState.isFailed,
            child: MissionFailedLayer()
                .animate(target: shakingClamsState.isFailed ? 1 : 0)
                .fadeIn(begin: 0.0),
          ),
          IgnorePointer(
            ignoring: shakingClamsState.showMission,
            child: GuideLayer()
                .animate(
                  target:
                      shakingClamsState.showMission ||
                              (!shakingClamsState.showMission &&
                                  (shakingClamsState.isCompleted ||
                                      shakingClamsState.isFailed))
                          ? 1
                          : 0,
                )
                .fadeOut(begin: 1.0),
          ),
        ],
      ),
    );
  }
}
