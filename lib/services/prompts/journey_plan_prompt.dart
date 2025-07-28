// [JOURNEY GENERATOR] - JOURNEY PLAN PROMPT

// 本來在猶豫要不要開class 後來覺得相關的parsing function還是放一起比較好

class PromptJourneyPlan {
  String getJourneyPlanPrompt(String userInput) {
    return '''
You are an expert travel planner and English learning assistant.
Based on the user's input, generate a fictional journey plan that helps the user improve their English skills.
If the user's input is empty or null, create a random journey.

The journey plan must follow the exact format below.
Replace all text inside << >> with relevant content, but preserve the angle brackets.

Journey Format:

<<Journey Name>>

<<Number of Days, contains only numbers>>

<<Companion, only one person, choose from: Trump, TOEFL Interviewer, American kid, England kid, Harry Potter>>

<<Simple description of the journey: include only key locations and activities, avoid detailed explanations or daily schedules>>

<<Learning goals: describe how the journey helps improve English, such as vocabulary focus, speaking practice, listening to different accents, cultural understanding, etc.>>

User Input:

$userInput

Make the tone friendly and imaginative, but keep the structure strictly in the format above.
''';
  }

  Map<String, String> parsePlan(String input) {
    final RegExp tagExp = RegExp(r'<<([^<>]+)>>');
    final matches = tagExp.allMatches(input).toList();

    if (matches.length != 5) {
      throw FormatException(
          "Expected exactly 5 <<>> sections, but found ${matches.length}.");
    }

    final keys = ['name', 'day', 'character', 'description', 'goal'];
    final Map<String, String> result = {};

    for (int i = 0; i < keys.length; i++) {
      result[keys[i]] = matches[i].group(1)!.trim();
    }

    return result;
  }
}
