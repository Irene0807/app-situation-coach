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
  final Random _random = Random();
  DateTime _lastRequestTime = DateTime.fromMillisecondsSinceEpoch(0);

  GeminiAuto(this.apiKeys);

  // 隨機取一個起始 index
  int _pickRandomIndex() => _random.nextInt(apiKeys.length);

  // 正常對話版 gemini
  Future<String> sendPrompt(
    String prompt, {
    String model = 'gemini-2.5-flash',
    int max503Retries = 1, // 503 超過1次就 fallback
  }) async {
    int start = _pickRandomIndex();
    int error503Count = 0; // 算 503 次數

    for (int i = 0; i < apiKeys.length; i++) {
      final key = apiKeys[(start + i) % apiKeys.length];
      try {
        print('[DEBUG] sendPrompt using key: $key (model=$model)');
        // ---- 節流：確保兩次請求間隔 >= 500ms ----
        final now = DateTime.now();
        final diff = now.difference(_lastRequestTime);
        if (diff.inMilliseconds < 500) {
          final wait = 500 - diff.inMilliseconds;
          print('[INFO] Throttling: wait ${wait}ms before next request');
          await Future.delayed(Duration(milliseconds: wait));
        }
        _lastRequestTime = DateTime.now();

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
        } else if (response.statusCode == 429) {
          // 429: quota爆 換key
          print('[WARN] 429 quota exceeded, switching key...');
          continue;
        } else if (response.statusCode == 503) {
          // 503: service unavailable 累積cnt
          error503Count++;
          print('[WARN] 503 service unavailable (count=$error503Count)');
          await Future.delayed(const Duration(seconds: 1));

          if (error503Count >= max503Retries) {
            // fallback 到另一個 model
            final fallbackModel = 'gemini-1.5-flash';
            print('[INFO] Too many 503 errors, switching to $fallbackModel');
            return sendPrompt(prompt, model: fallbackModel);
          }
          continue; // 換 key 重試
        } else {
          throw Exception('Error: ${response.statusCode}');
        }
      } catch (e) {
        print('[WARN] sendPrompt key failed: $e');
        await Future.delayed(const Duration(milliseconds: 200));
      }
    }
    throw Exception("All keys failed for sendPrompt (model=$model)");
  }


  // Embedding 版 gemini
  Future<List<double>> getEmbedding(String text, {String model = 'models/text-embedding-004'}) async {
    int start = _pickRandomIndex();
    
    for (int i = 0; i < apiKeys.length; i++) {
      final key = apiKeys[(start + i) % apiKeys.length];
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
        print('[WARN] getEmbedding key failed: $e');
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

