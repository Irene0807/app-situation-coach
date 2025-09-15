import 'package:app_situational_coach/models/scene.dart';
import 'package:app_situational_coach/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import '../models/journey.dart';

class JourneyListNotifier extends ChangeNotifier {
  final UserRepository userRepository;
  List<Journey>? journeys;
  bool loading = true;

  JourneyListNotifier(this.userRepository) {
    loadJourneys();
  }

  Future<void> addJourney(Journey journey) async {
    await userRepository.setJourneyData(journey: journey);

    journeys!.add(journey);
    notifyListeners();
  }

  // 為了新增第一個scene的content
  Future<void> uploadPreSceneContent(
      String journeyId, String sceneId, Scene scene) async {
    await userRepository.setPreSceneContent(
        journeyId: journeyId, sceneId: sceneId, scene: scene);
  }

  Future<void> loadJourneys() async {
    journeys = await userRepository.getJourneys();
    loading = false;
    notifyListeners();
  }

  Journey? getById(String id) {
    try {
      return journeys!.firstWhere((j) => j.id == id);
    } catch (e) {
      return null;
    }
  }

  void reset() {
    journeys = null;
    loading = true;
    notifyListeners();
  }
}