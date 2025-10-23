import 'package:app_situational_coach/models/question.dart';
import 'package:app_situational_coach/services/gemini/test_generator.dart';
import 'package:app_situational_coach/services/gemini/vocabulary_generator.dart';
import 'package:app_situational_coach/services/gemini/script_generator.dart';
import 'package:app_situational_coach/services/gemini/bloom_scene_evaluator.dart';
import 'package:app_situational_coach/models/journey.dart';
import 'package:app_situational_coach/models/message.dart';

// message history是否要放到這裡?
// SummaryContent的summary 需要用到history才能生成 無法套用提前生成的做法?

class Scene {
  final String id;
  final String title; // user可看 這個場景的名稱
  final String location; // user可看 這個場景的地點
  final String description; // user可看 描述這個場景user須完成的事情
  final String learningTheme;

  // 3 class for each scene
  IntroContent? introContent; // 單字介紹
  ConversationContent? conversationContent; // 和ai對話
  SummaryContent? summaryContent; // scene總結 + 題目考試

  Scene({
    required this.id,
    required this.title,
    required this.location,
    required this.description,
    required this.learningTheme,
    // 下面三個是為了dummyData可以直接宣告第一個scene的內容
    this.introContent,
    this.conversationContent,
    this.summaryContent,
  });

  bool isContentsReady() {
    return (introContent != null &&
        conversationContent != null &&
        summaryContent != null);
  }

  Future<void> generateAllContent({
    required Journey journey,
    // 因為script需要journey的資訊，所以把journey也傳進來了，如果 Intro、Summary需要也可以用
  }) async {
    // // 1. IntroContent
    // VocabularyGenerator v = VocabularyGenerator();
    // introContent = await v.generateVocabulary(this);

    // 2pre. Bloom Scene Evaluator => 更新 journey.bloomLevel
    final bloomSceneEvaluator = BloomSceneEvaluator();
    final newBloomLevel = await bloomSceneEvaluator.evaluateSceneBloomLevel(
      currentSceneIndex: journey.status.scene,
      messages: (journey.status.scene <= 2)
          ? [] // 沒有前前一個，return 1
          : journey.schedule[journey.status.day - 1]
              .scenes[journey.status.scene - 2] // 回傳前前一個
              .conversationContent
              ?.messages ?? [],
    );

    journey.bloomLevel = newBloomLevel;
    print("[DEBUG] Scene ${journey.status.scene} → BloomLevel = $newBloomLevel");

    // 2. ConversationContent
    ScriptGenerator s = ScriptGenerator();

    final script = await s.generateRefinedScript(
      journey: journey,
      scene: this,
    );
    conversationContent = ConversationContent(script: script);

    // 3. SummaryContent
    // TestGenerator t = TestGenerator();
    // summaryContent = await t.generateTest(
    //   this,
    //   introVocabulary: introContent?.vocabulary ?? [],
    // );

    return;
  }
}

class IntroContent {
  final String description; //角色風格的單字介紹
  final List<String> vocabulary;
  final List<Question> questions;

  IntroContent({
    required this.description,
    required this.vocabulary,
    required this.questions,
  });
}

class ConversationContent {
  final String script; //教角色如何教學的script
  final List<Message> messages; //使用者跟角色的對話紀錄

  ConversationContent({
    required this.script,
    List<Message>? messages,
  }) : messages = messages ?? [];
}

class SummaryContent {
  final String summary; // 旅程總結
  final List<Question> questions;
  int? funRating;

  SummaryContent({required this.summary, required this.questions, this.funRating});
}
