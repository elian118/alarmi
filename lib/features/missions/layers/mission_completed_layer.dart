import 'package:alarmi/common/consts/sizes.dart';
import 'package:alarmi/features/main/screens/main_screen.dart';
import 'package:alarmi/features/missions/services/mission_status_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MissionCompletedLayer extends StatelessWidget {
  const MissionCompletedLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 45),
            alignment: Alignment.center,
            child: Container(
              height: 400,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(
                      '미션 성공',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/images/characters/mission_completed.png',
                    // width: 260,
                    // height: 260,
                    fit: BoxFit.cover,
                  ),
                  Text(
                    '좋은 아침이에요!\n오늘도 힘차게 시작해요.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      MissionStatusService.setWakeUpMissionCompleted(true);
                      context.go('${MainScreen.routeURL}/mission_completed');
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
                          '확인',
                          style: TextStyle(
                            fontSize: Sizes.size18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
