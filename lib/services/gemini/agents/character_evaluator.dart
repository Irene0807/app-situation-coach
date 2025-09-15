// [SCRIPT GENERATOR] - 6 CHARACTER EVALUATOR

import '../gemini_instance.dart';
import '../prompts/character_prompt.dart';

class CharacterEvaluationResult {
  final double score;
  final String feedback;

  CharacterEvaluationResult({
    required this.score,
    required this.feedback,
  });
}

class CharacterEvaluator {

  Future<CharacterEvaluationResult> evaluate({
    required String question,
    required String character,
  }) async {
    final prompt = getCharacterPrompt(
      question: question,
      character: character,
    );

    final response = await geminiB.sendPrompt(prompt);

    // 從回應中提取分數與建議
    final scoreMatch = RegExp(r'Score:\s*([0-9.]+)').firstMatch(response);
    final feedbackMatch = RegExp(r'Feedback:\s*(.*)').firstMatch(response);

    final score = double.tryParse(scoreMatch?.group(1) ?? '') ?? 0.0;
    final feedback = feedbackMatch?.group(1) ?? 'No feedback.';

    return CharacterEvaluationResult(
      score: score,
      feedback: feedback,
    );
  }
}
