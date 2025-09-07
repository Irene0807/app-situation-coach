import 'package:app_situational_coach/models/account_data.dart';
import 'package:flutter/material.dart';

import '../services/authentication.dart';
import '../services/database.dart';

// 利用database authentication製作function

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
    if (getCurrentUserId() != null) {
      // 取消login狀態
      await dbService.setDocument(
        ['users', getCurrentUserId()!],
        {'isLogin': false},
      );

      await authService.signOut();
    }
  }

  Future<void> setAccountData({required AccountData accountData}) async {
    await dbService.setDocument([
      'users',
      getCurrentUserId()!
    ], {
      'isAccountCreated': true,
      'accountData': {
        'name': accountData.name,
        'age': accountData.age,
        'englishLevel': accountData.englishLevel.name,
        'examScore': {
          'toeic': accountData.examScore.toeic,
          'toefl': accountData.examScore.toefl,
          'ielts': accountData.examScore.ielts,
          'gept': accountData.examScore.gept,
        },
        'dailyStudyTime': accountData.dailyStudyTime.name,
        'studyPlace': accountData.studyPlace.name,
        'englishAppExperience': accountData.englishAppExperience,
        'appFeedback': accountData.appFeedback,
      }
    });
  }

  String? getCurrentUserId() {
    return authService.getCurrentUserId();
  }
}
