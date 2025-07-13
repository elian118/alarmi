import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/features/shaking_clams/vms/shaking_clams_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Guide extends ConsumerWidget {
  const Guide({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        Image.asset('assets/images/etc/media_area.png', fit: BoxFit.cover),
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
                '바로 시작 (3s)',
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
