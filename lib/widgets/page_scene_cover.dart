import 'dart:ui';
import 'package:flutter/material.dart';

// 地點下可以加張圖片

class PageSceneCover extends StatelessWidget {
  final String sceneTitle;
  final String sceneLocation;
  final String sceneDescription;

  const PageSceneCover({
    super.key,
    required this.sceneTitle,
    required this.sceneLocation,
    required this.sceneDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 背景圖 + 模糊
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Image.asset(
                'assets/images/journey_start_background.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 增加黑色遮罩提升對比
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          // 中央內容卡片
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height * 0.65,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 場景標題
                        Text(
                          sceneTitle,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // 場景地點
                        Row(
                          children: [
                            Icon(Icons.place,
                                color: Colors.white.withOpacity(0.9), size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                sceneLocation,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // 場景描述
                        Text(
                          sceneDescription,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
