import 'dart:convert';
import 'package:http/http.dart' as http;

/*
這裡定義 class Gemini
  - 負責與 Gemini API 溝通，單純發送提示並取得回應
  - [gemini_api.dart] 呼叫這裡: final geminiA = Gemini(API_KEY);
    (可以在gemini_api.dart裡面選擇要用哪個key的Gemini)
*/

class Gemini {
  final String apiKey;

  Gemini(this.apiKey);
  

  Future<String> sendPrompt(String promptText, {String model = 'gemini-1.5-flash'}) async {
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

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final reply = decoded['candidates'][0]['content']['parts'][0]['text'];
        return reply;
      } else {
        return 'Error: ${response.statusCode}\n${response.body}';
      }
    } catch (e) {
      return 'Exception: $e';
    }
  }
}
