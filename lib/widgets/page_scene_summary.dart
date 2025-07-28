import 'package:app_situational_coach/models/scene.dart';
import 'package:flutter/material.dart';

class PageSceneSummary extends StatelessWidget {
  final SummaryContent summaryContent;

  const PageSceneSummary({super.key, required this.summaryContent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PageSceneSummary')),
    );
  }
}
