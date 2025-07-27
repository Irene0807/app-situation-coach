import 'package:app_situational_coach/models/journey.dart';
import 'package:app_situational_coach/models/status.dart';
import 'package:flutter/material.dart';

class JourneyStatusNotifier extends ChangeNotifier {
  JourneyStatus status;
  bool sceneReady = true;

  JourneyStatusNotifier({
    required this.status,
  });

  JourneyStatus getStatus() {
    return status;
  }

  bool getSceneReady() {
    return sceneReady;
  }

  bool goNextStatus(Journey j) {
    if (status.goNextStatus(j)) {
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  void setSceneReady(bool setValue) {
    sceneReady = setValue;
    notifyListeners();
  }
}
