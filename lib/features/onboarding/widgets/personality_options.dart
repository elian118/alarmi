import 'package:alarmi/features/onboarding/constants/personalities.dart';
import 'package:alarmi/features/onboarding/vms/onboard_view_model.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonalityOptions extends ConsumerWidget {
  const PersonalityOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardState = ref.watch(onboardViewProvider);
    final onboardNotifier = ref.read(onboardViewProvider.notifier);

    final double itemSpacing = 8.0;
    final double itemWidth =
        (getWinWidth(context) - (20 * 2) - itemSpacing) / 2;
    final double itemHeight = itemWidth * 0.32;

    return onboardState.stage == 8
        ? Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: getWinWidth(context),
          height: 250,
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: itemWidth / itemHeight,
              crossAxisSpacing: itemSpacing,
              mainAxisSpacing: itemSpacing,
            ),
            itemBuilder: (context, index) {
              final String personality = personalities[index].label;
              bool isSelected =
                  onboardState.selectedPersonality?.label == personality;

              return GestureDetector(
                onTap: () => onboardNotifier.setPersonality(index),
                child: Container(
                      width: itemWidth,
                      height: itemHeight,
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        personality,
                        style: TextStyle(
                          color: isSelected ? Colors.black87 : Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                    .animate(target: isSelected ? 1 : 0)
                    .custom(
                      duration: 200.ms,
                      builder: (context, value, child) {
                        final Color animatedBackgroundColor =
                            Color.lerp(
                              Colors.white.withValues(alpha: 0.2),
                              Colors.white,
                              value,
                            )!;

                        final Color animatedTextColor =
                            Color.lerp(Colors.white, Colors.black87, value)!;

                        return Container(
                          decoration: BoxDecoration(
                            color: animatedBackgroundColor, // 애니메이션된 배경색
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            personality,
                            style: TextStyle(
                              color: animatedTextColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
              );
            },
          ),
        ).animate(target: onboardState.stage == 8 ? 1 : 0).fadeIn(begin: 0)
        : Container();
  }
}
