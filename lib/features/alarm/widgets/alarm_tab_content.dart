import 'package:alarmi/common/widgets/cst_error.dart';
import 'package:alarmi/common/widgets/cst_part_loading.dart';
import 'package:alarmi/features/alarm/models/alarm_params.dart';
import 'package:alarmi/features/alarm/screens/create_alarm_screen.dart';
import 'package:alarmi/features/alarm/services/alarm_notifier.dart';
import 'package:alarmi/features/main/vms/main_view_model.dart';
import 'package:alarmi/features/main/widgets/alarm.dart';
import 'package:alarmi/features/main/widgets/no_alarms.dart';
import 'package:alarmi/utils/helper_utils.dart';
import 'package:alarmi/utils/toast_utils.dart';
import 'package:alarmi/utils/widget_process_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AlarmTabContent extends ConsumerStatefulWidget {
  final String type;
  final int currentPageIndex;

  const AlarmTabContent({
    super.key,
    required this.type,
    required this.currentPageIndex,
  });

  @override
  ConsumerState<AlarmTabContent> createState() => AlarmTabContentState();
}

class AlarmTabContentState extends ConsumerState<AlarmTabContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentPageIndex = ref.watch(mainViewProvider).currentPageIndex;
    final double blurAreaHeight = getWinHeight(context) * 0.25;

    final AsyncValue<List<Map<String, dynamic>>> alarmAsync = ref.watch(
      alarmListProvider(widget.type),
    );

    return alarmAsync.when(
      data: (alarms) {
        if (alarms.isEmpty) {
          return NoAlarms();
        }
        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children:
                    alarms.map((alarm) {
                      final AlarmParams? alarmParams = AlarmParams.fromJson(
                        alarm,
                      );

                      // alarmParams가 null일 가능성 처리 (fromJson 결과)
                      if (alarmParams == null) {
                        return const SizedBox.shrink(); // 또는 오류 메시지 표시
                      }
                      // debugPrint(alarmParams.toString());

                      return Dismissible(
                        key: ValueKey(alarm['id']),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red.withValues(alpha: 0.9),
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) async {
                          final alarmNotifier = ref.read(
                            alarmListProvider(widget.type).notifier,
                          );
                          final int alarmIdToDelete = alarm['id'] as int;

                          try {
                            await alarmNotifier.deleteAlarm(
                              alarmIdToDelete,
                              widget.type,
                            );
                          } catch (e) {
                            callToast(context, '알람 삭제가 실패했습니다.');
                          }
                        },
                        child: GestureDetector(
                          onTap: () {
                            if (currentPageIndex == 1) {
                              debugPrint('currentPageIndex: $currentPageIndex');
                              context.pushNamed(
                                CreateAlarmScreen.routeName,
                                pathParameters: {
                                  'type': 'my',
                                  'alarmId': alarm['id'].toString(),
                                },
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 18,
                            ),
                            child: Alarm(
                              alarmId: alarm['id'],
                              params: alarmParams,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
            Positioned(
              // 블러를 적용할 영역 상단에 배치
              top: 0,
              left: 0,
              right: 0,
              height: getWinHeight(context) * 0.25,
              child: IgnorePointer(
                ignoring: currentPageIndex == 1,
                child: ClipRect(
                  child: AnimatedOpacity(
                    opacity: currentPageIndex == 0 ? 1.0 : 0.0,
                    duration: 500.ms,
                    child: Stack(
                      children: [
                        ...buildProgressiveBlurLayers(
                          blurAreaHeight: blurAreaHeight,
                          stepCount: 50,
                          // initialSigma: 0.0,
                          sigmaIncrement: 0.06,
                          heightReductionFactor: 0.8,
                          topCompressionFactor: 1.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
      loading: () => CstPartLoading(),

      error:
          (error, stackTrace) =>
              CstError(error: error, errorMessage: '알람을 불러오는 데 오류가 발생했습니다.'),
    );
  }
}
