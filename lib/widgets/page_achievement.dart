import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../models/journey.dart';
import '../data/dummy_data.dart';

class PageAchievement extends StatelessWidget {
  const PageAchievement({super.key});

  @override
  Widget build(BuildContext context) {

    final completedJourneys =
        dummyJourneys.where((j) => j.status.isCompleted()).length;

    final achievements = [
      {
        'title': 'Complete 3 journeys',
        'isDone': completedJourneys >= 3,
        'icon': Icons.map,
      },
      {
        'title': 'Talk to a character 5 times',
        'isDone': dummyDialogCount >= 5,
        'icon': Icons.chat_bubble_outline,
      },
      {
        'title': 'Log in for 7 days',
        'isDone': dummyLoginDays >= 7,
        'icon': Icons.calendar_today,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Achievements',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 10, 71, 108),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              itemCount: achievements.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final a = achievements[index];
                final isDone = a['isDone'] as bool;
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDone ? const Color(0xFF5970AF) : const Color(0xFFCBD5E1),
                      width: 2,
                    ),
                    boxShadow: isDone
                        ? [
                            BoxShadow(
                              color: const Color(0xFF5970AF).withOpacity(0.3),
                              blurRadius: 12,
                              spreadRadius: 2,
                              offset: const Offset(0, 4),
                            )
                          ]
                        : [],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        a['icon'] as IconData,
                        size: 40,
                        color: isDone ? const Color(0xFF5970AF) : Colors.grey,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        a['title'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isDone ? const Color(0xFF334155) : Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
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

