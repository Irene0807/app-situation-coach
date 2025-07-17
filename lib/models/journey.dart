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
