import 'package:flutter/material.dart';
import 'dart:math';
import 'package:go_router/go_router.dart';

class PageJourneyBackCover extends StatefulWidget {
  const PageJourneyBackCover({super.key});

  @override
  State<PageJourneyBackCover> createState() => _PageJourneyBackCoverState();
}

class _PageJourneyBackCoverState extends State<PageJourneyBackCover>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goHome() {
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // 背景圖
          Positioned.fill(
            child: Image.asset(
              'assets/images/journey_start_background.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // 煙火持續
          const Positioned(left: 100, top: 200, child: LoopingFirework(color: Colors.pink)),
          const Positioned(left: 250, top: 350, child: LoopingFirework(color: Colors.blue)),
          const Positioned(left: 180, top: 500, child: LoopingFirework(color: Colors.yellow)),

          // 主要內容
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.25),

                // Icon
                Icon(
                  Icons.military_tech,
                  color: Colors.amberAccent,
                  size: size.width * 0.25,
                ),
                SizedBox(height: size.height * 0.05),

                // 文字
                Text(
                  "Congratulations!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: size.width * 0.07,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                          blurRadius: 6,
                          offset: Offset(2, 2),
                          color: Colors.black45)
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                Text(
                  "You’ve completed this journey!\n",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: size.width * 0.055,
                    height: 1.4,
                    color: const Color.fromARGB(226, 255, 255, 255),
                    fontStyle: FontStyle.italic,
                  ),
                ),

                Spacer(),

                // 下一頁button
                Padding(
                  padding: EdgeInsets.only(
                      bottom: size.height * 0.08, left: 24, right: 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _goHome,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4B296B),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                            vertical: size.height * 0.02),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Go to Home",
                        style: TextStyle(
                          fontSize: size.width * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 煙火
class LoopingFirework extends StatefulWidget {
  final Color color;
  const LoopingFirework({super.key, required this.color});

  @override
  State<LoopingFirework> createState() => _LoopingFireworkState();
}

class _LoopingFireworkState extends State<LoopingFirework>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(); // 循環
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final value = _controller.value;
        return Transform.scale(
          scale: value * 3,
          child: Opacity(
            opacity: 1 - value,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color,
              ),
            ),
          ),
        );
      },
    );
  }
}
