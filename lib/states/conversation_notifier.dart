import 'package:flutter/material.dart';
import '../models/message.dart';

// 這個東西看起來沒用到?
// message現在完全鎖在ResponseGenerator裡面 看要不要放到scene裡?

class ConversationNotifier extends ChangeNotifier {
  final List<Message> _messages = [];

  List<Message> get messages => List.unmodifiable(_messages);

  List<String> get userMessages =>
      _messages.where((m) => m.role == 'user').map((m) => m.content).toList();

  void addUserMessage(String content) {
    _messages.add(Message(role: 'user', content: content));
    notifyListeners();
  }

  void addAiMessage(String content) {
    _messages.add(Message(role: 'ai', content: content));
    notifyListeners();
  }

  void clear() {
    _messages.clear();
    notifyListeners();
  }
}
