import 'dart:math';
import 'package:flutter/material.dart';

class TwinklingStar extends StatefulWidget {
  final Widget child;

  const TwinklingStar({super.key, required this.child});

  @override
  State<TwinklingStar> createState() => _TwinklingStarState();
}

class _TwinklingStarState extends State<TwinklingStar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();

    final random = Random();
    final duration = Duration(milliseconds: 1000 + random.nextInt(1000));
    final delay = Duration(milliseconds: 1000 + random.nextInt(1500));

    _controller = AnimationController(
      duration: duration,
      vsync: this,
    );

    _glow = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Future.delayed(delay, () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        widget.child, // 星星本體

        AnimatedBuilder(
          animation: _glow,
          builder: (context, child) => Opacity(
            opacity: _glow.value * 0.6,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(_glow.value),
                    blurRadius: 30,
                    spreadRadius: 8,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
