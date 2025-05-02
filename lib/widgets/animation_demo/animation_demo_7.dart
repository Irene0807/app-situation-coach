import 'package:flutter/material.dart';
import 'package:lab08_example/widgets/animation_demo/ball.dart';

/// Implicit slide animation using [AnimatedSlide]
class AnimationDemo extends StatefulWidget {
  const AnimationDemo({super.key});

  @override
  State<AnimationDemo> createState() => _AnimationDemoState();
}

class _AnimationDemoState extends State<AnimationDemo> {
  bool _isAnimating = false;

  void _toggleAnimation() {
    setState(() {
      _isAnimating = !_isAnimating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimatedSlide'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 300,
              alignment: Alignment.bottomCenter,
              child: AnimatedSlide(
                offset: _isAnimating
                    ? const Offset(0, 0)
                    : const Offset(0, -6), // Relative child size
                duration: const Duration(seconds: 1),
                curve: Curves.bounceOut,
                child: const Ball(),
              ),
            ),
            const SizedBox(height: 40),
            FilledButton(
              onPressed: _toggleAnimation,
              child: const Text('Toggle Animation'),
            ),
          ],
        ),
      ),
    );
  }
}
