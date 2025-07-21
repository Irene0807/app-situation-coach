// [SCRIPT GENERATOR] - 3 ROBOT RESPONSE PREDICTOR

import '../gemini_instance.dart';
import '../prompts/robot_response_prompt.dart';

class RobotResponsePredictor {

  Future<String> generateResponse({
    required String script,
    required String userInput,
  }) async {
    final prompt = getRobotResponsePrompt(
      script: script,
      userInput: userInput,
    );

    return await geminiA.sendPrompt(prompt);
  }
}
