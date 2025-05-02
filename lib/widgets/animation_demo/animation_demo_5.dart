import 'package:flutter/material.dart';
import 'package:lab08_example/widgets/animation_demo/ball.dart';

/// Explicit slide animation using [SlideTransition]
class AnimationDemo extends StatefulWidget {
  const AnimationDemo({super.key});

  @override
  State<AnimationDemo> createState() => _AnimationDemoState();
}

class _AnimationDemoState extends State<AnimationDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
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
        title: const Text('SlideTransition'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 300,
              alignment: Alignment.bottomCenter,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -6), // Relative child size
                  end: const Offset(0, 0),
                ).animate(CurvedAnimation(
                  parent: _animationController,
                  curve: Curves.bounceOut,
                )),
                child: const Ball(),
              ),
            ),
            const SizedBox(height: 40),
            FilledButton(
              onPressed: _animationController.isAnimating
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
