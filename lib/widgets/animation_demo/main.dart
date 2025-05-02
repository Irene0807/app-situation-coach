import 'package:flutter/material.dart';
import 'package:lab08_example/widgets/animation_demo/animation_demo_1.dart';
// import 'package:lab08_example/widgets/animation_demo/animation_demo_2.dart';
// import 'package:lab08_example/widgets/animation_demo/animation_demo_3.dart';
// import 'package:lab08_example/widgets/animation_demo/animation_demo_4.dart';
// import 'package:lab08_example/widgets/animation_demo/animation_demo_5.dart';
// import 'package:lab08_example/widgets/animation_demo/animation_demo_6.dart';
// import 'package:lab08_example/widgets/animation_demo/animation_demo_7.dart';

void main() {
  runApp(const DemoApp());
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AnimationDemo(),
    );
  }
}
