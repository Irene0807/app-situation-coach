// [RESPONSE GENERATOR]
// generator -> prompt & gemini

import 'prompts/response_prompt.dart';
import 'gemini_instance.dart';
import 'script_generator.dart';
import '../models/message.dart';

class ResponseGenerator {
  final String script;
  final List<Message> history;

  ResponseGenerator({required this.script, required this.history});

  Future<String> generateResponse(String userInput) async {
    final prompt = buildResponsePrompt(
      script: script,
      userInput: userInput,
      history: history,
    );

    final response = await geminiA.sendPrompt(prompt);
    
    history.add(Message(role: 'user', content: userInput));
    history.add(Message(role: 'ai', content: response));

    return response;
  }
}
