import 'package:app_situational_coach/models/scene.dart';
import 'package:flutter/material.dart';

class PageSceneIntro extends StatelessWidget {
  final IntroContent introContent;

  const PageSceneIntro({required this.introContent, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(introContent.description),
      ),
    );
  }
}
