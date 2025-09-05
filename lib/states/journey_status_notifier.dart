import 'package:app_situational_coach/models/journey.dart';
import 'package:app_situational_coach/models/status.dart';
import 'package:flutter/material.dart';

// sceneReady的部分可能還有bug 起碼現在算是可以跑背景?!

class JourneyStatusNotifier extends ChangeNotifier {
  JourneyStatus status;
  bool sceneReady = true;
  bool isPass = false; // 僅有sceneDetail會看isPass決定換頁button是否出現

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
      isPass = false; // 重製isPass
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

  void setIsPass() {
    isPass = true;
    notifyListeners();
  }
}
