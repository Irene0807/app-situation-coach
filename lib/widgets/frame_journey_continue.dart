import 'package:app_situational_coach/models/status.dart';
import 'package:app_situational_coach/state/journey_status_notifier.dart';
import 'package:app_situational_coach/widgets/frame_scene_datail.dart';
import 'package:app_situational_coach/widgets/page_day_cover.dart';
import 'package:app_situational_coach/widgets/page_journey_back_cover.dart';
import 'package:app_situational_coach/widgets/page_scene_cover.dart';
import 'package:flutter/material.dart';
import 'package:app_situational_coach/models/journey.dart';
import 'package:provider/provider.dart';
import 'package:app_situational_coach/widgets/page_journey_cover.dart';

// 注意: 在頁面中 journey的status不會變化 由JourneyStatusNotifier控制status
// 離開旅行時 會將JourneyStatusNotifier當下的status交給journey進行儲存 之後處理

enum FrameJourneyContinueTab {
  journeyCover,
  dayCover,
  sceneCover,
  sceneDetail,
  jourenyBackCover,
}

class FrameJourneyContinue extends StatelessWidget {
  final Journey journey;

  const FrameJourneyContinue({
    required this.journey,
    super.key,
  });

  FrameJourneyContinueTab getPageType(JourneyStatus status) {
    if (status.day == 0 && status.scene == 0 && status.mode == 0) {
      return FrameJourneyContinueTab.journeyCover;
    } else if (status.scene == 0 && status.mode == 0) {
      return FrameJourneyContinueTab.dayCover;
    } else if (status.mode == 0) {
      return FrameJourneyContinueTab.sceneCover;
    } else if (status.mode <= 3) {
      return FrameJourneyContinueTab.sceneDetail;
    } else if (status.day == 4 && status.scene == 4 && status.mode == 4) {
      return FrameJourneyContinueTab.jourenyBackCover;
    } else {
      throw Exception('status got wrong in FrameJourneyContinue\n');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Builder(builder: (context) {
        JourneyStatus status =
            Provider.of<JourneyStatusNotifier>(context, listen: true)
                .getStatus();
        FrameJourneyContinueTab tab = getPageType(status);
        switch (tab) {
          // 這邊我只把我即刻需要的參數丟進去 看之後怎麼調整
          case FrameJourneyContinueTab.journeyCover:
            return PageJourneyCover(
              journeyName: journey.name,
              journeyDay: journey.day,
            );
          case FrameJourneyContinueTab.dayCover:
            return PageDayCover(
                journeyName: journey.name,
                currentDay: status.day,
                schedule: journey.schedule);
          case FrameJourneyContinueTab.sceneCover:
            final sceneTitle =
                journey.schedule[status.day - 1].scenes[status.scene - 1].title;
            final sceneLocation = journey
                .schedule[status.day - 1].scenes[status.scene - 1].location;
            final sceneDescription = journey
                .schedule[status.day - 1].scenes[status.scene - 1].description;
            return PageSceneCover(
              sceneTitle: sceneTitle,
              sceneLocation: sceneLocation,
              sceneDescription: sceneDescription,
            );
          case FrameJourneyContinueTab.sceneDetail:
            final scene =
                journey.schedule[status.day - 1].scenes[status.scene - 1];
            return FrameSceneDetail(scene: scene);
          case FrameJourneyContinueTab.jourenyBackCover:
            return PageJourneyBackCover();
        }
      }),
      Positioned(
        right: 32,
        bottom: 32,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black54,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide.none,
            ),
            elevation: 4,
          ),
          onPressed: () {
            if (!Provider.of<JourneyStatusNotifier>(context, listen: false)
                .goNextStatus(journey)) {
              Navigator.pop(context);
            }
          },
          child: Icon(
            Icons.navigate_next,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
    ]);
  }
}
