import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/journey.dart';

class PageList extends StatelessWidget {
  const PageList({super.key});

  MapEntry<String, int> getMostFrequentCharacter(List<Journey> journeys) {
    final Map<String, int> countMap = {};
    for (var j in journeys) {
      countMap[j.character] = (countMap[j.character] ?? 0) + 1;
    }
    return countMap.entries.reduce((a, b) => a.value >= b.value ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    final topCharacter = getMostFrequentCharacter(dummyJourneys);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          
          // Best Character
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 240, 228, 252),
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'Your Best Travel Buddy',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 37, 36, 36),
                  ),
                ),
                const SizedBox(height: 8),
                CircleAvatar(
                  radius: 36,
                  backgroundColor: const Color.fromARGB(255, 149, 126, 173),
                  child: Text(
                    topCharacter.key.characters.first,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  topCharacter.key,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 10, 67, 108),
                  ),
                ),
                Text(
                  '${topCharacter.value} times together',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),

          // List
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Your Journeys',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: ListView.builder(
              itemCount: dummyJourneys.length,
              itemBuilder: (context, index) {
                final journey = dummyJourneys[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: journey.status.isCompleted() ? Colors.green[50] : Colors.orange[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: journey.status.isCompleted() ? Colors.green : Colors.orange,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        journey.status.isCompleted() ? Icons.emoji_events : Icons.directions_walk,
                        size: 32,
                        color: journey.status.isCompleted() ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              journey.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'with ${journey.character}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        journey.status.isCompleted() ? '✅' : '⏳',
                        style: const TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
