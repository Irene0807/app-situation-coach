// [VOCABULARY GENERATOR]

import 'package:app_situational_coach/models/scene.dart';
import 'package:app_situational_coach/services/prompts/vocabulary_prompt.dart';
import '../services/gemini_instance.dart';

class VocabularyGenerator {
  Future<IntroContent> generateVocabulary(Scene scene) async {
    PromptVocabulary p = PromptVocabulary();
    final prompt = p.getVocabularyPrompt(scene);
    final vocabularyText = await geminiA.sendPrompt(prompt);
    IntroContent i = p.parseIntroContent(vocabularyText);
    return i;
  }
}
