// [RESPONSE GENERATOR]
// generator -> prompt & gemini

import 'prompts/response_prompt.dart';
import 'gemini_instance.dart';
import '../../models/scene.dart';
import '../../models/message.dart';

// 根據scene.dart，ConversationContent包含script, message
class ResponseGenerator {
  final ConversationContent conversation;

  ResponseGenerator({required this.conversation});

  Future<String> generateResponse(String userInput, {bool isFinalRound = false}) async {
    final prompt = buildResponsePrompt(
      script: conversation.script,
      userInput: userInput,
      history: conversation.messages,
      isFinalRound: isFinalRound,
    );
    print('[PROMPT SENT] $prompt');

    final response = await geminiB.sendPrompt(prompt);
    
    conversation.messages.add(Message(role: 'user', content: userInput));
    conversation.messages.add(Message(role: 'ai', content: response));

    return response;
  }
}
