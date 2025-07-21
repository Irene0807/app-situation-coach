// [SCRIPT GENERATOR] - 5 BLOOM EVALUATOR

import '../gemini_instance.dart';
import '../prompts/bloom_prompt.dart';

/*
BloomEvaluator：
  - BloomA(broad)：分析答案的廣泛 Bloom 分類（高/低）
  - BloomB(precise)：分析答案的精確 Bloom 級別（1-6）
  - BloomC(direct)：直接分析答案的 Bloom 級別（1-6）
  - BloomSummary：若不通過，總結建議
*/

class BloomEvaluationResult {
  final String feedback;
  final bool passed;

  BloomEvaluationResult({
    required this.feedback,
    required this.passed,
  });
}

class BloomEvaluator {
  final double threshold = 0.5;

  Future<BloomEvaluationResult> evaluate(String userAnswer, double userBloomLevel) async {
    // Step A + C (並行)
    final futureA = _evaluateBroadLevel(userAnswer);
    final futureC = _evaluateDirectLevel(userAnswer);

    final broadLevel = await futureA;
    final levelC = await futureC;

    // Step B (需等 A 完成)
    final levelB = await _evaluatePreciseLevel(broadLevel, userAnswer);

    // Confidence 判斷
    double confidence = 0.3;
    if (levelB == levelC) {
      confidence = 1.0;
    } else if ((levelB - levelC).abs() == 1) {
      confidence = 0.7;
    } else {
      confidence = 0.4;
    }

    final isImproved = levelC > userBloomLevel;
    final passed = isImproved && confidence >= threshold;

    // 若不通過則呼叫 summarizer
    String feedback = '';
    if (!passed) {
      feedback = await _summarizeFeedback(
        userAnswer: userAnswer,
        userLevel: userBloomLevel,
        predictedLevel: levelC,
        confidence: confidence,
      );
    }

    return BloomEvaluationResult(
      feedback: feedback,
      passed: passed,
    );
  }

  Future<String> _evaluateBroadLevel(String userAnswer) async {
    final promptA = getBloomBroadPrompt(userAnswer);
    final resultA = await geminiA.sendPrompt(promptA);
    return resultA.trim().toUpperCase().contains('HIGH') ? 'HIGH' : 'LOW';
  }

  Future<int> _evaluatePreciseLevel(String broadLevel, String userAnswer) async {
    final promptB = getBloomPrecisePrompt(broadLevel, userAnswer);
    final resultB = await geminiA.sendPrompt(promptB);
    return int.tryParse(RegExp(r'[1-6]').stringMatch(resultB) ?? '') ?? 1;
  }

  Future<int> _evaluateDirectLevel(String userAnswer) async {
    final promptC = getBloomDirectPrompt(userAnswer);
    final resultC = await geminiB.sendPrompt(promptC);
    final levelMatch = RegExp(r'Level:\s*([1-6])').firstMatch(resultC);
    final level = int.tryParse(levelMatch?.group(1) ?? '') ?? 1;
    return level;
  }

  Future<String> _summarizeFeedback({
    required String userAnswer,
    required double userLevel,
    required int predictedLevel,
    required double confidence,
  }) async {
    final prompt = getBloomSummaryPrompt(
      answer: userAnswer,
      userLevel: userLevel,
      predictedLevel: predictedLevel,
      confidence: confidence,
    );
    final result = await geminiB.sendPrompt(prompt);
    return result.trim();
  }
}
