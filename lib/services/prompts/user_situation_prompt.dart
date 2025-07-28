// [SCRIPT GENERATOR] - 2 USER SITUATION PREDICTOR - 2 USER SITUATION PROMPT

String getUserSituationPrompt({
  required String theme,
  required String topic,
  required int bloomLevel,
}) {
  return '''
You are simulating a language learner's possible utterance in an English learning scene.

Theme: $theme  
Topic: $topic  
Learner's current Bloom level: $bloomLevel

Based on this situation, generate **one natural English sentence** the learner might say.  
Do NOT include explanations.  
Do NOT mention Bloom's Taxonomy.

Output only the learner's sentence.
''';
}
