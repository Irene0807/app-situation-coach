import '../agents/gemini.dart';

class BloomEvaluationResult {
  final int level; 
  final double confidence;
  final String feedback;

  BloomEvaluationResult({
    required this.level,
    required this.confidence,
    required this.feedback,
  });
}

class BloomEvaluator {
  final Gemini _gemini = Gemini();

  Future<BloomEvaluationResult> evaluate(String answer) async {
    // Agent A: High / Low
    final promptA = '''
Evaluate the following answer using Bloom's Taxonomy.

Answer:
"$answer"

Classify the cognitive level broadly:
- HIGH: if it shows Analyze, Evaluate, or Create
- LOW: if it shows Remember, Understand or Apply

Reply ONLY with: HIGH or LOW
''';

    final resultA = await _gemini.sendPrompt(promptA);
    final broadClass = resultA.trim().toUpperCase().contains('HIGH') ? 'HIGH' : 'LOW';

    // Agent B: get Agent A -> Level 1-6
    final promptB = '''
The previous answer was broadly classified as "$broadClass".

Now, classify it more precisely using Bloom’s 6 levels:
1. Remember
2. Understand
3. Apply
4. Analyze
5. Evaluate
6. Create

Reply ONLY with one number from 1 to 6 that best fits the answer:
"$answer"
''';

    final resultB = await _gemini.sendPrompt(promptB);
    final levelB = int.tryParse(RegExp(r'[1-6]').stringMatch(resultB) ?? '') ?? 1;

    // Agent C: Independent judgment + feedback
    final promptC = '''
You are a Bloom's Taxonomy expert.
Analyze this answer:
"$answer"

1. Assign it a level from 1 to 6
2. Provide one sentence of helpful feedback for improvement

Format:
Level: <1~6>
Feedback: <suggestion>
''';

    final resultC = await _gemini.sendPrompt(promptC);
    final levelMatchC = RegExp(r'Level:\s*([1-6])').firstMatch(resultC);
    final feedbackMatch = RegExp(r'Feedback:\s*(.*)').firstMatch(resultC);

    final levelC = int.tryParse(levelMatchC?.group(1) ?? '') ?? 1;
    final feedback = feedbackMatch?.group(1) ?? 'No feedback.';

    // summarize
    double confidence = 0.3;
    if (levelB == levelC) {
      confidence = 1.0;
    } else if ((levelB - levelC).abs() == 1) {
      confidence = 0.7;
    } else {
      confidence = 0.4;
    }

    // 現在是以使用 C 的 level 為主
    return BloomEvaluationResult(
      level: levelC,
      confidence: confidence,
      feedback: feedback,
    );
  }
}
