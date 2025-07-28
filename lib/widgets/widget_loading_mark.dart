import 'package:flutter/material.dart';

class WidgetLoadingMark extends StatelessWidget {
  const WidgetLoadingMark({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(), // TrumpCharacter
    );
  }
}
