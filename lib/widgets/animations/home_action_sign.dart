import 'package:flutter/material.dart';
import '../page_character.dart';
import '../page_journey_start.dart';

class HomeActionSign extends StatefulWidget {
  final Widget content;
  final bool tiltLeft;

  const HomeActionSign({
    super.key,
    required this.content,
    this.tiltLeft = false,
  });

  @override
  State<HomeActionSign> createState() => _HomeActionSignState();
}

class _HomeActionSignState extends State<HomeActionSign> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _rotation = Tween<double>(
      begin: widget.tiltLeft ? -0.35 : 0.25, // 傾斜角度
      end: widget.tiltLeft ? -0.15 : 0.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotation.value,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset('assets/images/home_sign.png', width: 100),
              widget.content,
            ],
          ),
        );
      },
    );
  }
}
