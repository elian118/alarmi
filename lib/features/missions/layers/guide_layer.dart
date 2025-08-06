import 'package:alarmi/features/missions/vms/shaking_clams_view_model.dart';
import 'package:alarmi/features/missions/widgets/countdown_painter.dart';
import 'package:alarmi/features/missions/widgets/guide.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GuideLayer extends ConsumerStatefulWidget {
  const GuideLayer({super.key});

  @override
  ConsumerState<GuideLayer> createState() => _GuideLayerState();
}

class _GuideLayerState extends ConsumerState<GuideLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progressAnimationController =
      AnimationController(vsync: this, duration: 3.seconds);

  late final CurvedAnimation _curve = CurvedAnimation(
    parent: _progressAnimationController,
    curve: Curves.linear,
  );

  late final Animation<double> _countdownProgress = Tween(
    begin: 1.0,
    end: 0.0,
  ).animate(_curve);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shakingClamsState = ref.watch(shakingClamsViewProvider);

    if (shakingClamsState.isStart &&
        shakingClamsState.countdownProgress == 1 &&
        !_progressAnimationController.isAnimating) {
      _progressAnimationController.forward(from: 0.0);
    } else if (!shakingClamsState.isStart &&
        _progressAnimationController.isCompleted) {
      _progressAnimationController.reset();
    }

    return Container(
      alignment: Alignment.center,
      child:
          shakingClamsState.isStart
              ? Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    child: SizedBox(
                      width: 152,
                      height: 152,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: AnimatedBuilder(
                              animation: _progressAnimationController,
                              builder:
                                  (context, child) => CustomPaint(
                                    painter: CountdownPainter(
                                      countdownProgress:
                                          _countdownProgress.value,
                                    ),
                                  ),
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                shakingClamsState.countdown.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 72,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
              : Container(
                alignment: Alignment.topCenter,
                width: 295,
                height: getWinHeight(context) * 0.45,
                child: Container(
                  width: 295,
                  height: 330,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Guide(),
                ),
              ).animate().scale(duration: 0.5.seconds, curve: Curves.easeInOut),
    );
  }
}
