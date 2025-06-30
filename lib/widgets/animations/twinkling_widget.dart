import 'dart:math';
import 'package:flutter/material.dart';

class TwinklingWidget extends StatefulWidget {
  //主要設定 child enableSwing enableGlow glowWidth glowHeight 即可
  final Widget child; // 要顯示的子 widget
  final Duration duration; // 動畫週期
  final bool enableSwing; // 是否啟用上下擺動效果
  final bool enableGlow; // 是否啟用白光閃爍效果
  final double verticalOffset; // 上下擺動的最大幅度
  final double glowMaxOpacity; // 白光閃爍的最大透明度
  final double glowBlurRadius; // 白光陰影模糊半徑
  final double glowSpreadRadius; // 白光陰影擴散半徑
  final double glowWidth; // 白光區域的寬度
  final double glowHeight; // 白光區域的高度

  const TwinklingWidget({
    Key? key,
    required this.child,
    this.duration = const Duration(seconds: 8),
    this.enableSwing = true,
    this.enableGlow = true,
    this.verticalOffset = 5.0,
    this.glowMaxOpacity = 0.6,
    this.glowBlurRadius = 32,
    this.glowSpreadRadius = 4,
    this.glowWidth = 50,
    this.glowHeight = 50,
  }) : super(key: key);

  @override
  State<TwinklingWidget> createState() => _TwinklingWidgetState();
}

class _TwinklingWidgetState extends State<TwinklingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();

    final random = Random();
    final duration = widget.duration +
        Duration(milliseconds: random.nextInt(800)); // 讓每個widget閃爍不同步
    final delay = Duration(milliseconds: random.nextInt(1200));

    _controller = AnimationController(
      vsync: this,
      duration: duration,
    );

    _glowAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // 上下擺動
        final double offsetY = widget.enableSwing
            ? sin(_controller.value * 2 * pi) * widget.verticalOffset
            : 0.0;

        return Transform.translate(
          offset: Offset(0, offsetY),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 白光閃爍
              if (widget.enableGlow)
                Opacity(
                  opacity: _glowAnim.value * widget.glowMaxOpacity,
                  child: Container(
                    width: widget.glowWidth,
                    height: widget.glowHeight,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(_glowAnim.value),
                          blurRadius: widget.glowBlurRadius,
                          spreadRadius: widget.glowSpreadRadius,
                        )
                      ],
                    ),
                  ),
                ),
              // 主體
              widget.child,
            ],
          ),
        );
      },
    );
  }
}
