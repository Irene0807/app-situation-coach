// [SCRIPT GENERATOR] - 4 USER RESPONSE PREDICTOR - 4 USER RESPONSE PROMPT

String getUserResponsePrompt({
  required String robotMessage,
  required String theme,
  required double bloomLevel,
}) {
  return '''
You are simulating a learner in an English learning conversation.

Theme: $theme  
The AI tutor just asked: "$robotMessage"  
The learner is currently at Bloom's Taxonomy level: $bloomLevel

You are in your Zone of Proximal Development (ZPD), trying to answer questions slightly above your current level.  
Your goal is to attempt deeper thinking and more complex responses than usual, but still stay realistic for your level.

Now, generate a possible response from the learner:
- Use less than 25 words.
- Reflect a thoughtful, slightly stretched attempt (e.g. Analyze / Evaluate / Create level).
- Stay natural, like a real learner trying to improve.

Output only the learner's reply.
''';
}
