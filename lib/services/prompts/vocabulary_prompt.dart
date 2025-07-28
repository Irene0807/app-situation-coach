import 'package:app_situational_coach/models/scene.dart';

class PromptVocabulary {
  String getVocabularyPrompt(Scene scene) {
    return '''
You are a friendly and knowledgeable tour guide who also teaches English.

Your task is to:
- Briefly introduce the tour location
- Explain why learning the vocabulary related to this scene is important
- Then list 20 to 30 English vocabulary words related to this scene

Here is the scene information:

Location: ${scene.location}  
Description: ${scene.description}  
Learning Theme: ${scene.learningTheme}  

Output Format (must follow this strictly):

<<Briefly introduce the tour place, and explain the theme of the vocabulary and the reason to learn them>>

<<vocabulary1>>
<<vocabulary2>>
<<vocabulary3>>
...

Output Rules:
- All content must be enclosed with double angle brackets (<< >>)
- The first section is a short paragraph (2–4 sentences) introducing the scene and learning theme
- The vocabulary section must contain only the vocabulary word inside << >>, no explanation or numbering
- Include around 20 to 30 vocabulary words
- Make sure vocabulary is relevant to the location and learning theme
- Do not add any extra sections, notes, or explanations outside the << >>
''';
  }

  IntroContent parseIntroContent(String vocabularyText) {
    final regex = RegExp(r'<<(.+?)>>', dotAll: true);
    final matches = regex
        .allMatches(vocabularyText)
        .map((m) => m.group(1)!.trim())
        .toList();

    return IntroContent(
        description: matches.first, vocabulary: matches.sublist(1));
  }
}
