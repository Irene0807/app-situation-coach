// [SCRIPT GENERATOR] - 5 BLOOM EVALUATOR - 5 BLOOM PROMPT

String getBloomBroadPrompt(String answer) {
  return '''
Evaluate the following answer using Bloom's Taxonomy.

Answer:
"$answer"

Classify the cognitive level broadly:
- HIGH: if it shows Analyze, Evaluate, or Create
- LOW: if it shows Remember, Understand or Apply

Reply ONLY with: HIGH or LOW
''';
}

String getBloomPrecisePrompt(String broadClass, String answer) {
  return '''
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
}

String getBloomDirectPrompt(String answer) {
  return '''
You are a Bloom's Taxonomy expert.
Analyze this answer:
"$answer"

1. Assign it a level from 1 to 6
2. Provide one sentence of helpful feedback for improvement

Format:
Level: <1~6>
Feedback: <suggestion>
''';
}

String getBloomSummaryPrompt({
  required String answer,
  required double userLevel,
  required int predictedLevel,
  required double confidence,
}) {
  return '''
You are an expert in evaluating educational dialogues based on Bloom's Taxonomy (levels 1–6).
A language learning AI generated the following user response:

--- User Response ---
$answer
---------------------

This response was evaluated as **Level $predictedLevel**, while the user's current Bloom level is $userLevel.
The evaluator's confidence is ${confidence.toStringAsFixed(2)}.

It means that the question was likely too easy or too hard for the user, can hardly improve their progress in Bloom's Taxonomy.
You must now provide constructive feedback to help the system improve the next question it generates.

Your task:
- Suggest 1–2 simple ways to improve the next question to help the user think deeper (e.g., analyze, compare, or create).

Keep it short but informative.
''';
}

