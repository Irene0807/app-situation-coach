// [SCRIPT GENERATOR] - 4 USER RESPONSE PREDICTOR

import '../gemini_instance.dart';
import '../prompts/user_response_prompt.dart';

class UserResponsePredictor {

  Future<String> predictResponse({
    required String robotMessage,
    required String theme,
    required double bloomLevel,
  }) async {
    final prompt = getUserResponsePrompt(
      robotMessage: robotMessage,
      theme: theme,
      bloomLevel: bloomLevel,
    );

    return await geminiA.sendPrompt(prompt);
  }
}
