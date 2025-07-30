import 'dart:async';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class TrumpCharacter extends StatefulWidget {
  final bool isTalking;
  const TrumpCharacter({super.key, this.isTalking = false});

  @override
  State<TrumpCharacter> createState() => _TrumpCharacterState();
}

class _TrumpCharacterState extends State<TrumpCharacter> {
  final List<String> _imagePaths = [
    'assets/images/trump_1.png', //0
    'assets/images/trump_2.png', //1
    'assets/images/trump_1.png', //2
    'assets/images/trump_2.png', //3
    'assets/images/trump_3.png', //4
    'assets/images/trump_4.png', //5
    'assets/images/trump_3.png', //6
    'assets/images/trump_4.png', //7
    'assets/images/trump_5.png', //8
    'assets/images/trump_5.png', //9
    'assets/images/trump_5.png', //10
    'assets/images/trump_6.png', //11
  ];
  int _currentIndex = 10;
  Timer? _timer;

  bool _isReacting = false;
  Timer? _reactionTimer;

  @override
  void initState() {
    super.initState();
    _updateAnimationState();
  }

  @override
  void didUpdateWidget(covariant TrumpCharacter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isTalking != oldWidget.isTalking) {
      _updateAnimationState();
    }
  }

  void _updateAnimationState() {
    _timer?.cancel();

    if (widget.isTalking) { // 動畫時
      _currentIndex = 0;
      _timer = Timer.periodic(const Duration(milliseconds: 250), (_) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _imagePaths.length;
        });
      });
    } else { // 靜止時
      final idleFrames = [8, 9, 10, 8, 9, 10, 11];
      int idleIndex = 0;

      _timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
        setState(() {
          _currentIndex = idleFrames[idleIndex];
          idleIndex = (idleIndex + 1) % idleFrames.length;
        });
      });
    }
  }

  // 點擊激怒川普
  void _onTapCharacter() {
    if (_isReacting) return;

    setState(() {
      _isReacting = true;
      _currentIndex = 2; // trump_1
    });

    _reactionTimer?.cancel();
    _reactionTimer = Timer(const Duration(seconds: 1), () {
      setState(() {
        _isReacting = false;
      });
      _updateAnimationState(); // 回復原本動畫狀態
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTapCharacter,
      child: FadeInImage(
        placeholder: MemoryImage(kTransparentImage), // 透明佔位，避免還沒load好圖片一直閃
        image: AssetImage(_imagePaths[_currentIndex]),
        fit: BoxFit.contain,
        fadeInDuration: const Duration(milliseconds: 100),
      ),
    );
  }
}
