// [SCRIPT GENERATOR]
// generator -> agents -> prompt & gemini

import 'agents/origin_script_generator.dart';
import 'agents/user_situation_predictor.dart';
import 'agents/robot_response_predictor.dart';
import 'agents/user_response_predictor.dart';
import 'agents/bloom_evaluator.dart';
import 'agents/character_evaluator.dart';
import '../../models/journey.dart';
import '../../models/scene.dart';
import 'package:app_situational_coach/data/dummy_data.dart';

/*
ScriptGenerator:
  - 1. OriginScriptGenerator: 生成初始script (geminiA)
  - 2. UserSituationPredictor: 隨便假設一個使用者說的話 (geminiB)
  - 3. RobotResponsePredictor: 根據script生成AI的回答 (geminiA)
  - 4. UserResponsePredictor: 模擬使用者的回應 (geminiA)
  - 5. BloomEvaluator: 分析使用者回應的Bloom等級 (geminiA)
  - 6. CharacterEvaluator: 分析AI回答的角色符合度 (geminiB)
*/

/*下面程式碼執行的順序是考慮過gemini並行的，不會像原始順序
  - 第一步：1 + 2
  - 第二步：3
  - 第三步：4 + 6
  - 第四步：5-A, 5-C
  - 第五步：5-B
*/

class ScriptGenerator {
  final OriginScriptGenerator _originScript = OriginScriptGenerator();
  final UserSituationPredictor _userPredictor = UserSituationPredictor();
  final RobotResponsePredictor _robotPredictor = RobotResponsePredictor();
  final UserResponsePredictor _userResponsePredictor = UserResponsePredictor();
  final BloomEvaluator _bloomEvaluator = BloomEvaluator();
  final CharacterEvaluator _characterEvaluator = CharacterEvaluator();

  final double bloomThreshold = 0.5;
  final double characterThreshold = 0.3;

  Future<String> generateRefinedScript({
    required Journey journey,
    required Scene scene,
  }) async {
    final title = scene.title;
    final theme = scene.learningTheme;
    final topic = scene.description;
    final userBloomLevel = journey.bloomLevel;
    final character = journey.character;

    int retryCount = 1;
    String? feedback;

    while (true) {
      print('\nTry #$retryCount: Generating refined script...\n');

      //第一步：OriginScriptGenerator + UserSituationPredictor 同時做

      // OriginScriptGenerator：建立初始 script
      final rawScriptFuture = _originScript.generate(
        title: title!,
        theme: theme!,
        topic: topic!,
        bloomLevel: userBloomLevel,
        character: characters.firstWhere((c) => c.name.en == character),
        feedback: feedback,
      );

      // UserSituationPredictor：隨機生一個學生可能會說的話
      final fakeUserInputFuture = _userPredictor.predictPossibleUtterance(
        theme: theme,
        topic: topic,
        bloomLevel: userBloomLevel,
      );

      final rawScript = await rawScriptFuture;
      final fakeUserInput = await fakeUserInputFuture;
      print('Raw Script:\n$rawScript');
      print('[TEST] Fake User Input: "$fakeUserInput"');

      // 第二步：RobotResponsePredictor 根據 script 模擬回答
      final robotResponse = await _robotPredictor.generateResponse(
        script: rawScript,
        userInput: fakeUserInput,
      );
      print('[TEST] Robot Respond: "$robotResponse"');

      // 第三步：UserResponsePredictor + CharacterEvaluator 同時做

      // UserResponsePredictor：模擬使用者的回應
      final predictedUserAnswerFuture = _userResponsePredictor.predictResponse(
        robotMessage: robotResponse,
        theme: theme,
        bloomLevel: userBloomLevel,
      );

      // CharacterEvaluator：分析 Robot Response 的角色符合度
      final characterResultFuture = _characterEvaluator.evaluate(
        question: robotResponse,
        character: character,
      );

      final predictedUserAnswer = await predictedUserAnswerFuture;
      final characterResult = await characterResultFuture;
      print('[TEST] User Answer: "$predictedUserAnswer"');
      print('Character Score: ${characterResult.score}');

      // 第四步：BloomEvaluator 分析 Predict User Answer 的 Bloom 等級

      final bloomResult = await _bloomEvaluator.evaluate(
        predictedUserAnswer,
        userBloomLevel,
      );

      // 最後：判斷兩個 evaluator 的結果有沒有過
      final charPass = characterResult.score >= characterThreshold;

      if (bloomResult.passed && charPass) {
        // 過了就確定生成這個script
        print('[ACCEPTED] OK!');
        return rawScript;
      } else {
        // 如果沒通過會回圈重試
        print('[REJECTED] Re-generating script!');
        retryCount++;
        feedback = '''
        Bloom Suggestion: ${bloomResult.feedback}
        Character Suggestion: ${characterResult.feedback}
        ''';
      }
    }
  }
}
