import '../agents/gemini.dart';
import 'question_generator.dart';
import 'respond_predictor.dart';
import 'bloom_evaluator.dart';
import 'character_evaluator.dart';

class AgentController {
  final QuestionGenerator _questionGenerator = QuestionGenerator();
  final RespondPredictor _respondPredictor = RespondPredictor();
  final BloomEvaluator _bloomEvaluator = BloomEvaluator();
  final CharacterEvaluator _characterEvaluator = CharacterEvaluator();

  final double bloomThreshold = 0.3;
  final double characterThreshold = 0.5;

  // 使用者歷史 Bloom 分析
  Future<double> averageUserBloomLevel(List<String> userResponses) async {
    if (userResponses.isEmpty) return 1.0;

    double total = 0.0;
    for (final response in userResponses) {
      final result = await _bloomEvaluator.evaluate(response);
      total += result.level;
    }
    return total / userResponses.length;
  }

  // 開始我們的對話流程
  Future<String> runDialogueRound({
    required String character,
    required String history,
    required String userInput,
    required List<String> userHistoryAnswers,
  }) async {
    final double avgBloom = await averageUserBloomLevel(userHistoryAnswers);

    while (true) {
      final aiResponse = await _questionGenerator.generate(
        character: character,
        history: history,
        userInput: userInput,
      );

      final predictedAnswer = await _respondPredictor.predict(
        question: aiResponse,
        character: character,
        history: history,
      );

      final bloomResult = await _bloomEvaluator.evaluate(predictedAnswer);
      final charResult = await _characterEvaluator.evaluate(
        question: aiResponse,
        character: character,
      );

      final bool bloomPass = bloomResult.confidence >= bloomThreshold;
      final bool charPass = charResult.score >= characterThreshold;
      final bool isImproved = bloomResult.level > avgBloom;

      if (bloomPass && charPass && isImproved) {
        return aiResponse;
      } else {
        print('[REJECTED] Re-asking...');
        print('User Avg Bloom: $avgBloom');
        print('Predicted Bloom: ${bloomResult.level} (${bloomResult.confidence}) → ${bloomResult.feedback}');
        print('Character: ${charResult.score} → ${charResult.feedback}');
      }
    }
  }
}
