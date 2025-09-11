import 'package:app_situational_coach/models/account_data.dart';
import 'package:app_situational_coach/models/journey.dart';
import 'package:app_situational_coach/models/message.dart';
import 'package:app_situational_coach/models/scene.dart';
import 'package:app_situational_coach/models/status.dart';
import 'package:app_situational_coach/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  ///////////////////////////////////////////////////////////////
  ///             帳號相關function                             ///
  ///////////////////////////////////////////////////////////////

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
      'nationality': 'Taiwan',
      'darkMode': false,
      'isNotificationOn': true
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
      await dbService.setDocument(
        ['users', getCurrentUserId()!],
        {'isLogin': false}, // 取消login狀態
      );

      await authService.signOut();
    }
  }

  String? getCurrentUserId() {
    return authService.getCurrentUserId();
  }

  ///////////////////////////////////////////////////////////////
  ///             上傳或修改db的function                       ///
  ///////////////////////////////////////////////////////////////

  Future<void> setAccountData({required AccountData accountData}) async {
    await dbService.setDocument([
      'users',
      getCurrentUserId()!
    ], {
      'isAccountCreated': true,
      'accountData': {
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

  Future<void> updateSetting(
      {required String nationality,
      required bool darkMode,
      required bool isNotificationOn}) async {
    await dbService.setDocument([
      'users',
      getCurrentUserId()!
    ], {
      'nationality': nationality,
      'darkMode': darkMode,
      'isNotificationOn': isNotificationOn
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
      'id': journey.id,
      'name': journey.name,
      'day': journey.day,
      'character': journey.character,
      'description': journey.description,
      'learningGoal': journey.learningGoal,
      'bloomLevel': journey.bloomLevel,
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

  Future<void> setPreSceneContent({
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

  Future<void> setSceneIntro(
      {required String journeyId,
      required String sceneId,
      required List<bool> responses}) async {
    await dbService.setDocument([
      'users',
      getCurrentUserId()!,
      'journeys',
      journeyId,
      'scenes',
      sceneId
    ], {
      'introContent': {
        'responses': responses,
      },
    });
  }

  Future<void> setSceneConversation(
      {required String journeyId,
      required String sceneId,
      required List<Message> messages}) async {
    await dbService.setDocument([
      'users',
      getCurrentUserId()!,
      'journeys',
      journeyId,
      'scenes',
      sceneId
    ], {
      'conversationContent': {
        'messages': messages
            .map((m) => {
                  'role': m.role,
                  'content': m.content,
                })
            .toList(),
      },
    });
  }

  Future<void> setSceneSummary(
      {required String journeyId,
      required String sceneId,
      required List<int> answerIds}) async {
    await dbService.setDocument([
      'users',
      getCurrentUserId()!,
      'journeys',
      journeyId,
      'scenes',
      sceneId
    ], {
      'summaryContent': {
        'answerIds': answerIds,
      },
    });
  }

  ///////////////////////////////////////////////////////////////
  ///             load db的function                           ///
  ///////////////////////////////////////////////////////////////

  Future<UserData> getUserData() async {
    Map<String, dynamic>? userData = await dbService.getDocument([
      'users',
      getCurrentUserId()!,
    ]);

    UserData user = UserData(
        account: userData!['account'],
        isLogin: userData['isLogin'],
        isAccountCreated: userData['isAccountCreated'],
        // accountData: userData['accountData'], // 反正之後用不到
        nationality: userData['nationality'],
        darkMode: userData['darkMode'],
        isNotificationOn: userData['isNotificationOn']);

    return user;
  }

  Future<List<Journey>> getJourneys() async {
    List<Map<String, dynamic>> journeysData = await dbService
        .getCollectionDocs(['users', getCurrentUserId()!, 'journeys']);

    List<Journey> journeys = journeysData.map((journey) {
      return Journey(
          id: journey['id'],
          name: journey['name'],
          day: journey['day'],
          character: journey['character'],
          description: journey['description'],
          learningGoal: journey['learningGoal'],
          schedule: [], // 這邊卡個bug 進到旅行後才會抓scehedule下來
          bloomLevel: journey['bloomLevel'],
          status: JourneyStatus(
            day: journey['status']['day'],
            scene: journey['status']['scene'],
            mode: journey['status']['mode'],
          ));
    }).toList();

    return journeys;
  }
}
