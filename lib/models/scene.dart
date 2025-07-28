import 'package:app_situational_coach/models/question.dart';
import 'package:app_situational_coach/services/test_generator.dart';
import 'package:app_situational_coach/services/vocabulary_generator.dart';

// message history是否要放到這裡?
// SummaryContent的summary 需要用到history才能生成 無法套用提前生成的做法?

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

  Future<void> generateAllContent() async {
    // IntroContent
    VocabularyGenerator v = VocabularyGenerator();
    introContent = await v.generateVocabulary(this);

    // ConversationContent

    // SummaryContent
    TestGenerator t = TestGenerator();
    summaryContent = await t.generateTest(this);

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
  final String script;

  ConversationContent({required this.script});
}

class SummaryContent {
  final String summary; // 旅程總結
  final List<Question> questions;

  SummaryContent({required this.summary, required this.questions});
}
