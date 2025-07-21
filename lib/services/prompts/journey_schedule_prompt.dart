// // [JOURNEY GENERATOR] - JOURNEY SCHEDULE PROMPT

import 'package:app_situational_coach/models/day.dart';
import 'package:app_situational_coach/models/scene.dart';

// prompt有可能獲取錯誤資料 造成parse時出現bug 需要注意

class PromptJourneySchedule {
  String getJourneySchedulePrompt(String plan) {
    return '''
Help me generate a detailed journey schedule based on the journey plan:

$plan

The journey schedule should follow this format:

<<Title of day 1, do not put "day 1" in the title>>
<<Number of scene in day 1, output containing only number, example: 2, 3, 4>> 

<<Title of scene 1, do not put "scene 1" in the title>>
<<The location of the scene 1>>
<<The learning theme related to English of the scene 1>>
<<The dialogue topic in the scene 1>>

<<Title of scene 2, do not put "scene 2" in the title>>
<<The location of the scene 2>>
<<The learning theme related to English of the scene 2>>
<<The dialogue topic in the scene 2>>

<<Title of day 2, do not put "day 2" in the title>>
<<Number of scene in day 2, output containing only number, example: 2, 3, 4>> 

...

Tips:
- The sentences in the brackets <<>> should be replaced with the actual content.
- Each day should have 2 to 4 scenes.
''';
  }

  List<String> extractItems(String text) {
    final RegExp pattern = RegExp(r'<<\s*(.*?)\s*>>');
    return pattern
        .allMatches(text)
        .map((match) => match.group(1)!.trim())
        .toList();
  }

  List<Day> getOrderedSchedule(String scheduleText) {
    final List<String> items = extractItems(scheduleText);
    List<Day> schedule = [];

    int i = 0;
    final itemNum = items.length;
    while (i < itemNum) {
      String title = items[i++];
      int sceneNum = int.parse(items[i++]);
      List<Scene> scenes = [];
      for (int j = 0; j < sceneNum; j++) {
        Scene s = Scene(
            title: items[i++],
            location: items[i++],
            learningTheme: items[i++],
            dialogueTopic: items[i++]);
        scenes.add(s);
      }
      schedule.add(Day(title: title, scenes: scenes));
    }

    if (i != itemNum) {
      throw Exception('getOrderedSchedule error\n');
    }

    return schedule;
  }
}
