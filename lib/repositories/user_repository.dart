import 'package:flutter/material.dart';

import '../services/authentication.dart';
import '../services/database.dart';

class UserRepository {
  final AuthenticationService authService;
  final DatabaseService dbService;

  UserRepository({
    required this.authService,
    required this.dbService,
  });

  Future<void> registerWithEmail({
    required String account,
    required String password,
  }) async {
    final uid = await authService.signUpWithEmailPassword(
        email: '$account@gmail.com', password: password);
    final data = {
      'account': account,
      'isLogin': true,
      'isAccountCreated': false,
    };
    await dbService.setDocument(['users', uid], data);
  }

  Future<void> loginWithEmail({
    required String account,
    required String password,
  }) async {
    await authService.signInWithEmailPassword(
        email: '$account@gmail.com', password: password);
    await dbService.setDocument(
      ['users', getCurrentUserId()!],
      {'isLogin': true},
    );
  }

  Future<void> logout() async {
    // 取消login狀態
    await dbService.setDocument(
      ['users', getCurrentUserId()!],
      {'isLogin': false},
    );
    if (getCurrentUserId() != null) {
      await authService.signOut();
    }
  }

  String? getCurrentUserId() {
    return authService.getCurrentUserId();
  }
}
