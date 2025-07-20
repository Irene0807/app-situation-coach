import 'package:app_situational_coach/models/scene.dart';

class Day {
  final String title;       //給user看的 這一天的旅行名稱
  final List<Scene> scenes;

  Day({
    required this.title,
    required this.scenes,
  });
}
