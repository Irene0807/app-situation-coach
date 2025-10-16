import 'package:app_situational_coach/models/account_data.dart';
import 'package:app_situational_coach/models/user.dart';
import 'package:app_situational_coach/repositories/user_repository.dart';
import 'package:flutter/material.dart';

// 主要做狀態管理 跟把user_repository的function拿出來用

class UserNotifier extends ChangeNotifier {
  final UserRepository userRepository;
  UserData? user;

  UserNotifier(this.userRepository);

  Future<void> login(String account, String password) async {
    await userRepository.loginWithEmail(
      account: account.trim(),
      password: password,
    );

    await loadUserData();
  }

  Future<void> signUp(String account, String password) async {
    await userRepository.registerWithEmail(
      account: account.trim(),
      password: password,
    );

    await loadUserData();
  }

  Future<void> logout() async {
    await userRepository.logout();

    user = null;
    notifyListeners();
  }

  String? getCurrentUserId() {
    return userRepository.getCurrentUserId();
  }

  Future<void> submitAccountData(AccountData accountData) async {
    await userRepository.setAccountData(accountData: accountData);

    // isAccountCreated在本地其實沒用 就不更新本地資料了

    // user!.isAccountCreated = true;
    // notifyListeners();
  }

  // Future<void> updateSetting(
  //     String nationality, bool darkMode, bool isNotificationOn) async {
  //   await userRepository.updateSetting(
  //       nationality: nationality,
  //       darkMode: darkMode,
  //       isNotificationOn: isNotificationOn);

  //   if (user != null) {
  //     user!.nationality = nationality;
  //     user!.darkMode = darkMode;
  //     user!.isNotificationOn = isNotificationOn;
  //   }
  //   notifyListeners();
  // }

  Future<void> loadUserData() async {
    user = await userRepository.getUserData();
    notifyListeners();
  }
}