import 'dart:convert';
import 'package:http/http.dart' as http;

/*
這裡定義 class Gemini
  - 負責與 Gemini API 溝通，單純發送提示並取得回應
  - [gemini_api.dart] 呼叫這裡: final geminiA = Gemini(API_KEY);
    (可以在gemini_api.dart裡面選擇要用哪個key的Gemini)
*/

class GeminiAuto {
  final List<String> apiKeys;
  int _index = 0;

  GeminiAuto(this.apiKeys);

  Future<String> sendPrompt(String prompt) async {
    for (int i = 0; i < apiKeys.length; i++) {
      final key = apiKeys[_index];
      final gemini = Gemini(key);
      try {
        return await gemini.sendPrompt(prompt);
      } catch (e) {
        if (e.toString().contains('503')) {
          print('[WARN] Key $_index 503, switching to next...');
          _index = (_index + 1) % apiKeys.length;
          await Future.delayed(const Duration(milliseconds: 200));
        } else {
          rethrow;
        }
      }
    }
    throw Exception("All keys failed for this Gemini instance.");
  }
}

class Gemini {
  final String apiKey;

  Gemini(this.apiKey);
  

  Future<String> sendPrompt(String promptText, {String model = 'gemini-2.5-flash'}) async {
    print('[DEBUG] Sending request using key: ${this.apiKey}');
    
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1/models/$model:generateContent?key=$apiKey',
    );

    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": promptText}
          ]
        }
      ]
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final reply = decoded['candidates'][0]['content']['parts'][0]['text'];
      return reply;
    } else {
      throw Exception('Error: ${response.statusCode}\n${response.body}');
    }
  }
}
