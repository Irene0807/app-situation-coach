// [SCRIPT GENERATOR] - 6 CHARACTER EVALUATOR - 6 CHARACTER PROMPT

String getCharacterPrompt({
  required String question,
  required String character,
}) {
  return '''
You are an expert in evaluating character consistency in conversations.

Given a generated AI question:
"$question"

Evaluate how well this question fits the speaking style, personality, and communication pattern of the character:
"$character"

Scoring:
- Score from 0.0 (not fitting at all) to 1.0 (perfectly aligned with character)
- Provide a one-sentence feedback to improve the alignment

Format:
Score: <0.0 ~ 1.0>
Feedback: <brief suggestion>
''';
}
