import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lab08_example/widgets/animation_demo/progress_with_text.dart';

/// Explicit progress animation using [Ticker]
class AnimationDemo extends StatefulWidget {
  const AnimationDemo({super.key});

  @override
  State<AnimationDemo> createState() => _AnimationDemoState();
}

class _AnimationDemoState extends State<AnimationDemo>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  final Duration _animationDuration = const Duration(seconds: 3);
  double _progress = 0.0;
  bool _isTickerStarted = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      // The elapsed parameter represents the amount of time that has passed since the ticker was last started. It resets to zero every time the ticker restarts.
      final double relativeProgress =
          elapsed.inMilliseconds / _animationDuration.inMilliseconds;
      setState(() {
        _progress = relativeProgress.clamp(0.0, 1.0);
      });

      if (_progress >= 1.0) {
        _ticker.stop();
        setState(() {
          _isTickerStarted = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _startTicker() {
    _progress = 0.0; // Reset progress

    _ticker.start();
    setState(() {
      _isTickerStarted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticker Progress'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ProgressWithText(progress: _progress),
            const SizedBox(height: 40),
            FilledButton(
              onPressed: _isTickerStarted
                  ? null // Disable button when ticker is running
                  : _startTicker,
              child: const Text('Start Ticker'),
            ),
          ],
        ),
      ),
    );
  }
}
