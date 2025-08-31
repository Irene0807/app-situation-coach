import 'package:flutter/material.dart';

// 額外開一個class定義中英文版本 需要知道原因再問我
class LocalizedText {
  final String en; // 英文
  final String zh; // 中文

  const LocalizedText({required this.en, required this.zh});

  String of(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    if (langCode == 'zh') {
      return zh;
    }
    return en;
  }

  // String getByLang(String langCode) {
  //   return langCode == 'zh' ? zh : en;
  // }
}

class Character {
  final LocalizedText name;
  final LocalizedText gender;
  final int age;
  final String imagePath;
  final LocalizedText background;
  final LocalizedText personality;
  final LocalizedText tone;
  final String slogan;

  Character({
    required this.name,
    required this.gender,
    required this.age,
    required this.imagePath,
    required this.background,
    required this.personality,
    required this.tone,
    required this.slogan,
  });
}
