import 'package:alarmi/common/widgets/cst_rounded_slider.dart';
import 'package:alarmi/features/shaking_clams/vms/shaking_clams_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shake/shake.dart';

class OpenProgress extends ConsumerStatefulWidget {
  const OpenProgress({super.key});

  @override
  ConsumerState<OpenProgress> createState() => _OpenProgressState();
}

class _OpenProgressState extends ConsumerState<OpenProgress> {
  late final shakingClamsNotifier;
  late ShakeDetector shake;
  late final ValueNotifier<double> _sliderProgressNotifier;

  @override
  void initState() {
    shakingClamsNotifier = ref.read(shakingClamsViewProvider.notifier);
    shake = ShakeDetector.waitForStart(
      onPhoneShake: (event) => _incrementCounter(),
    );
    shake.startListening();
    _sliderProgressNotifier = ValueNotifier(
      ref.read(shakingClamsViewProvider).openCount,
      // 5.0,
    );

    super.initState();
  }

  void _incrementCounter() {
    final currentShakingClamsState = ref.read(shakingClamsViewProvider);

    shakingClamsNotifier.setOpenCount(
      currentShakingClamsState.openCount + 0.01,
    );
  }

  @override
  void dispose() {
    shake.stopListening();
    _sliderProgressNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shakingClamsState = ref.watch(shakingClamsViewProvider);
    final sliderValue = shakingClamsState.openCount;

    // 값 동기화
    if (_sliderProgressNotifier.value != sliderValue) {
      _sliderProgressNotifier.value = sliderValue;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          'assets/images/etc/close_seashell.png',
          width: 46,
          height: 46,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CstRoundedSlider(progress: _sliderProgressNotifier),
          ),
        ),
        Image.asset(
          'assets/images/etc/open_seashell.png',
          width: 58,
          height: 58,
        ),
      ],
    );
  }
}
