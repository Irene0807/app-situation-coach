import 'package:app_situational_coach/models/account_data.dart';
import 'package:app_situational_coach/models/journey.dart';
import 'package:app_situational_coach/models/scene.dart';
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

  Future<void> setJourneyData({required Journey journey}) async {
    // 上傳 journey
    await dbService.setDocument([
      'users',
      getCurrentUserId()!,
      'journeys',
      journey.id
    ], {
      'name': journey.name,
      'day': journey.day,
      'character': journey.character,
      'description': journey.description,
      'learningGoal': journey.learningGoal,
      'bloomLevel': journey.bloomLevel,
      'group': journey.group,
      'status': {
        'day': journey.status.day,
        'scene': journey.status.scene,
        'mode': journey.status.mode,
      }
    });

    // 上傳 schedule
    await dbService.setAllDocsInCollection([
      'users',
      getCurrentUserId()!,
      'journeys',
      journey.id,
      'scenes'
    ], [
      for (var day in journey.schedule)
        for (var scene in day.scenes)
          {
            'id': scene.id,
            'dayTitle': day.title, // 這樣可以省略掉Day層
            'title': scene.title,
            'location': scene.location,
            'description': scene.description,
            'learningTheme': scene.learningTheme,
          }
    ]);
  }

  Future<void> setSceneContent({
    required String journeyId,
    required String sceneId,
    required Scene scene,
  }) async {
    await dbService.setDocument([
      'users',
      getCurrentUserId()!,
      'journeys',
      journeyId,
      'scenes',
      sceneId
    ], {
      'introContent': {
        'description': scene.introContent?.description,
        'vocabulary': scene.introContent?.vocabulary,
      },
      'conversationContent': {
        'script': scene.conversationContent?.script,
      },
      'summaryContent': {
        'summary': scene.summaryContent?.summary,
        'questions': scene.summaryContent?.questions
            .map((q) => {
                  'questionText': q.questionText,
                  'options': q.options,
                  'answerId': q.answerId,
                })
            .toList(),
      },
    });
  }

  String? getCurrentUserId() {
    return authService.getCurrentUserId();
  }
}
