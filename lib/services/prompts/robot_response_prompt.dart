// [SCRIPT GENERATOR] - 3 ROBOT RESPONSE PREDICTOR - 3 ROBOT RESPONSE PROMPT

String getRobotResponsePrompt({
  required String script,
  required String userInput,
}) {
  return '''
Here is the teaching script for this scene:
$script

The learner just said:
"$userInput"

As the AI tutor described in the script, please:
- Acknowledge or build on the user's message naturally.
- Follow the style, tone, and teaching approach in the script.
- End with a short, thought-provoking question to continue the conversation.
- Keep the total response under 40 words.

Return only your response as the tutor.
''';
}
