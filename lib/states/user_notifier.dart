import 'package:app_situational_coach/models/user.dart';
import 'package:app_situational_coach/repositories/user_repository.dart';
import 'package:flutter/material.dart';

class UserNotifier extends ChangeNotifier {
  final UserRepository userRepository;

  User? user;

  UserNotifier(this.userRepository);

  // 已有帳號的話 使用該function進行login
  Future<bool> login(String account, String password) async {
    try {
      await userRepository.loginWithEmail(
          account: account.trim(), password: password);

      final appUser = userRepository.getCurrentUserId();
      if (appUser != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('發生錯誤：$e');
      return false;
    }
  }

  // 使用該function進行註冊 同時標記尚未完成create_account
  Future<bool> signUp(String account, String password) async {
    try {
      await userRepository.registerWithEmail(
        account: account.trim(),
        password: password,
      );

      final appUser = userRepository.getCurrentUserId();
      if (appUser != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('發生錯誤：$e');
      return false;
    }
  }

  Future<void> logout() async {
    await userRepository.logout();
  }

  String? getCurrentUserId() {
    return userRepository.getCurrentUserId();
  }
}
