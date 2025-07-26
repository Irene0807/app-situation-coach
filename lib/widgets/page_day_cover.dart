import 'package:app_situational_coach/models/day.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class PageDayCover extends StatelessWidget {
  final String journeyName;
  final int currentDay;
  final List<Day> schedule;

  const PageDayCover(
      {super.key,
      required this.journeyName,
      required this.currentDay,
      required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              children: [
                // 旅程標題
                Text(
                  journeyName,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                          blurRadius: 6,
                          offset: Offset(1, 1),
                          color: Colors.black45)
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                Expanded(
                  child: ListView(children: [
                    for (int i = 0; i < schedule.length; i++) ...[
                      Text(
                        'Day ${i + 1}: ${i < currentDay ? schedule[i].title : '? ? ?'}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                                blurRadius: 4,
                                offset: Offset(1, 1),
                                color: Colors.black45)
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      for (var scene in schedule[i].scenes)
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, bottom: 4),
                          child: Text(
                            '- ${i < currentDay ? scene.title : '? ? ?'}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                    blurRadius: 2,
                                    offset: Offset(1, 1),
                                    color: Colors.black26)
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                    ],
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
