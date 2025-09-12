import 'package:app_situational_coach/models/account_data.dart';
import 'package:app_situational_coach/models/journey.dart';
import 'package:app_situational_coach/models/message.dart';
import 'package:app_situational_coach/models/question.dart';
import 'package:app_situational_coach/models/scene.dart';
import 'package:app_situational_coach/models/status.dart';
import 'package:app_situational_coach/models/user.dart';
import 'package:app_situational_coach/models/day.dart';
import '../services/authentication.dart';
import '../services/database.dart';

// getSchedule 可優化 代處理

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
          id: journey['id'] as String,
          name: journey['name'] as String,
          day: journey['day'] as int,
          character: journey['character'] as String,
          description: journey['description'] as String,
          learningGoal: journey['learningGoal'] as String,
          schedule: [], // 這邊卡個bug 進到旅行後才會抓scehedule下來
          bloomLevel: journey['bloomLevel'] as int,
          status: JourneyStatus(
            day: journey['status']['day'] as int,
            scene: journey['status']['scene'] as int,
            mode: journey['status']['mode'] as int,
          ));
    }).toList();

    return journeys;
  }

  // 這個function比較複雜 可能會有bug 待確認
  // 這邊其實可以優化 使用者已經完成的scene可以不用抓 這個優化先保留
  Future<List<Day>> getSchedule({
    required String journeyId,
    required int day,
  }) async {
    // 1. 先初始化固定長度的 List<Day>
    List<Day> schedule = List.generate(day, (i) {
      return Day(
        title: '卡個bug',
        scenes: [],
      );
    });

    // 2. 抓取所有 scenes
    List<Map<String, dynamic>> scheduleData = await dbService.getCollectionDocs(
      ['users', getCurrentUserId()!, 'journeys', journeyId, 'scenes'],
    );

    // 3. 依照 scene.id (e.g. "01-02") 分配到正確的 Day
    for (var sceneData in scheduleData) {
      final sceneId = sceneData['id'] as String;
      final parts = sceneId.split('-');
      final dayIndex = int.parse(parts[0]) - 1; // 注意 list index 從 0 開始

      final scene = Scene(
        id: sceneId,
        title: sceneData['title'],
        location: sceneData['location'],
        description: sceneData['description'],
        learningTheme: sceneData['learningTheme'],
        introContent: sceneData['introContent'] != null
            ? IntroContent(
                description: sceneData['introContent']['description'],
                vocabulary:
                    (sceneData['introContent']['vocabulary'] as List<dynamic>)
                        .map((e) => e as String)
                        .toList())
            : null,
        conversationContent: sceneData['conversationContent'] != null
            ? ConversationContent(
                script: sceneData['conversationContent']['script'],
                messages: sceneData['conversationContent']['messages'] != null
                    ? (sceneData['conversationContent']['messages']
                            as List<dynamic>)
                        .map((m) => Message(
                              role: m['role'] as String,
                              content: m['content'] as String,
                            ))
                        .toList()
                    : null)
            : null,
        summaryContent: sceneData['summaryContent'] != null
            ? SummaryContent(
                summary: sceneData['summaryContent']['summary'],
                questions: (sceneData['summaryContent']['questions']
                        as List<dynamic>)
                    .map((q) => Question(
                          questionText: q['questionText'] as String,
                          options:
                              List<String>.from(q['options'] as List<dynamic>),
                          answerId: q['answerId'] as int,
                        ))
                    .toList(),
              )
            : null,
      );

      // 把 scene 丟進對應的 Day
      schedule[dayIndex].scenes.add(scene);

      // 更新dayTitle
      schedule[dayIndex].title = sceneData['dayTitle'];
    }

    // 4. 對每個 Day 的 scenes 排序
    for (var d in schedule) {
      d.scenes.sort((a, b) {
        final aIndex = int.parse(a.id.split('-')[1]);
        final bIndex = int.parse(b.id.split('-')[1]);
        return aIndex.compareTo(bIndex);
      });
    }

    return schedule;
  }
}
