import '../models/journey.dart';

List<Journey> dummyJourneys = [
  Journey(id: '1', name: 'Seoul Shopping', character: 'Trump', isCompleted: false),
  Journey(id: '2', name: 'Job Interview', character: 'Trump', isCompleted: true),
  Journey(id: '3', name: 'Taipei Night Market', character: 'Trump', isCompleted: false),
  Journey(id: '4', name: 'Tokyo Vacation', character: 'Trump', isCompleted: true),
  Journey(id: '5', name: 'Hong Kong Business Trip', character: 'Trump', isCompleted: false),
  Journey(id: '6', name: 'Shanghai Conference', character: 'Trump', isCompleted: true),
  Journey(id: '7', name: 'Singapore Expo', character: 'Trump', isCompleted: false),
  Journey(id: '8', name: 'Bangkok Tour', character: 'Trump', isCompleted: true),
  Journey(id: '9', name: 'America Adventure', character: 'Trump', isCompleted: false),
];

const int dummyDialogCount = 6;
const int dummyLoginDays = 4;

const Map<String, double> dummyEnglishAbilities = {
  'Fluency': 68,
  'Pronunciation': 72,
  'Vocabulary': 61,
  'Grammar': 78,
  'Comprehensibility': 70,
  'Confidence': 83,
};