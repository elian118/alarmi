import 'package:alarmi/common/widgets/cst_rounded_elevated_btn.dart';
import 'package:alarmi/common/widgets/cst_text_field.dart';
import 'package:alarmi/features/onboarding/vms/onboard_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NamingLayer extends ConsumerWidget {
  const NamingLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardState = ref.watch(onboardViewProvider);
    final onboardNotifier = ref.read(onboardViewProvider.notifier);

    return onboardState.stage == 3
        ? Stack(
          children: [
            Positioned.fill(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black87.withValues(alpha: 0.2),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CstTextField(
                    hintText: '눌러서 이름 입력하기',
                    onChanged: (value) => onboardNotifier.setName(value),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              child: CstRoundedElevatedBtn(
                label: '완료',
                height: 58,
                onPressed:
                    onboardState.name.length > 0
                        ? () => onboardNotifier.setStage(onboardState.stage + 1)
                        : null,
              ),
            ),
          ],
        )
        : Container();
  }
}
