import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';

/*
這裡定義 class Gemini
  - 負責與 Gemini API 溝通，單純發送提示並取得回應
  - [gemini_api.dart] 呼叫這裡: final geminiA = Gemini(API_KEY);
    (可以在gemini_api.dart裡面選擇要用哪個key的Gemini)
*/

// Gemini 分成： 1 正常對話版, 2 Embedding 版

class GeminiAuto {
  final List<String> apiKeys;
  int _index = 0;

  GeminiAuto(this.apiKeys);

  // 正常對話版 gemini
  Future<String> sendPrompt(String prompt, {String model = 'gemini-2.5-flash'}) async {
    for (int i = 0; i < apiKeys.length; i++) {
      final key = apiKeys[_index];
      try {
        print('[DEBUG] sendPrompt using key: $key');

        final url = Uri.parse(
          'https://generativelanguage.googleapis.com/v1/models/$model:generateContent?key=$key',
        );

        final headers = {'Content-Type': 'application/json'};
        final body = jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ]
        });

        final response = await http.post(url, headers: headers, body: body);

        if (response.statusCode == 200) {
          final decoded = jsonDecode(response.body);
          return decoded['candidates'][0]['content']['parts'][0]['text'];
        } else {
          throw Exception('Error: ${response.statusCode}');
        }
      } catch (e) {
        print('[WARN] sendPrompt key $_index failed: $e');
        _index = (_index + 1) % apiKeys.length;
        await Future.delayed(const Duration(milliseconds: 200));
      }
    }
    throw Exception("All keys failed for sendPrompt");
  }

  // Embedding 版 gemini
  Future<List<double>> getEmbedding(String text, {String model = 'models/text-embedding-004'}) async {
    for (int i = 0; i < apiKeys.length; i++) {
      final key = apiKeys[_index];
      try {
        print('[DEBUG] getEmbedding using key: $key');

        final url = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/$model:embedContent?key=$key',
        );

        final headers = {'Content-Type': 'application/json'};
        final body = jsonEncode({
          "model": model,
          "content": {"parts": [{"text": text}]}
        });

        final response = await http.post(url, headers: headers, body: body);
        if (response.statusCode == 200) {
          final decoded = jsonDecode(response.body);
          return decoded['embedding']['values'].cast<double>();
        } else {
          throw Exception('Error: ${response.statusCode}');
        }
      } catch (e) {
        print('[WARN] getEmbedding key $_index failed: $e');
        _index = (_index + 1) % apiKeys.length;
        await Future.delayed(const Duration(milliseconds: 200));
      }
    }
    throw Exception("All keys failed for getEmbedding");
  }
}

/// ---- Cosine Similarity ----
double cosineSim(List<double> a, List<double> b) {
  if (a.length != b.length) throw Exception("Embedding length mismatch");
  double dot = 0, normA = 0, normB = 0;
  for (int i = 0; i < a.length; i++) {
    dot += a[i] * b[i];
    normA += a[i] * a[i];
    normB += b[i] * b[i];
  }
  return dot / (sqrt(normA) * sqrt(normB));
}

