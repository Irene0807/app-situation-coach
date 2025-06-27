import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PageAchievement extends StatelessWidget {
  const PageAchievement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: Text('PageAchievement')),
          const Center(
              child: Text('這頁是做成就 也可以不要做成就只保留evaluation_page和list_page')),
        ],
      ),
    );
  }
}
