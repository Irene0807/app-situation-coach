import 'package:flutter/material.dart';

//在根據keyboard調整位置時 letter會用閃現的過去 沒有動畫 => 小bug 有空調整

class LetterAnimation extends StatefulWidget {
  const LetterAnimation(
      {super.key, required this.child, required this.isKeyboard});

  final Widget child;
  final bool isKeyboard;

  @override
  State<LetterAnimation> createState() => _LetterAnimationState();
}

class _LetterAnimationState extends State<LetterAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isAtCenter = true;

  final double _letterHeight = 570; //根據 widget letter 的高度調整

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    // 初始時 WidgetLetter 在下方，進入頁面時動畫到中央
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _moveToCenter();
    });
  }

  @override
  void didUpdateWidget(covariant LetterAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isKeyboard && _isAtCenter) {
      _moveToBottom();
    } else if (!widget.isKeyboard && !_isAtCenter) {
      _moveToCenter();
    }
  }

  void _moveToCenter() {
    setState(() {
      _isAtCenter = true;
      _controller.forward();
    });
  }

  void _moveToBottom() {
    setState(() {
      _isAtCenter = false;
      _controller.reverse();
    });
  }

  void _onTap() {
    if (_isAtCenter) {
      _moveToBottom();
    } else {
      _moveToCenter();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _getCenterTop(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return (screenHeight - _letterHeight) / 2;
  }

  double _getBottomTop(BuildContext context, int down) {
    final screenHeight = MediaQuery.of(context).size.height;
    return screenHeight - down - _letterHeight;
  }

  @override
  Widget build(BuildContext context) {
    final down = widget.isKeyboard ? -135 : -350;
    final centerTop = _getCenterTop(context);
    final bottomTop = _getBottomTop(context, down);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // 0: bottom, 1: center
        final top = bottomTop + (centerTop - bottomTop) * _animation.value;
        return Positioned(
          left: 0,
          right: 0,
          top: top,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _onTap,
            child: Center(child: widget.child),
          ),
        );
      },
    );
  }
}
