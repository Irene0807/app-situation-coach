import 'package:app_situational_coach/models/journey.dart';
import 'package:app_situational_coach/models/status.dart';
import 'package:flutter/material.dart';

class JourneyStatusNotifier extends ChangeNotifier {
  JourneyStatus status;

  JourneyStatusNotifier({
    required this.status,
  });

  JourneyStatus getStatus() {
    return status;
  }

  bool goNextStatus(Journey j) {
    if (status.goNextStatus(j)) {
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}
