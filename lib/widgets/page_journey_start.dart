import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PageJourneyStart extends StatelessWidget {
  const PageJourneyStart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('start Journey')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: Text('PageJourneyStart')),
          const Center(child: Text("這邊會顯示數個進行中的旅行 和 新增旅行的選項")),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () => context.go('/journey/:journeyId'),
                child: const Text('點擊某進行中的旅行'),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () => context.go('/journey/add'),
                child: const Text('點擊新增旅行'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
