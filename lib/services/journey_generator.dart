// [JOURNEY GENERATOR]
// generator -> prompt & gemini

import 'package:app_situational_coach/models/day.dart';
import '../services/gemini_instance.dart';
import 'prompts/journey_plan_prompt.dart';
import 'prompts/journey_schedule_prompt.dart';

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
  Future<Map<String, String>> generateJourneyPlan(String userInput) async {
    // 把使用者的原prompt轉乘plan
    PromptJourneyPlan p = PromptJourneyPlan();
    final prompt = p.getJourneyPlanPrompt(userInput);
    final planText = await geminiA.sendPrompt(prompt);
    final plan = p.parsePlan(planText);
    return plan;
  }

  Future<List<Day>> generateJourneySchedule(String plan) async {
    // 透過經使用者修改過後的plan生成schedule
    PromptJourneySchedule p = PromptJourneySchedule();
    final prompt = p.getJourneySchedulePrompt(plan);
    final scheduleText = await geminiA.sendPrompt(prompt);
    final schedule = p.getOrderedSchedule(scheduleText);
    return schedule;
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
