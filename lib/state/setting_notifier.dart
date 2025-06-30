import 'package:flutter/material.dart';

enum LoginType {
  google,
  apple,
  guest,
}

class SettingNotifier extends ChangeNotifier {

  String _userName = '';
  String get userName => _userName;
  set userName(String value) {
    _userName = value;
    notifyListeners();
  }

  String _avatarPath = '';
  String get avatarPath => _avatarPath;
  set avatarPath(String value) {
    _avatarPath = value;
    notifyListeners();
  }

  String _nationality = 'Taiwan';
  String get nationality => _nationality;
  set nationality(String value) {
    _nationality = value;
    notifyListeners();
  }

  bool _darkMode = false;
  bool get darkMode => _darkMode;
  set darkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }

  LoginType _loginType = LoginType.guest;
  LoginType get loginType => _loginType;
  set loginType(LoginType value) {
    _loginType = value;
    notifyListeners();
  }

  bool _isVoiceEnabled = true;
  bool get isVoiceEnabled => _isVoiceEnabled;
  set isVoiceEnabled(bool value) {
    _isVoiceEnabled = value;
    notifyListeners();
  }

  double _speechSpeed = 1.0;
  double get speechSpeed => _speechSpeed;
  set speechSpeed(double value) {
    _speechSpeed = value;
    notifyListeners();
  }

  bool _isNotificationOn = true;
  bool get isNotificationOn => _isNotificationOn;
  set isNotificationOn(bool value) {
    _isNotificationOn = value;
    notifyListeners();
  }

  void logout() {
    _userName = '';
    _avatarPath = '';
    _loginType = LoginType.guest;
    notifyListeners();
  }

  bool _isEditing = false;
  bool get isEditing => _isEditing;
  set isEditing(bool value) {
    _isEditing = value;
    notifyListeners();
  }

  void loadMockData() {
    _userName = 'tester';
    _avatarPath = '';
    _nationality = 'Taiwan';
    _darkMode = false;
    _loginType = LoginType.google;
    _isVoiceEnabled = true;
    _speechSpeed = 1.0;
    _isNotificationOn = true;
    _isEditing = false;
    notifyListeners();
  }
}
