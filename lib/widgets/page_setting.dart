import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PageSetting extends StatelessWidget {
  const PageSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('PageSetting')),
    );
  }
}