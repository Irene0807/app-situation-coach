// [VOCABULARY GENERATOR]

import 'package:app_situational_coach/models/scene.dart';
import 'package:app_situational_coach/services/gemini/prompts/vocabulary_prompt.dart';
import 'gemini_instance.dart';

class VocabularyGenerator {
  Future<IntroContent> generateVocabulary(Scene scene) async {
    PromptVocabulary p = PromptVocabulary();
    final prompt = p.getVocabularyPrompt(scene);
    while (true) {
      final vocabularyText = await geminiA.sendPrompt(prompt);
      final vocabulary = p.parseIntroContent(vocabularyText);
      if (vocabulary != null) {
        return vocabulary;
      }
      print('generateVocabulary failed => regenerate\n');
    }
  }
}
