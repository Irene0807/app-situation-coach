import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PageJourneyDetail extends StatelessWidget {
  final String journeyId;
  const PageJourneyDetail({super.key, required this.journeyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail: $journeyId')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: Text('PageJourneyDetail')),
          const Center(child: Text('這邊介紹該旅行的資訊 可能有多個小頁面 附上一個continue button')),
        ],
      ),
    );
  }
}
