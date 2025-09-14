// import 'package:flutter/material.dart';

// class PageJourneyDetail extends StatelessWidget {
//   final String journeyId;
//   const PageJourneyDetail({super.key, required this.journeyId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Detail: $journeyId')),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Center(child: Text('PageJourneyDetail')),
//           const Center(child: Text('這邊介紹該旅行的資訊 可能有多個小頁面 附上一個continue button')),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'dart:math';
import 'package:go_router/go_router.dart';

class PageJourneyDetail extends StatefulWidget {
  final String journeyId;
  const PageJourneyDetail({super.key, required this.journeyId});

  @override
  State<PageJourneyDetail> createState() => _PageJourneyDetailState();
}

class _PageJourneyDetailState extends State<PageJourneyDetail>
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

  void _goNext() {
    context.go('/home'); // 之後你可以改成 /journey/next 或其他路徑
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

          // 動態點綴
          const Positioned(left: 80, top: 150, child: LoopingFirework(color: Colors.cyan)),
          const Positioned(left: 220, top: 400, child: LoopingFirework(color: Colors.purpleAccent)),
          const Positioned(left: 150, top: 550, child: LoopingFirework(color: Colors.orange)),

          // 主要內容
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.15),

                // Icon
                Icon(
                  Icons.travel_explore,
                  color: Colors.lightBlueAccent,
                  size: size.width * 0.22,
                ),
                SizedBox(height: size.height * 0.04),

                // 標題
                Text(
                  "Journey Finish",
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
                SizedBox(height: size.height * 0.03),

                // 說明文字
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    "Congraduation!\n\n"
                    "Let's start next exciting journey!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: size.width * 0.05,
                      height: 1.5,
                      color: Colors.white70,
                    ),
                  ),
                ),

                const Spacer(),

                // Continue 按鈕
                Padding(
                  padding: EdgeInsets.only(
                      bottom: size.height * 0.08, left: 24, right: 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _goNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E4374),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                            vertical: size.height * 0.02),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Continue",
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

// --- 煙火動畫 ---
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

