import 'package:flutter/material.dart';
import '../models/message.dart';

class ConversationNotifier extends ChangeNotifier {
  final List<Message> _messages = [];

  List<Message> get messages => List.unmodifiable(_messages);

  void addUserMessage(String content) {
    _messages.add(Message(speaker: 'user', content: content));
    notifyListeners();
  }

  void addAiMessage(String content) {
    _messages.add(Message(speaker: 'ai', content: content));
    notifyListeners();
  }

  void clear() {
    _messages.clear();
    notifyListeners();
  }
}
