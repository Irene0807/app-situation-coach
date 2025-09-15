import 'package:app_situational_coach/models/journey.dart';
import 'package:app_situational_coach/models/message.dart';
import 'package:app_situational_coach/models/scene.dart';
import 'package:app_situational_coach/repositories/user_repository.dart';
import 'package:flutter/material.dart';

class JourneyStatusNotifier extends ChangeNotifier {
  final UserRepository userRepository;
  final Journey journey;

  bool isPass = false; // 僅有sceneDetail會看isPass決定換頁button是否出現
  bool loading = true;
  bool isSceneGenerating = false;

  // 暫存data
  List<bool> tmpResponses = [];
  List<int> tmpAnswerIds = [];

  JourneyStatusNotifier({
    required this.userRepository,
    required this.journey,
  }) {
    loadSchedule();
  }

  void setIsPass() {
    isPass = true;
    notifyListeners();
  }

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  void setIsSceneGenerating(bool value) {
    isSceneGenerating = value;
    notifyListeners();
  }

  bool getSceneReady() {
    return journey
        .schedule[journey.status.day - 1].scenes[journey.status.scene - 1]
        .isContentsReady();
  }

  void cleanTmpData() {
    tmpResponses.clear();
    tmpAnswerIds.clear();
    notifyListeners();
  }

  void appendResponses(bool response) {
    tmpResponses.add(response);
    // notifyListeners();
  }

  void appendAnswerIds(int answerId) {
    tmpAnswerIds.add(answerId);
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

  Future<void> uploadPreSceneContent(String sceneId, Scene scene) async {
    await userRepository.setPreSceneContent(
        journeyId: journey.id, sceneId: sceneId, scene: scene);
  }

  Future<void> uploadSceneIntro(String sceneId) async {
    await userRepository.setSceneIntro(
        journeyId: journey.id, sceneId: sceneId, responses: tmpResponses);
  }

  Future<void> uploadSceneConversation(
      String sceneId, List<Message> messages) async {
    await userRepository.setSceneConversation(
        journeyId: journey.id, sceneId: sceneId, messages: messages);
  }

  Future<void> uploadSceneSummary(String sceneId) async {
    await userRepository.setSceneSummary(
        journeyId: journey.id, sceneId: sceneId, answerIds: tmpAnswerIds);
  }

  Future<void> loadSchedule() async {
    if (journey.schedule.isEmpty) {
      journey.schedule = await userRepository.getSchedule(
          journeyId: journey.id, day: journey.day);
    }

    loading = false;
    notifyListeners();
  }
}
