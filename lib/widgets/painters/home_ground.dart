import 'package:flutter/material.dart';

class GroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height), // 畫面底部中間
      width: size.width * 1.4,
      height: size.height * 1,
    );

    final paint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0, 1),
        radius: 1.2, // 漸層半徑
        colors: [
          Colors.transparent,
          const Color.fromARGB(255, 136, 221, 245).withOpacity(0.8), // 亮色
        ],
        stops: [0.0, 0.85], // 控制漸層分布
      ).createShader(rect);

    canvas.drawOval(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

