// [TEST GENERATOR]

import 'package:app_situational_coach/models/scene.dart';
import 'package:app_situational_coach/services/prompts/test_prompt.dart';
import '../services/gemini_instance.dart';

class TestGenerator {
  Future<SummaryContent> generateTest(Scene scene) async {
    PromptTest p = PromptTest();
    final prompt = p.getTestPrompt(scene);
    final testText = await geminiA.sendPrompt(prompt);
    SummaryContent s = p.parseSummaryContent(testText);
    return s;
  }
}
