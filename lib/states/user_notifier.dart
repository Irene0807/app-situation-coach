import 'package:app_situational_coach/models/account_data.dart';
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
        account: account.trim(), password: password);
  }

  Future<void> signUp(String account, String password) async {
    await userRepository.registerWithEmail(
      account: account.trim(),
      password: password,
    );
  }

  Future<void> logout() async {
    await userRepository.logout();
  }

  Future<void> submitAccountData(AccountData accountData) async {
    await userRepository.setAccountData(accountData: accountData);
  }

  String? getCurrentUserId() {
    return userRepository.getCurrentUserId();
  }
}
