import '../agents/gemini.dart';

class QuestionGenerator {
  final Gemini _gemini = Gemini();

  Future<String> generate({
    required String character,
    required String history,
    required String userInput,
  }) async {
    final prompt = '''
You are an AI tutor roleplaying as "$character", speaking in their tone and personality.

Here is the ongoing English learning conversation:
$history

The user just said: "$userInput"

Now:
1. Briefly acknowledge or respond to the user input.
2. Add one sentence of natural, friendly continuation to keep the conversation smooth.
3. End with a short, Bloom's Taxonomy-style question (Analyze / Evaluate / Create level) to prompt deeper thinking.

Respond as ONE complete message that flows naturally (not bullet points).  
Keep it under 40 words total.  
Do NOT mention Bloom's Taxonomy in the message.

Example format:
"That's a great point. I often feel the same. So what would you change if you had the chance?"

Now generate your reply.
''';

    return await _gemini.sendPrompt(prompt);
  }
}
