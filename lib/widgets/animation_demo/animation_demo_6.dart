import 'package:flutter/material.dart';
import 'package:lab08_example/widgets/animation_demo/ball.dart';

/// Implicit slide animation using [TweenAnimationBuilder]
class AnimationDemo extends StatefulWidget {
  const AnimationDemo({super.key});

  @override
  State<AnimationDemo> createState() => _AnimationDemoState();
}

class _AnimationDemoState extends State<AnimationDemo> {
  bool _isAnimating = false;

  void _startAnimation() {
    setState(() => _isAnimating = true);
  }

  void _endAnimation() {
    setState(() => _isAnimating = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TweenAnimationBuilder Slide'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 300,
              alignment: Alignment.bottomCenter,
              child: TweenAnimationBuilder<Offset>(
                duration: const Duration(seconds: 1),
                tween: Tween<Offset>(
                  begin: const Offset(0, -300),
                  end:
                      _isAnimating ? const Offset(0, 0) : const Offset(0, -300),
                ),
                builder: (context, offset, child) {
                  return Transform.translate(
                    offset: offset,
                    child: child,
                  );
                },
                curve: Curves.bounceOut,
                onEnd: _endAnimation,
                child: const Ball(),
              ),
            ),
            const SizedBox(height: 40),
            FilledButton(
              onPressed: _isAnimating
                  ? null // Disable button when animation is running
                  : _startAnimation,
              child: const Text('Start Animation'),
            ),
          ],
        ),
      ),
    );
  }
}
