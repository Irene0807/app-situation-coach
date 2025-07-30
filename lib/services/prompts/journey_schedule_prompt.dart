// // [JOURNEY GENERATOR] - JOURNEY SCHEDULE PROMPT

import 'package:app_situational_coach/models/day.dart';
import 'package:app_situational_coach/models/scene.dart';

// prompt有可能獲取錯誤資料 造成parse時出現bug 需要注意

class PromptJourneySchedule {
  String getJourneySchedulePrompt(
      String name, int day, String character, String description, String goal) {
    return '''
You are a travel and English learning content designer.

Based on the given journey plan, generate a detailed journey schedule for the user.
This schedule helps improve the user's English skills through practical experiences.

The schedule must strictly follow this format for each day:

<<Title of day 1, do not include the words "day 1">>
<<Number of scene in day 1, only output a number (e.g., 2, 3, or 4)>>

<<Title of scene 1>>
<<The location of scene 1>>
<<Description of scene 1: describe the main activity and what the user does>>
<<Learning theme: explain what kind of English skill the user will focus on in this scene>>

<<Title of scene 2>>
<<The location of scene 2>>
<<Description of scene 2: describe the main activity and what the user does>>
<<Learning theme: explain what kind of English skill the user will focus on in this scene>>

...

<<Title of day 2, do not include the words "day 2">>
<<Number of scene in day 2, only output a number>>
...

Use friendly and clear language, and make sure the content is:
- Practical and realistic (avoid fantasy or unrelated content unless the companion is magical)
- Focused on English learning through activities (e.g., shopping, ordering food, asking directions, talking to locals)
- Each day must include 2 to 4 scenes
- Each scene should be distinct and meaningful, not filler

Here is the journey plan:

Journey name:        $name
Number of days:      $day
Journey companion:   $character
Journey description: $description
Learning goals:      $goal

The output must strictly use the << >> brackets for all content sections as shown.
''';
  }

  List<String> extractItems(String text) {
    final RegExp pattern = RegExp(r'<<\s*(.*?)\s*>>');
    return pattern
        .allMatches(text)
        .map((match) => match.group(1)!.trim())
        .toList();
  }

  List<Day>? parseSchedule(String scheduleText, int day) {
    final List<String> items = extractItems(scheduleText);
    List<Day> schedule = [];

    int i = 0;
    final itemNum = items.length;
    while (i < itemNum) {
      String title = items[i++];
      final sceneNum = int.tryParse(items[i++]);
      if (sceneNum == null) {
        return null;
      }
      List<Scene> scenes = [];
      for (int j = 0; j < sceneNum; j++) {
        Scene s = Scene(
          title: items[i++],
          location: items[i++],
          description: items[i++],
          learningTheme: items[i++],
        );
        scenes.add(s);
      }
      schedule.add(Day(title: title, scenes: scenes));
    }

    if (i != itemNum || schedule.length != day) {
      // throw Exception('getOrderedSchedule error\n');
      return null;
    }

    return schedule;
  }
}
