import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/features/missions/vms/shaking_clams_view_model.dart';
import 'package:alarmi/features/missions/widgets/open_progress.dart';
import 'package:alarmi/features/missions/widgets/shaking_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MissionLayer extends ConsumerStatefulWidget {
  const MissionLayer({super.key});

  @override
  ConsumerState<MissionLayer> createState() => _MissionLayerState();
}

class _MissionLayerState extends ConsumerState<MissionLayer>
    with SingleTickerProviderStateMixin {
  late final shakingClamsNotifier;

  @override
  void initState() {
    shakingClamsNotifier = ref.read(shakingClamsViewProvider.notifier);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      shakingClamsNotifier.initStates();
    });
    super.initState();
  }

  @override
  void dispose() {
    shakingClamsNotifier.disposeViewModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shakingClamsState = ref.watch(shakingClamsViewProvider);
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 45),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Gaps.v96,
                if (shakingClamsState.showMission == true &&
                    !shakingClamsState.isCompleting)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black87.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                    ),
                    child: Text(
                      shakingClamsState.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                  ),
                  child: OpenProgress(),
                ),
              ],
            ),
          ),
        ),
        Positioned.fill(child: ShakingShell()),
      ],
    );
  }
}
