import 'dart:ui';

import 'package:alarmi/common/consts/gaps.dart';
import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/features/main/screens/main_screen.dart';
import 'package:alarmi/features/onboarding/vms/onboard_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ConfirmLayer extends ConsumerWidget {
  const ConfirmLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardState = ref.watch(onboardViewProvider);
    final onboardNotifier = ref.read(onboardViewProvider.notifier);

    return Positioned.fill(
      child: IgnorePointer(
        ignoring: onboardState.hasConfirmed,
        child: Container(
              color: Colors.black87.withValues(alpha: 0.4),
              child: Center(
                child: Stack(
                  children: [
                    Container(
                      width: 295,
                      height: 239,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        child: Container(color: Colors.transparent),
                      ),
                    ),

                    Container(
                      width: 295,
                      height: 239,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.24),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '고양이의 이름을 지어주세요',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '고양이를 생성해야 정보를\n기록하고 탐험을 시작할 수\n있어요.',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed:
                                      () => context.go(
                                        '${MainScreen.routeURL}/null',
                                      ),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.white.withValues(
                                      alpha: 0.24,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: Sizes.size16,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '다음에',
                                        style: TextStyle(
                                          fontSize: Sizes.size16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Gaps.h12,
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    onboardNotifier.setHasConfirmed(true);
                                    onboardNotifier.initStates(
                                      hasConfirmed: true,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: Sizes.size16,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '이어하기',
                                        style: TextStyle(
                                          fontSize: Sizes.size16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
            .animate(target: onboardState.hasConfirmed ? 1 : 0)
            .fadeOut(begin: 1, duration: 0.4.seconds, curve: Curves.easeInOut),
      ),
    );
  }
}
