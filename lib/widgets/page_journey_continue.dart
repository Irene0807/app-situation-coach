import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PageJourneyContinue extends StatelessWidget {
  final String journeyId;
  const PageJourneyContinue({super.key, required this.journeyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Continue: $journeyId')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: Text('PageJourneyContinue')),
          const Center(child: Text('進入旅行 在這個path下用JourneyStateNotifier控制頁面?')),
        ],
      ),
    );
  }
}
