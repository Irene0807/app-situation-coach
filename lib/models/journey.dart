class Journey {
  final String id;
  final String name;
  final int day;
  final String character;
  final String description;
  final String learningGoal;
  final Map<String, String> schedule;
  final bool isCompleted;

  Journey({
    required this.id,
    required this.name,
    required this.day,
    required this.character,
    required this.description,
    required this.learningGoal,
    required this.schedule,
    this.isCompleted = false,
  });
}

/*
way to use schedule map:
{
  "day_1/title":            "[Day 1 Title]",
  "day_1/scene_1/title":    "[Scene 1 Title]"
  "day_1/scene_1/location": "[Location]"
  "day_1/scene_1/theme":    "[The learning theme of the scene]"
  "day_1/scene_1/topic":    "[The dialogue topics for the scene]"
}
*/
