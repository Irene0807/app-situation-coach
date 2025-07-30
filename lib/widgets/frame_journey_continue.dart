import 'package:app_situational_coach/models/status.dart';
import 'package:app_situational_coach/state/journey_status_notifier.dart';
import 'package:app_situational_coach/widgets/frame_scene_datail.dart';
import 'package:app_situational_coach/widgets/page_day_cover.dart';
import 'package:app_situational_coach/widgets/page_journey_back_cover.dart';
import 'package:app_situational_coach/widgets/page_scene_cover.dart';
import 'package:app_situational_coach/widgets/widget_loading_mark.dart';
import 'package:flutter/material.dart';
import 'package:app_situational_coach/models/journey.dart';
import 'package:provider/provider.dart';
import 'package:app_situational_coach/widgets/page_journey_cover.dart';
import 'dart:ui';

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

  // 在sceneCover時確認目前scene已準備完成 並開始準備下一個scene的所有Content
  Future<void> prepareForNextScene(
      JourneyStatusNotifier notifier, JourneyStatus currentStatus) async {
    // 這個function的加一減一問題需要特別小心。。。

    // 確認目前scene已全部準備完成
    // if (!journey.schedule[currentStatus.day - 1].scenes[currentStatus.scene - 1]
    //     .isContentsReady()) {
    if (journey.schedule[currentStatus.day - 1].scenes[currentStatus.scene - 1]
            .introContent ==
        null) {
      notifier.setSceneReady(false);
    }

    // 生成下個場景的 Content
    if (currentStatus.scene <
        journey.schedule[currentStatus.day - 1].scenes.length) {
      await journey.schedule[currentStatus.day - 1].scenes[currentStatus.scene]
          .generateAllContent(journey: journey);
    } else {
      await journey.schedule[currentStatus.day].scenes[0].generateAllContent(journey: journey);
    }

    // 發出通知 scene已完成
    notifier.setSceneReady(true);
  }

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
    JourneyStatus status =
        Provider.of<JourneyStatusNotifier>(context, listen: true).getStatus();
    FrameJourneyContinueTab tab = getPageType(status);
    switch (tab) {
      // 這邊我只把我即刻需要的參數丟進去 看之後怎麼調整
      case FrameJourneyContinueTab.journeyCover:
        return buildFunction(
            context,
            true,
            false,
            true,
            PageJourneyCover(
              journeyName: journey.name,
              journeyDay: journey.day,
            ));
      case FrameJourneyContinueTab.dayCover:
        return buildFunction(
            context,
            true,
            true,
            true,
            PageDayCover(
                journeyName: journey.name,
                currentDay: status.day,
                schedule: journey.schedule));
      case FrameJourneyContinueTab.sceneCover:
        final sceneTitle =
            journey.schedule[status.day - 1].scenes[status.scene - 1].title;
        final sceneLocation =
            journey.schedule[status.day - 1].scenes[status.scene - 1].location;
        final sceneDescription = journey
            .schedule[status.day - 1].scenes[status.scene - 1].description;
        return buildFunction(
            context,
            true,
            true,
            true,
            PageSceneCover(
              sceneTitle: sceneTitle,
              sceneLocation: sceneLocation,
              sceneDescription: sceneDescription,
            ));
      case FrameJourneyContinueTab.sceneDetail:
        bool sceneReady =
            Provider.of<JourneyStatusNotifier>(context, listen: true)
                .getSceneReady();
        if (sceneReady) {
          bool isPass =
              Provider.of<JourneyStatusNotifier>(context, listen: true).isPass;
          final scene =
              journey.schedule[status.day - 1].scenes[status.scene - 1];
          return buildFunction(
              context, true, true, isPass, FrameSceneDetail(scene: scene));
        } else {
          return buildFunction(context, true, true, true, WidgetLoadingMark());
        }
      case FrameJourneyContinueTab.jourenyBackCover:
        return buildFunction(context, true, true, true, PageJourneyBackCover());
    }
  }

  Widget buildFunction(
    BuildContext context,
    bool backGroundImage,
    bool mask,
    bool button,
    Widget widget,
  ) {
    return Stack(children: [
      backGroundImage
          ? Positioned.fill(
              // 之後圖片要用生成的
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8), // 調整模糊程度
                child: Image.asset(
                  'assets/images/seoul_shopping.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            )
          : SizedBox(),
      mask
          ? Positioned.fill(
              child: ColoredBox(
                color: Colors.black.withOpacity(0.4),
              ),
            )
          : SizedBox(),
      widget,
      button
          ? Positioned(
              right: 32,
              bottom: 32,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black54,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide.none,
                  ),
                  elevation: 4,
                ),
                onPressed: () {
                  // 前往下一個page 若為最後一page則退出旅行
                  if (!Provider.of<JourneyStatusNotifier>(context,
                          listen: false)
                      .goNextStatus(journey)) {
                    Navigator.pop(context);
                  }

                  // 若為sceneCover 執行prepareForNextScene
                  JourneyStatusNotifier notifier =
                      Provider.of<JourneyStatusNotifier>(context,
                          listen: false);
                  FrameJourneyContinueTab tab =
                      getPageType(notifier.getStatus());
                  if (tab == FrameJourneyContinueTab.sceneCover) {
                    JourneyStatus status = notifier.getStatus();
                    prepareForNextScene(notifier, status);
                  }
                },
                child: Icon(
                  Icons.navigate_next,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            )
          : SizedBox(),
    ]);
  }
}
