// [SCRIPT GENERATOR] - 1 ORIGIN SCRIPT GENERATOR

import '../gemini_instance.dart';
import '../prompts/origin_script_prompt.dart';
import '../../../models/character.dart';

class OriginScriptGenerator {

  Future<String> generate({
    required String title,
    required String theme,
    required String topic,
    required int bloomLevel,
    required Character character,
    String? feedback,
  }) async {
    final prompt = getOriginScriptPrompt(
      title: title,
      theme: theme,
      topic: topic,
      bloomLevel: bloomLevel,
      character: character,
      feedback: feedback,
    );
    return await geminiA.sendPrompt(prompt);
  }
}
