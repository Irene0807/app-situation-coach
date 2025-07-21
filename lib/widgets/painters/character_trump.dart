import 'dart:async';
import 'package:flutter/material.dart';

class TrumpCharacter extends StatefulWidget {
  const TrumpCharacter({super.key});

  @override
  State<TrumpCharacter> createState() => _TrumpCharacterState();
}

class _TrumpCharacterState extends State<TrumpCharacter> {
  final List<String> _imagePaths = [
    'assets/images/trump_1.png',
    'assets/images/trump_2.png',
    'assets/images/trump_1.png',
    'assets/images/trump_2.png',
    'assets/images/trump_3.png',
    'assets/images/trump_4.png',
    'assets/images/trump_3.png',
    'assets/images/trump_4.png',
    'assets/images/trump_5.png',
    'assets/images/trump_5.png',
    'assets/images/trump_5.png',
  ];
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startImageSwitchTimer();
  }

  void _startImageSwitchTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _imagePaths.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _imagePaths[_currentIndex],
      height: 170,
      gaplessPlayback: true,
      filterQuality: FilterQuality.high,
    );
  }
}
