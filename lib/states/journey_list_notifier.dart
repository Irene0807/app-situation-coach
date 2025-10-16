import 'package:app_situational_coach/models/scene.dart';
import 'package:app_situational_coach/models/status.dart';
import 'package:app_situational_coach/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import '../models/journey.dart';
import '../data/dummy_data.dart';

class JourneyListNotifier extends ChangeNotifier {
  final UserRepository userRepository;
  List<Journey>? journeys;
  bool loading = true;

  JourneyListNotifier(this.userRepository) {
    loadJourneys();
  }

  Future<void> addJourney(Journey journey) async {
    // await userRepository.setJourneyData(journey: journey);

    journeys!.add(journey);
    notifyListeners();
  }

  // 為了新增第一個scene的content
  // Future<void> uploadPreSceneContent(
  //     String journeyId, String sceneId, Scene scene) async {
  //   await userRepository.setPreSceneContent(
  //       journeyId: journeyId, sceneId: sceneId, scene: scene);
  // }

  Future<void> loadJourneys() async {
    await Future.delayed(const Duration(milliseconds: 500));
    journeys = dummyJourneys; //直接給dummyd
    // journeys = await userRepository.getJourneys();
    journeys![0].status =
        await userRepository.getJourneyStatus(journeys![0].id) ??
            JourneyStatus();
    journeys![1].status =
        await userRepository.getJourneyStatus(journeys![1].id) ??
            JourneyStatus();
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
