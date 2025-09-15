import 'package:app_situational_coach/models/question.dart';
import 'package:app_situational_coach/models/scene.dart';
import 'dart:math';

// 丟intro進來了

class PromptTest {
  String getTestPrompt(
    Scene scene, {
    List<String> introVocabulary = const [],
  }) {
    // 抽 5 個單字
    final random = Random();
    final vocabSample = introVocabulary.toList();
    vocabSample.shuffle(random);
    final selected = vocabSample.take(5).toList();

    final vocabHint = selected.isNotEmpty
        ? "Focus ONLY on these vocabulary words when making questions: ${selected.join(', ')}."
        : "No vocabulary words were provided, use the learning theme.";
    return '''
You are an English learning assistant.
The journey has just ended. Now your job is to help the user review their vocabulary through a short quiz.

Here is the journey information:

Location: ${scene.location}  
Description: ${scene.description}  
Learning Theme: ${scene.learningTheme}  

$vocabHint

Your task:
- Write a short friendly summary (2–3 sentences) to the traveler, reminding them what they experienced and telling them about the quiz.
- Create 6 to 8 multiple-choice vocabulary questions based on the scene and learning theme.

Output Format (must follow this strictly):

<<Short summary to the traveler and introduce the vocabulary test, within 50 words>>

<<Question 1 text>>
<<Option 0, description of option 0>>
<<Option 1, description of option 1>>
<<Option 2, description of option 2>>
<<Option 3, description of option 3>>
<<Correct answer index, must be 0, 1, 2, or 3>>

<<Question 2 text>>
<<Option 0, description of option 0>>
<<Option 1, description of option 1>>
<<Option 2, description of option 2>>
<<Option 3, description of option 3>>
<<Correct answer index>>

...

Output Rules:
- All content must be enclosed in double angle brackets (<< >>)
- Each question must include exactly 4 options
- Only one correct answer per question, indicated as a number 0, 1, 2, or 3 in the last line
- Questions must focus on vocabulary understanding (meanings or usage), not grammar
- Options should be logically distinct (avoid overlaps or trick options)
- Use vocabulary that appeared in or is relevant to the journey
''';
  }

  SummaryContent? parseSummaryContent(String input) {
    final RegExp tagExp = RegExp(r'<<([^<>]+)>>');
    final matches = tagExp.allMatches(input).toList();

    if (matches.isEmpty) {
      // throw FormatException("No content found between <<>>");
      return null;
    }

    // 取第一個是 summary
    final summary = matches[0].group(1)!;

    // 後續每6個為一題
    final List<Question> questions = [];
    for (int i = 1; i + 5 < matches.length; i += 6) {
      final questionText = matches[i].group(1)!;
      final options = List.generate(4, (j) => matches[i + 1 + j].group(1)!);
      final answerId = int.tryParse(matches[i + 5].group(1)!);
      if (answerId == null || answerId < 0 || answerId > 3) {
        // throw FormatException(
        //     "Invalid answer id at question ${questions.length + 1}");
        return null;
      }

      questions.add(Question(
        questionText: questionText,
        options: options,
        answerId: answerId,
      ));
    }

    return SummaryContent(summary: summary, questions: questions);
  }
}
