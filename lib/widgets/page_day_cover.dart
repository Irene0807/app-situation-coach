import 'package:app_situational_coach/models/day.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

// 看有沒有要把scene的目錄也做在這裡 場景頁面目前只有該場景的title, location, description而已 沒有目錄

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
      body: Stack(
        children: [
          // 模糊背景
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Image.asset(
                'assets/images/journey_start_background.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 黑色遮罩
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          SafeArea(
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
                              padding:
                                  const EdgeInsets.only(left: 16.0, bottom: 4),
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
        ],
      ),
    );
  }
}
