import 'package:flutter/material.dart';
import '../models/journey.dart';

class JourneyListNotifier extends ChangeNotifier {
  final List<Journey> _journeys = [];

  List<Journey> get journeys => List.unmodifiable(_journeys);

  void addJourney(Journey journey) {
    _journeys.add(journey);
    notifyListeners();
  }

  void markAsCompleted(String journeyId) {
    final index = _journeys.indexWhere((j) => j.id == journeyId);
    if (index != -1) {
      _journeys[index].status.makeCompleted();
      notifyListeners();
    }
  }

  void addAll(List<Journey> journeys) {
    _journeys.addAll(journeys);
    notifyListeners();
  }

  Journey? getById(String id) {
    try {
      return _journeys.firstWhere((j) => j.id == id);
    } catch (e) {
      return null;
    }
  }
}
