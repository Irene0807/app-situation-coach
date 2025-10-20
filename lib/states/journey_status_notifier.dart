import 'package:app_situational_coach/models/journey.dart';
import 'package:app_situational_coach/models/message.dart';
import 'package:app_situational_coach/models/scene.dart';
import 'package:app_situational_coach/repositories/user_repository.dart';
import 'package:flutter/material.dart';

class JourneyStatusNotifier extends ChangeNotifier {
  final UserRepository userRepository;
  final Journey journey;

  bool isPass = false; // 僅有sceneDetail會看isPass決定換頁button是否出現
  bool loading = false;
  // bool isSceneGenerating = false;

  // 暫存data
  List<int> tmpResponses = []; // 儲存使用者的回答(0, 1, 2, 3) + 正確答案數量

  JourneyStatusNotifier({
    required this.userRepository,
    required this.journey,
  }) {
    // loadSchedule();
  }

  void setIsPass() {
    isPass = true;
    notifyListeners();
  }

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  // void setIsSceneGenerating(bool value) {
  //   isSceneGenerating = value;
  //   notifyListeners();
  // }

  bool getSceneReady() {
    return journey
        .schedule[journey.status.day - 1].scenes[journey.status.scene - 1]
        .isContentsReady();
  }

  void cleanTmpData() {
    tmpResponses.clear();
    notifyListeners();
  }

  void appendResponses(int response) {
    tmpResponses.add(response);
    // notifyListeners();
  }

  void appendCorrectNum(int correctNum) {
    tmpResponses.insert(0, correctNum);
    // notifyListeners();
  }

  Future<bool> goNextStatus() async {
    // 使用goNextStatus後
    bool b = journey.status.goNextStatus(journey); // 回傳是否有下一頁
    isPass = false; // 重製isPass
    // status丟db
    await userRepository.updateJourneyStatus(
        journeyId: journey.id, status: journey.status);
    // 通知UI更新
    notifyListeners();
    return b;
  }

  // Future<void> uploadPreSceneContent(String sceneId, Scene scene) async {
  //   await userRepository.setPreSceneContent(
  //       journeyId: journey.id, sceneId: sceneId, scene: scene);
  // }

  Future<void> uploadPreTestResponses() async {
    await userRepository.serPreTestResponse(
        journeyId: journey.id,
        preTestId: 'pre_test',
        responseAndCorrectCnt: tmpResponses);
  }

  Future<void> uploadPostTestResponses() async {
    await userRepository.setPostTestResponse(
        journeyId: journey.id,
        postTestId: 'post_test',
        responseAndCorrectCnt: tmpResponses);
  }

  ///////////////////////////////////////////////////////
  /// 下面三個function代處理 introId conversationId summaryId
  ///////////////////////////////////////////////////////

  String formatDayScene() {
    return '${journey.status.day.toString().padLeft(2, '0')}-${journey.status.scene.toString().padLeft(2, '0')}';
  }

  Future<void> uploadSceneIntro() async {
    String introId = 'scene_pretest_${formatDayScene()}';
    await userRepository.setSceneIntro(
        journeyId: journey.id,
        introId: introId,
        responseAndCorrectCnt: tmpResponses);
  }

  Future<void> uploadSceneConversation(List<Message> messages) async {
    String conversationId = 'conversation_${formatDayScene()}';
    await userRepository.setSceneConversation(
        journeyId: journey.id,
        conversationId: conversationId,
        messages: messages);
  }

  Future<void> uploadSceneSummary() async {
    String summaryId = 'scene_posttest_${formatDayScene()}';
    await userRepository.setSceneSummary(
        journeyId: journey.id,
        summaryId: summaryId,
        responseAndCorrectCnt: tmpResponses);
  }

  // Future<void> loadSchedule() async {
  //   if (journey.schedule.isEmpty) {
  //     journey.schedule = await userRepository.getSchedule(
  //         journeyId: journey.id, day: journey.day);
  //   }

  //   loading = false;
  //   notifyListeners();
  // }
}
