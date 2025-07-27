import 'package:app_situational_coach/models/scene.dart';

class PromptVocabulary {
  String getVocabularyPrompt(Scene scene) {
    return '''
You are a tour guide. You have to introduce the tour place and teach English at the same time.

Location: ${scene.location}

Description: ${scene.description}

Learning Theme: ${scene.learningTheme}

This is the response format:

<<Simply introduce the tour place, and explain the theme of the vocabulary and the reason to learn them>>

<<Vocabulary 1, containing only the vocabulary itself, without explanation>>
<<Vocabulary 2, containing only the vocabulary itself, without explanation>>
<<Vocabulary 3, containing only the vocabulary itself, without explanation>>

...

Tips:
- The sentences in the brackets <<>> should be replaced with the actual content.
- The <<>> should be preserved in the output.
- Each vocabulary should be enclosed with a <<>>
- The number of the vocabularies should be around 20 to 30.

''';
  }

  IntroContent getIntroContent(String vocabularyText) {
    final regex = RegExp(r'<<(.+?)>>', dotAll: true);
    final matches = regex
        .allMatches(vocabularyText)
        .map((m) => m.group(1)!.trim())
        .toList();

    return IntroContent(
        description: matches.first, vocabulary: matches.sublist(1));
  }
}
