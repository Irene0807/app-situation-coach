import 'package:flutter/material.dart';
import '../page_character.dart';
import '../page_journey_start.dart';

class HomeActionSign extends StatefulWidget {
  final Widget content;
  final VoidCallback onTap;
  final bool tiltLeft;

  const HomeActionSign({
    super.key,
    required this.content,
    required this.onTap,
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

  void _handleTap() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) =>
            widget.tiltLeft ? const PageCharacter() : const PageJourneyStart(),
        transitionsBuilder: (_, animation, __, child) {
          final begin = Offset(widget.tiltLeft ? -1.0 : 1.0, 0.0);
          final end = Offset.zero;
          final tween = Tween(begin: begin, end: end);
          return SlideTransition(position: animation.drive(tween), child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
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
      ),
    );
  }
}
