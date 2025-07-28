import 'package:app_situational_coach/models/question.dart';
import 'package:app_situational_coach/services/vocabulary_generator.dart';
import 'package:app_situational_coach/services/script_generator.dart';
import 'package:app_situational_coach/models/journey.dart';
import 'package:app_situational_coach/models/message.dart';

// 使用者在summaryContent時 背後先generate下一個場景的script

class Scene {
  final String title; // user可看 這個場景的名稱
  final String location; // user可看 這個場景的地點
  final String description; // user可看 描述這個場景user須完成的事情
  final String learningTheme;

  // 3 class for each scene
  IntroContent? introContent; // 單字介紹
  ConversationContent? conversationContent; // 和ai對話
  SummaryContent? summaryContent; // scene總結 + 題目考試

  Scene({
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
    // 1. IntroContent
    VocabularyGenerator v = VocabularyGenerator();
    introContent = await v.generateVocabulary(this);

    // 2. ConversationContent
    ScriptGenerator s = ScriptGenerator();

    // (增加傳入journey，因為會用到　journey 裡面的 bloomLevel / character）
    final script = await s.generateRefinedScript(
        journey: journey,
        scene: this,
    );
    conversationContent = ConversationContent(script: script);

    // 3. SummaryContent

    return;
  }
}

class IntroContent {
  final String description; //角色風格的單字介紹
  final List<String> vocabulary;

  IntroContent({
    required this.description,
    required this.vocabulary,
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
  final String summary; // 角色風格的旅程總結
  final List<Question> questions;

  SummaryContent({required this.summary, required this.questions});
}
