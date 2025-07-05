import 'package:alarmi/common/vms/bottom_section_view_model.dart';
import 'package:alarmi/features/alarm/screens/create_alarm_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class CreateAlarmMenus extends ConsumerWidget {
  const CreateAlarmMenus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomSectionState = ref.watch(bottomSectionProvider);
    final bottomSectionNotifier = ref.read(bottomSectionProvider.notifier);

    final init = bottomSectionNotifier.initStates;
    final bool isOpenCreateAlarmMenus =
        bottomSectionState.isOpenCreateAlarmMenus;

    void moveToCreateAlarm(BuildContext context, String type) {
      init();
      context.pushNamed(
        CreateAlarmScreen.routeName,
        pathParameters: {'type': type},
      );
    }

    return Padding(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              spacing: 2,
              children: [
                TextButton(
                  onPressed: () => moveToCreateAlarm(context, 'my'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Row(
                            spacing: 12,
                            children: [
                              SvgPicture.asset(
                                'assets/images/icons/circle_plus_icon.svg',
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '내 알람 만들기',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '미션 여부를 자유롭게 설정할 수 있어요',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Icon(Icons.chevron_right, color: Colors.black87),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(),
                ),
                TextButton(
                  onPressed: () => moveToCreateAlarm(context, 'team'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        spacing: 12,
                        children: [
                          Row(
                            spacing: 12,
                            children: [
                              SvgPicture.asset(
                                'assets/images/icons/my_alarm_icon.svg',
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '팀 알람 만들기',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '목표를 달성하고 더 많은 물고기를 얻을 수 있어요',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Icon(Icons.chevron_right, color: Colors.black87),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
        .animate(target: isOpenCreateAlarmMenus ? 1 : 0)
        .slideY(
          begin: -0.5,
          end: 0.0,
          curve: Curves.easeInOut,
          duration: 0.5.seconds,
        )
        .fadeIn();
  }
}
