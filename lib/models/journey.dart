import 'package:app_situational_coach/models/day.dart';
import 'package:app_situational_coach/models/status.dart';

class Journey {
  final String id;
  final String name; // 使用者對於旅行的取名
  final int day; // 使用者希望的旅行天數
  final String character;
  final String description; // 使用者希望的旅行地點、內容
  final String learningGoal; // 使用者希望的學習內容
  final List<Day> schedule;
  int bloomLevel; // 使用者在這個旅行中的bloom等級 預設每個旅程的bloom不同
  JourneyStatus status;

  // 沒用dummy data的話可以用這個
  // Journey({
  //   required this.id,
  //   required this.name,
  //   required this.day,
  //   required this.character,
  //   required this.description,
  //   required this.learningGoal,
  //   required this.schedule,
  //   JourneyStatus? status,
  // }) : status = JourneyStatus();

  Journey({
    required this.id,
    required this.name,
    required this.day,
    required this.character,
    required this.description,
    required this.learningGoal,
    required this.schedule,
    required this.bloomLevel,
    required this.status,
  });
}
