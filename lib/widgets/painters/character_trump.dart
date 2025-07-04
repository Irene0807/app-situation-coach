import 'package:flutter/material.dart';
import 'dart:async';

class TrumpCharacter extends StatefulWidget {
  final bool isSpeaking;
  const TrumpCharacter({super.key, required this.isSpeaking});

  @override
  State<TrumpCharacter> createState() => _TrumpCharacterState();
}

class _TrumpCharacterState extends State<TrumpCharacter> {
  bool mouthOpen = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // 嘴巴動畫定時器
    _timer = Timer.periodic(const Duration(milliseconds: 400), (_) {
      if (widget.isSpeaking) {
        setState(() => mouthOpen = !mouthOpen);
      } else {
        if (mouthOpen) setState(() => mouthOpen = false);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TrumpCharacter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isSpeaking && mouthOpen) {
      setState(() => mouthOpen = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset('assets/images/trump.png', height: 160),
        Positioned(
          bottom: 6,
          child: Transform.scale(
            scaleY: mouthOpen ? 1.5 : 1.0,
            child: ClipRect(
              clipper: MouthClipper(),
              child: Image.asset('assets/images/trump.png', height: 160),
            ),
          ),
        )
      ],
    );
  }
}

class MouthClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(size.width * 0.43, size.height * 0.60, size.width * 0.15, size.height * 0.07);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}
