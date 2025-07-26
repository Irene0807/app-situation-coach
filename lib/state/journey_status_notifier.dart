import 'package:app_situational_coach/models/journey.dart';
import 'package:app_situational_coach/models/status.dart';
import 'package:flutter/material.dart';

class JourneyStatusNotifier extends ChangeNotifier {
  JourneyStatus status;
  bool isLoading = true;

  JourneyStatusNotifier({
    required this.status,
  });

  JourneyStatus getStatus() {
    return status;
  }

  bool getIsLoading() {
    return isLoading;
  }

  bool goNextStatus(Journey j) {
    if (status.goNextStatus(j)) {
      isLoading = true;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  void setIsLoading() {
    isLoading = false;
    notifyListeners();
  }
}
