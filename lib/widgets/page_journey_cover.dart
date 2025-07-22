import 'package:flutter/material.dart';
import 'dart:ui';

class PageJourneyCover extends StatelessWidget {
  final String journeyName;
  final int journeyDay;
  const PageJourneyCover(
      {super.key, required this.journeyName, required this.journeyDay});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(children: [
        Positioned.fill(
          // 之後圖片要用生成的
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8), // 調整模糊程度
            child: Image.asset(
              'assets/images/seoul_shopping.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Center(
          child: Text(
            journeyName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.5,
              shadows: [
                Shadow(
                    blurRadius: 6, offset: Offset(1, 1), color: Colors.black45)
              ],
            ),
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 32),
              child: Text(
                '$journeyDay day',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.5,
                  shadows: [
                    Shadow(
                        blurRadius: 6,
                        offset: Offset(1, 1),
                        color: Colors.black45)
                  ],
                ),
              ),
            ))
      ]),
    );
  }
}
