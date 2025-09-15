import 'gemini_instance.dart';
import '../../models/message.dart';
import 'prompts/bloom_prompt.dart';

//小投機 直接用bloomC direct判斷bloom等級，不然等bllomA/B/C判完(不相同還要重判)太久了

class BloomSceneEvaluator {
  /// 計算整個 Scene 的 Bloom Level
  Future<int> evaluateSceneBloomLevel({
    required int currentSceneIndex,
    required List<Message> messages,
  }) async {
    // 前兩個 scene 固定 = 1
    if (currentSceneIndex <= 1) {
      return 1;
    }

    // 串起所有使用者回答
    final userDialogue = messages
        .where((m) => m.role == 'user')
        .map((m) => m.content.trim())
        .where((c) => c.isNotEmpty)
        .join("\n");

    if (userDialogue.isEmpty) return 1;

    // 用現成的 Direct Prompt
    final prompt = getBloomDirectPrompt(userDialogue);
    final response = await geminiA.sendPrompt(prompt);

    // 解析回傳的 Level
    final match = RegExp(r'Level:\s*([1-6])').firstMatch(response);
    final level = int.tryParse(match?.group(1) ?? "1") ?? 1;

    print("[DEBUG] BloomSceneEvaluator Level = $level");

    return level.clamp(1, 6);
  }
}
