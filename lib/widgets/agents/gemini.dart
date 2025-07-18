import 'dart:convert';
import 'package:http/http.dart' as http;

class Gemini {
  final String _apiKey = 'AIzaSyABkzI_k_tcCuPdBve695o8MPgnO_vANmA';

  Future<String> sendPrompt(String promptText) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$_apiKey',
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
