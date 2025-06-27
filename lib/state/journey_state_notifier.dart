import 'package:flutter/material.dart';

class JourneyStateNotifier extends ChangeNotifier {
  int _currentDay = 0;
  int _currentScene = 0;

  int get currentDay => _currentDay;
  int get currentScene => _currentScene;

  void goToNextScene() {
    _currentScene++;
    notifyListeners();
  }

  void goToNextDay() {
    _currentDay++;
    _currentScene = 0;
    notifyListeners();
  }

  void reset() {
    _currentDay = 0;
    _currentScene = 0;
    notifyListeners();
  }

  void setScene(int scene) {
    _currentScene = scene;
    notifyListeners();
  }

  void setDay(int day) {
    _currentDay = day;
    _currentScene = 0;
    notifyListeners();
  }
}