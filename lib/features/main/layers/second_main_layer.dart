import 'package:alarmi/common/consts/raw_data/bg_gradation_color_set.dart';
import 'package:alarmi/common/vms/global_view_model.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SecondMainLayer extends ConsumerWidget {
  const SecondMainLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEvening = ref.watch(
      globalViewProvider.select((state) => state.isEvening),
    );

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors:
                    isEvening
                        ? nightBgGradationColorSet
                        : dayBgGradationColorSet,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: getWinHeight(context),
            color: Colors.transparent,
            child: Container(),
          ),
        ),
      ],
    );
  }
}
