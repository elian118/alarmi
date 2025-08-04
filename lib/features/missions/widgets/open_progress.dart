import 'package:alarmi/common/widgets/cst_rounded_slider.dart';
import 'package:alarmi/features/missions/vms/shaking_clams_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OpenProgress extends ConsumerStatefulWidget {
  const OpenProgress({super.key});

  @override
  ConsumerState<OpenProgress> createState() => _OpenProgressState();
}

class _OpenProgressState extends ConsumerState<OpenProgress> {
  late final ValueNotifier<double> _sliderProgressNotifier;

  @override
  void initState() {
    _sliderProgressNotifier = ValueNotifier(
      ref.read(shakingClamsViewProvider).openCount,
    );

    super.initState();
  }

  @override
  void dispose() {
    _sliderProgressNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shakingClamsState = ref.watch(shakingClamsViewProvider);
    final sliderValue = shakingClamsState.openCount;

    // 값 동기화
    if (_sliderProgressNotifier.value != sliderValue) {
      _sliderProgressNotifier.value =
          sliderValue > 1
              ? 1
              : sliderValue < 0
              ? 0
              : sliderValue;
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
            child: CstRoundedSlider(
              progress: _sliderProgressNotifier,
              gradientColors: [
                const Color(0xFFFF6E9F),
                const Color(0xFFFF0056),
              ],
            ),
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
