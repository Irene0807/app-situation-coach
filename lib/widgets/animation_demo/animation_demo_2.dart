import 'package:flutter/material.dart';
import 'package:lab08_example/widgets/animation_demo/progress_with_text.dart';

/// Explicit progress animation using [AnimationController]
class AnimationDemo extends StatefulWidget {
  const AnimationDemo({super.key});

  @override
  State<AnimationDemo> createState() => _AnimationDemoState();
}

class _AnimationDemoState extends State<AnimationDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final Duration _animationDuration = const Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..addListener(() {
        setState(() {}); // Update UI on animation value change
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startAnimation() {
    _animationController.reset(); // Reset the animation so it can be restarted
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimationController Progress'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ProgressWithText(progress: _animationController.value),
            const SizedBox(height: 40),
            FilledButton(
              onPressed: _animationController.isAnimating
                  ? null // Disable button when ticker is running
                  : _startAnimation,
              child: const Text('Start Animation'),
            ),
          ],
        ),
      ),
    );
  }
}
