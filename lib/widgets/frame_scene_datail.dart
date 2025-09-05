import 'package:app_situational_coach/models/scene.dart';
import 'package:app_situational_coach/models/status.dart';
import 'package:app_situational_coach/models/journey.dart';
import 'package:app_situational_coach/states/journey_status_notifier.dart';
import 'package:app_situational_coach/widgets/page_scene_conversation.dart';
import 'package:app_situational_coach/widgets/page_scene_intro.dart';
import 'package:app_situational_coach/widgets/page_scene_summary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 注意: 在頁面中 journey的status不會變化 由JourneyStatusNotifier控制status
// 離開旅行時 會將JourneyStatusNotifier當下的status交給journey進行儲存 之後處理

enum FrameSceneDetailTab {
  intro,
  conversation,
  summary,
}

class FrameSceneDetail extends StatelessWidget {
  final Scene scene;
  final Journey journey;

  const FrameSceneDetail({
    required this.scene,
    required this.journey,
    super.key,
  });

  FrameSceneDetailTab getPageType(JourneyStatus status) {
    if (status.mode == 1) {
      return FrameSceneDetailTab.intro;
    } else if (status.mode == 2) {
      return FrameSceneDetailTab.conversation;
    } else if (status.mode == 3) {
      return FrameSceneDetailTab.summary;
    } else {
      throw Exception('status got wrong in FrameSceneDetail\n');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      JourneyStatus status =
          Provider.of<JourneyStatusNotifier>(context, listen: true).getStatus();
      FrameSceneDetailTab tab = getPageType(status);
      switch (tab) {
        case FrameSceneDetailTab.intro:
          return PageSceneIntro(introContent: scene.introContent!);
        case FrameSceneDetailTab.conversation:
          return PageSceneConversation(
              conversationContent: scene.conversationContent!, sceneTitle: scene.title, journey: journey);
        case FrameSceneDetailTab.summary:
          return PageSceneSummary(summaryContent: scene.summaryContent!);
      }
    });
  }
}
