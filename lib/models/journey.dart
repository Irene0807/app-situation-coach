class Journey {
  final String id;
  final String name;
  final String character;
  final bool isCompleted;

  Journey({
    required this.id,
    required this.name,
    required this.character,
    this.isCompleted = false,
  });
}
