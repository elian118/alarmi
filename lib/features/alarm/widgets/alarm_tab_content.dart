import 'package:alarmi/features/alarm/models/alarm_params.dart';
import 'package:alarmi/features/alarm/screens/create_alarm_screen.dart';
import 'package:alarmi/features/alarm/services/alarm_notifier.dart';
import 'package:alarmi/features/main/widgets/alarm.dart';
import 'package:alarmi/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AlarmTabContent extends ConsumerStatefulWidget {
  final String type;

  const AlarmTabContent({super.key, required this.type});

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
    final AsyncValue<List<Map<String, dynamic>>> alarmAsync = ref.watch(
      alarmListProvider(widget.type),
    );

    return alarmAsync.when(
      data: (alarms) {
        if (alarms.isEmpty) {
          return Center(
            child: Text(
              "저장된 알람이 없습니다.",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          );
        }
        return SingleChildScrollView(
          child: Column(
            children:
                alarms.map((alarm) {
                  final AlarmParams? alarmParams = AlarmParams.fromJson(alarm);

                  // alarmParams가 null일 가능성 처리 (fromJson 결과)
                  if (alarmParams == null) {
                    return const SizedBox.shrink(); // 또는 오류 메시지 표시
                  }
                  print(alarmParams.toString());

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
                        callSimpleToast('알림 삭제가 실패했습니다.');
                      }
                    },
                    child: GestureDetector(
                      onTap:
                          () => context.pushNamed(
                            CreateAlarmScreen.routeName,
                            pathParameters: {
                              'type': 'my',
                              'alarmId': alarm['id'].toString(),
                            },
                          ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 20,
                        ),
                        child: Alarm(alarmId: alarm['id'], params: alarmParams),
                      ),
                    ),
                  );
                }).toList(),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),

      error:
          (error, stackTrace) => Center(
            child: Text(
              '알람을 불러오는 데 오류가 발생했습니다. $error',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
    );
  }
}
