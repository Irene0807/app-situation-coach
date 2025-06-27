import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PageEvaluation extends StatelessWidget {
  const PageEvaluation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: Text('PageEvaluation')),
          const Center(child: Text('這頁放六邊形跟其他評估內容')),
        ],
      ),
    );
  }
}
