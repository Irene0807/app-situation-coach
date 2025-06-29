import 'package:flutter/material.dart';

class PlanetStaggeredAnimation extends StatefulWidget {
  final int index;
  final Widget child;

  const PlanetStaggeredAnimation(
      {super.key, required this.index, required this.child});

  @override
  State<PlanetStaggeredAnimation> createState() => _PlanetStaggeredAnimationState();
}

class _PlanetStaggeredAnimationState extends State<PlanetStaggeredAnimation>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<Offset>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
        3,
        (i) => AnimationController(
              vsync: this,
              duration: const Duration(milliseconds: 700),
            ));
    _animations = List.generate(
        3,
        (i) => Tween<Offset>(
              begin: const Offset(0, 2), // 從下方飛入
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: _controllers[i],
              curve: Curves.easeOutBack,
            )));
    // 依序啟動動畫
    Future.delayed(
        const Duration(milliseconds: 200), () => _controllers[0].forward());
    Future.delayed(
        const Duration(milliseconds: 500), () => _controllers[1].forward());
    Future.delayed(
        const Duration(milliseconds: 800), () => _controllers[2].forward());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // index: 0~5
    int group = widget.index ~/ 2; // 0,1=>0; 2,3=>1; 4,5=>2
    return SlideTransition(position: _animations[group], child: widget.child);
  }
}
