import 'package:app_situational_coach/models/status.dart';
import 'package:app_situational_coach/state/journey_status_notifier.dart';
import 'package:app_situational_coach/widgets/frame_scene_datail.dart';
import 'package:app_situational_coach/widgets/page_day_cover.dart';
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
    } else {
      throw Exception('status got wrong in FrameJourneyContinue\n');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/add_background.png',
            fit: BoxFit.cover,
          ),
        ),
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
              final dayTitles = journey.schedule
                  .take(status.day) // 取前 status.day 個 Day
                  .map((day) => day.title) // 只取 title
                  .toList();
              return PageDayCover(dayTitles: dayTitles);
            case FrameJourneyContinueTab.sceneCover:
              final sceneTitles = journey.schedule[status.day - 1].scenes
                  .take(status.scene)
                  .map((scene) => scene.title)
                  .toList();
              final sceneLocation = journey
                  .schedule[status.day - 1].scenes[status.scene - 1].location;
              return PageSceneCover(
                  sceneTitles: sceneTitles, sceneLocation: sceneLocation);
            case FrameJourneyContinueTab.sceneDetail:
              final scene =
                  journey.schedule[status.day - 1].scenes[status.scene - 1];
              return FrameSceneDetail(scene: scene);
          }
        }),
        Center(
          child: IconButton(
              onPressed: () {
                Provider.of<JourneyStatusNotifier>(context, listen: false)
                    .goNextStatus(journey);
              },
              icon: Icon(Icons.arrow_downward)),
        )
      ],
    );
  }
}
