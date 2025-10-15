import 'package:app_situational_coach/models/status.dart';
import 'package:app_situational_coach/states/journey_status_notifier.dart';
import 'package:app_situational_coach/widgets/page_day_cover.dart';
import 'package:app_situational_coach/widgets/page_journey_back_cover.dart';
import 'package:app_situational_coach/widgets/page_post_test.dart';
import 'package:app_situational_coach/widgets/page_pre_test.dart';
import 'package:app_situational_coach/widgets/page_scene_conversation.dart';
import 'package:app_situational_coach/widgets/page_scene_cover.dart';
import 'package:app_situational_coach/widgets/page_scene_intro.dart';
import 'package:app_situational_coach/widgets/page_scene_summary.dart';
import 'package:flutter/material.dart';
import 'package:app_situational_coach/models/journey.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:app_situational_coach/widgets/page_journey_cover.dart';
import 'dart:ui';

// 已解除雙層loading畫面的問題 但有可能性仍有bug 待測試

// 注意: 在頁面中 journey的status不會變化 由JourneyStatusNotifier控制status
// 離開旅行時 會將JourneyStatusNotifier當下的status交給journey進行儲存 之後處理

enum FrameJourneyContinueTab {
  preTest,
  journeyCover,
  dayCover,
  sceneCover,
  sceneIntro,
  sceneConversation,
  sceneSummary,
  journeyBackCover,
  postTest,
}

class FrameJourneyContinue extends StatelessWidget {
  const FrameJourneyContinue({
    super.key,
  });

  // 這個function有不少優化空間吧...
  Future<void> goNextPage(BuildContext context, JourneyStatusNotifier notifier,
      FrameJourneyContinueTab currentTab) async {
    //  開啟loading狀態
    notifier.setLoading(true);
    // 把目前頁面內容跟新到db
    switch (currentTab) {
      case FrameJourneyContinueTab.sceneIntro:
        await notifier.uploadSceneIntro(notifier
            .journey
            .schedule[notifier.journey.status.day - 1]
            .scenes[notifier.journey.status.scene - 1]
            .id);
        break;
      case FrameJourneyContinueTab.sceneConversation:
        await notifier.uploadSceneConversation(
            notifier.journey.schedule[notifier.journey.status.day - 1]
                .scenes[notifier.journey.status.scene - 1].id,
            notifier
                .journey
                .schedule[notifier.journey.status.day - 1]
                .scenes[notifier.journey.status.scene - 1]
                .conversationContent!
                .messages);
        break;
      case FrameJourneyContinueTab.sceneSummary:
        await notifier.uploadSceneSummary(notifier
            .journey
            .schedule[notifier.journey.status.day - 1]
            .scenes[notifier.journey.status.scene - 1]
            .id);
        break;
      default:
        break;
    }

    // 換頁
    if (await notifier.goNextStatus() == false && context.mounted) {
      context.pop(); // 若抵達最後一頁 離開
    }

    // 處理scene的生成
    if (currentTab == FrameJourneyContinueTab.sceneCover) {
      // journey status先訂死
      JourneyStatus fixedStatus = JourneyStatus(
          day: notifier.journey.status.day,
          scene: notifier.journey.status.scene,
          mode: notifier.journey.status.mode);

      if (fixedStatus.day <= 0 ||
          fixedStatus.scene <= 0 ||
          fixedStatus.day > notifier.journey.schedule.length) {
        notifier.setLoading(false);
        return;
      } // 加這個避免index取到負數的exception

      //
      // ******** 先處理當前scene的生成問題 ********
      //

      // 清除暫存資料
      notifier.cleanTmpData();
      // 到了scene cover但scene還沒準備好
      if (notifier.getSceneReady() == false &&
          notifier.isSceneGenerating == false) {
        // 標示生成中
        notifier.setIsSceneGenerating(true);
        // 生成 content
        await notifier
            .journey.schedule[fixedStatus.day - 1].scenes[fixedStatus.scene - 1]
            .generateAllContent(journey: notifier.journey);
        // 上傳db
        await notifier.uploadPreSceneContent(
            notifier.journey.schedule[fixedStatus.day - 1]
                .scenes[fixedStatus.scene - 1].id,
            notifier.journey.schedule[fixedStatus.day - 1]
                .scenes[fixedStatus.scene - 1]);
        // 標示生成結束
        notifier.setIsSceneGenerating(false);
      }

      // 解除loading狀態
      notifier.setLoading(false);

      //
      // ******** 再處理下一個scene的生成問題 ********
      //

      // 標示生成中
      notifier.setIsSceneGenerating(true);
      if (fixedStatus.day > 0 && fixedStatus.scene <
          notifier.journey.schedule[fixedStatus.day - 1].scenes.length) {
        // 生成 content
        await notifier
            .journey.schedule[fixedStatus.day - 1].scenes[fixedStatus.scene]
            .generateAllContent(journey: notifier.journey);
        // 上傳db
        await notifier.uploadPreSceneContent(
            notifier.journey.schedule[fixedStatus.day - 1]
                .scenes[fixedStatus.scene].id,
            notifier.journey.schedule[fixedStatus.day - 1]
                .scenes[fixedStatus.scene]);
      } else if (fixedStatus.day < notifier.journey.schedule.length) {
        // 生成 content
        await notifier.journey.schedule[fixedStatus.day].scenes[0]
            .generateAllContent(journey: notifier.journey);
        // 上傳db
        await notifier.uploadPreSceneContent(
            notifier.journey.schedule[fixedStatus.day].scenes[0].id,
            notifier.journey.schedule[fixedStatus.day].scenes[0]);
      }
      // 標示生成結束
      notifier.setIsSceneGenerating(false);
    } else {
      // 解除loading狀態
      notifier.setLoading(false);
    }
  }

  FrameJourneyContinueTab getPageType(JourneyStatus status) {
    if (status.day == -3 && status.scene == -3 && status.mode == -3) {
      return FrameJourneyContinueTab.preTest;
    } else if (status.day == 0 && status.scene == 0 && status.mode == 0) {
      return FrameJourneyContinueTab.journeyCover;
    } else if (status.scene == 0 && status.mode == 0) {
      return FrameJourneyContinueTab.dayCover;
    } else if (status.mode == 0) {
      return FrameJourneyContinueTab.sceneCover;
    } else if (status.mode <= 3) {
      switch (status.mode) {
        case 1:
          return FrameJourneyContinueTab.sceneIntro;
        case 2:
          return FrameJourneyContinueTab.sceneConversation;
        case 3:
          return FrameJourneyContinueTab.sceneSummary;
        default:
          throw Exception('status got wrong in FrameJourneyContinue\n');
      }
    } else if (status.day == 4 && status.scene == 4 && status.mode == 4) {
      return FrameJourneyContinueTab.journeyBackCover;
    } else if (status.day == -2 && status.scene == -2 && status.mode == -2) {
      return FrameJourneyContinueTab.postTest;
    } else {
      throw Exception('status got wrong in FrameJourneyContinue\n');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<JourneyStatusNotifier>().loading == true) {
      return const Center(child: CircularProgressIndicator());
    } else {
      Journey journey =
          Provider.of<JourneyStatusNotifier>(context, listen: true).journey;
      FrameJourneyContinueTab tab = getPageType(journey.status);
      switch (tab) {
        // 這邊我只把我即刻需要的參數丟進去 看之後怎麼調整
        case FrameJourneyContinueTab.preTest:
          bool isPass =
              Provider.of<JourneyStatusNotifier>(context, listen: true).isPass;
          return buildFunction(
              context: context,
              backGroundImage: true,
              mask: false,
              button: isPass,
              currentTab: tab,
              widget: PagePreTest());

        case FrameJourneyContinueTab.journeyCover:
          return buildFunction(
              context: context,
              backGroundImage: true,
              mask: false,
              button: true,
              currentTab: tab,
              widget: PageJourneyCover(
                journeyName: journey.name,
                journeyDay: journey.day,
              ));

        case FrameJourneyContinueTab.dayCover:
          return buildFunction(
              context: context,
              backGroundImage: true,
              mask: true,
              button: true,
              currentTab: tab,
              widget: PageDayCover(
                  journeyName: journey.name,
                  currentDay: journey.status.day,
                  schedule: journey.schedule));

        case FrameJourneyContinueTab.sceneCover:
          final sceneTitle = journey.schedule[journey.status.day - 1]
              .scenes[journey.status.scene - 1].title;
          final sceneLocation = journey.schedule[journey.status.day - 1]
              .scenes[journey.status.scene - 1].location;
          final sceneDescription = journey.schedule[journey.status.day - 1]
              .scenes[journey.status.scene - 1].description;
          return buildFunction(
              context: context,
              backGroundImage: true,
              mask: true,
              button: true,
              currentTab: tab,
              widget: PageSceneCover(
                sceneTitle: sceneTitle,
                sceneLocation: sceneLocation,
                sceneDescription: sceneDescription,
              ));

        case FrameJourneyContinueTab.sceneIntro:
          bool isPass =
              Provider.of<JourneyStatusNotifier>(context, listen: true).isPass;
          final scene = journey.schedule[journey.status.day - 1]
              .scenes[journey.status.scene - 1];
          return buildFunction(
              context: context,
              backGroundImage: true,
              mask: true,
              button: isPass,
              currentTab: tab,
              widget: PageSceneIntro(
                  introContent: scene.introContent!, journey: journey));

        case FrameJourneyContinueTab.sceneConversation:
          bool isPass =
              Provider.of<JourneyStatusNotifier>(context, listen: true).isPass;
          final scene = journey.schedule[journey.status.day - 1]
              .scenes[journey.status.scene - 1];
          return buildFunction(
              context: context,
              backGroundImage: true,
              mask: true,
              button: isPass,
              currentTab: tab,
              widget: PageSceneConversation(
                  conversationContent: scene.conversationContent!,
                  sceneTitle: scene.title,
                  journey: journey));

        case FrameJourneyContinueTab.sceneSummary:
          bool isPass =
              Provider.of<JourneyStatusNotifier>(context, listen: true).isPass;
          final scene = journey.schedule[journey.status.day - 1]
              .scenes[journey.status.scene - 1];
          return buildFunction(
              context: context,
              backGroundImage: true,
              mask: true,
              button: isPass,
              currentTab: tab,
              widget: PageSceneSummary(summaryContent: scene.summaryContent!));

        case FrameJourneyContinueTab.journeyBackCover:
          return buildFunction(
              context: context,
              backGroundImage: true,
              mask: true,
              button: true,
              currentTab: tab,
              widget: PageJourneyBackCover());

        case FrameJourneyContinueTab.postTest:
          return buildFunction(
              context: context,
              backGroundImage: true,
              mask: false,
              button: true,
              currentTab: tab,
              widget: PagePostTest());
      }
    }
  }

  Widget buildFunction(
      {required BuildContext context,
      required bool backGroundImage,
      required bool mask,
      required bool button,
      required FrameJourneyContinueTab currentTab,
      required Widget widget}) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
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
                  onPressed: () => goNextPage(
                      context,
                      Provider.of<JourneyStatusNotifier>(context,
                          listen: false),
                      currentTab),
                  child: Icon(
                    Icons.navigate_next,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              )
            : SizedBox(),
      ]),
    );
  }
}
