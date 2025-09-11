import 'package:app_situational_coach/models/account_data.dart';
import 'package:app_situational_coach/models/journey.dart';
import 'package:app_situational_coach/models/scene.dart';
import 'package:app_situational_coach/models/user.dart';
import 'package:app_situational_coach/repositories/user_repository.dart';
import 'package:flutter/material.dart';

// 主要做狀態管理 跟把user_repository的function拿出來用

class UserNotifier extends ChangeNotifier {
  final UserRepository userRepository;

  User? user;

  UserNotifier(this.userRepository);

  Future<void> login(String account, String password) async {
    await userRepository.loginWithEmail(
      account: account.trim(),
      password: password,
    );

    user = User(account: account.trim());
    notifyListeners();
  }

  Future<void> signUp(String account, String password) async {
    await userRepository.registerWithEmail(
      account: account.trim(),
      password: password,
    );

    user = User(account: account.trim());
    notifyListeners();
  }

  Future<void> logout() async {
    await userRepository.logout();
  }

  Future<void> submitAccountData(AccountData accountData) async {
    await userRepository.setAccountData(accountData: accountData);
  }

  Future<void> uploadJourney(Journey journey) async {
    await userRepository.setJourneyData(journey: journey);
  }

  Future<void> initializeSceneContent(
      String journeyId, String sceneId, Scene scene) async {
    await userRepository.setSceneContent(
        journeyId: journeyId, sceneId: sceneId, scene: scene);
  }

  String? getCurrentUserId() {
    return userRepository.getCurrentUserId();
  }
}
