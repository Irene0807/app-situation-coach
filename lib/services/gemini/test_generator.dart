// [TEST GENERATOR]

import 'package:app_situational_coach/models/scene.dart';
import 'package:app_situational_coach/services/gemini/prompts/test_prompt.dart';
import 'gemini_instance.dart';

// 把intro丟進來了

class TestGenerator {
  Future<SummaryContent> generateTest(
    Scene scene, {
    List<String> introVocabulary = const [],
  }) async {
    PromptTest p = PromptTest();
    final prompt = p.getTestPrompt(
      scene,
      introVocabulary: introVocabulary,
    );
    while (true) {
      final testText = await geminiA.sendPrompt(prompt);
      final test = p.parseSummaryContent(testText);
      if (test != null) {
        return test;
      }
      print('generateTest failed => regenerate\n');
    }
  }
}
