import 'package:flutter/material.dart';

class PageSceneCover extends StatelessWidget {
  final List<String> sceneTitles;
  final String sceneLocation;
  const PageSceneCover(
      {super.key, required this.sceneTitles, required this.sceneLocation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PageSceneCover')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...sceneTitles.map((title) => Text(title)),
          SizedBox(height: 50),
          Text(sceneLocation)
        ],
      ),
    );
  }
}
