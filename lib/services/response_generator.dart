// [RESPONSE GENERATOR]
// generator -> prompt & gemini

import 'prompts/response_prompt.dart';
import 'gemini_instance.dart';
import '../models/scene.dart';
import '../models/message.dart';

// 根據scene.dart，ConversationContent包含script, message
class ResponseGenerator {
  final ConversationContent conversation;

  ResponseGenerator({required this.conversation});

  Future<String> generateResponse(String userInput) async {
    final prompt = buildResponsePrompt(
      script: conversation.script,
      userInput: userInput,
      history: conversation.messages,
    );

    final response = await geminiA.sendPrompt(prompt);
    
    conversation.messages.add(Message(role: 'user', content: userInput));
    conversation.messages.add(Message(role: 'ai', content: response));

    return response;
  }
}
