class Message {
  final String speaker; // 'user' or 'ai'
  final String content;
  final DateTime timestamp;

  Message({
    required this.speaker,
    required this.content,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}