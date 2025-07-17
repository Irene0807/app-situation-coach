import 'dart:convert';
import 'package:http/http.dart' as http;
import 'gemini_api.dart';
import '../services/prompt/journey_plan_generator.dart';
import '../services/prompt/journey_schedule_generator.dart';
import '../services/prompt/dialogue_script_generator.dart';
import '../models/journey.dart';

/*
以下簡單說明旅行的生成過程:
  1. 使用者會先輸入一組簡單的prompt

  2. 根據該prompt 會重複數次 生成plan
    (補充: 可以把plan理解成更細緻的prompt 它會描述旅行的地點、天數、景點等 比照使用者的原prompt)
    (目的: 更加精確地描述出使用者的旅程需求)

  3. 將該plan傳給使用者 使用者可以直接修改它 或是 捨棄該plan回到步驟一

  4. 該plan符合使用者需求後 根據它生成schedule
    (注意: 使用者無法看到該schedule)
*/

// 目前設計: 旅行開始前只會生成大概的schedule 在進入每個場景前再生成該場景的腳本對話

class JourneyGenerator {
  // 提問 Gemini API
  Future<String> askGemini(String prompt) async {
    const String endpoint =
        'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent';

    final uri = Uri.parse('$endpoint?key=$API_KEY');
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    // The request body according to the API spec
    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ]
    });

    try {
      final http.Response response = await http.post(
        uri,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final candidates = jsonResponse['candidates'] as List?;
        final content = candidates?[0]?['content']?['parts']?[0]?['text'] ?? '';
        return content;
      } else {
        throw Exception('Failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Handle errors as needed in your app
      rethrow;
    }
  }

  Future<String> generateJourneyPlan(String userInput) async {
    // 把使用者的原prompt轉乘plan
    final prompt = getJourneyPlanGeneratorPrompt(userInput);
    final journeyPlan = askGemini(prompt);
    return journeyPlan;
  }

  Future<String> generateJourneySchedule(String plan) async {
    // 透過經使用者修改過後的plan生成schedule
    final prompt = getJourneyScheduleGeneratorPrompt(plan);
    final journeySchedule = askGemini(prompt);
    return journeySchedule;
  }

  Future<String> generateDialogueScript(Journey journey) async {
    // 在進入場景前 根據journey生成某scene的script
    final prompt = getDialogueScriptGeneratorPrompt(journey);
    final dialogueScript = askGemini(prompt);
    return dialogueScript;
  }
}

/*

user's prompt example:
"
  我想去日本旅遊，計劃為期7天，包含東京和京都的主要景點。
"

journey plan example:
"
  (旅行名稱)
    日式文化探索之旅：東京與京都的七日冒險

  (旅行天數)
    7天

  (旅伴)
    川普

  (旅行內容)
    此行將造訪日本兩大代表城市──東京與京都。
    以下是旅行中將涵蓋的主要地點與活動
      東京：淺草雷門、晴空塔、澀谷、新宿、原宿
      京都：伏見稻荷大社、金閣寺、祇園、傳統和服體驗

  (學習目標)
    學習基本的日常交流用語
    理解日本文化與禮儀
"

journey schedule example:
"
  (第一天) 抵達東京：啟程與初體驗
    (場景一) 機場入境
      (地點) 日本成田機場
      (主題) 機場英語
      (對話內容) 入境問答、詢問行李轉盤位置

    (場景二) 飯店Check-in
      (地點) 淺草地區飯店
      (主題) 住宿英語
      (對話內容) 報到入住、確認預訂、要求備品

    (場景三) 晚餐初體驗
      (地點) 居酒屋
      (主題) 餐廳英語
      (對話內容) 點餐、詢問推薦、了解特色料理

  (第二天)

  ...

"

dialogue script example:
"
  
"

*/
