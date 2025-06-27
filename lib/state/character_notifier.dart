import 'package:flutter/material.dart';

class CharacterNotifier extends ChangeNotifier {
  String? _selectedCharacter;

  String? get selectedCharacter => _selectedCharacter;

  void selectCharacter(String name) {
    _selectedCharacter = name;
    notifyListeners();
  }

  void reset() {
    _selectedCharacter = null;
    notifyListeners();
  }
}