import 'package:app_situational_coach/models/question.dart';

// 使用者在summaryContent時 背後先generate下一個場景的script

class Scene {
  final String title; // 給user看的 這個場景的名稱
  final String location; // 給user看的 這個場景的地點
  final String learningTheme;
  final String dialogueTopic;

  // 3 pages for each scene
  IntroContent? introContent; // 單字介紹
  ConversationContent? conversationContent; // 和ai對話
  SummaryContent? summaryContent; // scene總結 + 題目考試

  Scene({
    required this.title,
    required this.location,
    required this.learningTheme,
    required this.dialogueTopic,
  });

  void generateIntroContent() {
    // call services
  }

  void generateConversationContent() {
    // call services
  }

  void generateSummaryContent() {
    // call services
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
  final String script;

  ConversationContent({required this.script});
}

class SummaryContent {
  final String summary; // 角色風格的旅程總結
  final List<Question> questions;

  SummaryContent({required this.summary, required this.questions});
}
