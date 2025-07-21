// [SCRIPT GENERATOR] - 2 USER SITUATION PREDICTOR

import '../gemini_instance.dart';
import '../prompts/user_situation_prompt.dart';

class UserSituationPredictor {

  Future<String> predictPossibleUtterance({
    required String theme,
    required String topic,
    required double bloomLevel,
  }) async {
    final prompt = getUserSituationPrompt(
      theme: theme,
      topic: topic,
      bloomLevel: bloomLevel
    );
    return await geminiB.sendPrompt(prompt);
  }
}
