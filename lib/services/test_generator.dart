// [TEST GENERATOR]

import 'package:app_situational_coach/models/scene.dart';
import 'package:app_situational_coach/services/prompts/test_prompt.dart';
import '../services/gemini_instance.dart';

// 目前的prompt沒有使用history message 之後要調整

class TestGenerator {
  Future<SummaryContent> generateTest(Scene scene) async {
    PromptTest p = PromptTest();
    final prompt = p.getTestPrompt(scene);
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
