class Question {
  final String questionText;
  final List<String> options; // 基本上就是4個選項 
  final int answerId; // 0, 1, 2, 3 對應選項的index

  Question({
    required this.questionText,
    required this.options,
    required this.answerId,
  });
}
