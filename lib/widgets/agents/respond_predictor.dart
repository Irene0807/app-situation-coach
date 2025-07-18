import '../agents/gemini.dart';


class RespondPredictor {
  final Gemini _gemini = Gemini();

  Future<String> predict({
    required String question,
    required String character,
    required String history,
  }) async {
    final prompt = '''
The following is a language learning conversation between a user and an AI tutor.

The AI (in character as "$character") just asked this question:
"$question"

Based on the conversation so far:
$history

Predict how a typical English learner might respond in one sentence.
Keep it simple, relevant, and natural.
''';

    return await _gemini.sendPrompt(prompt);
  }
}
