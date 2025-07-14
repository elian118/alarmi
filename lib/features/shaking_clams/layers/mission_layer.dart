import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/features/shaking_clams/vms/shaking_clams_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MissionLayer extends ConsumerWidget {
  const MissionLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black87.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                  ),
                  child: Text(
                    shakingClamsState.message,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/etc/close_seashell.png',
                        width: 46,
                        height: 46,
                      ),
                      Slider(
                        // value: shakingClamsState.openCount,
                        value: 0.5,
                        activeColor: Colors.white,
                        inactiveColor: Colors.black87.withValues(alpha: 0.4),
                        onChanged: (value) {},
                      ),
                      Image.asset('assets/images/etc/open_seashell.png'),
                    ],
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
