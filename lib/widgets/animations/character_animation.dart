import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class CharacterWidget extends StatefulWidget {
  final String characterName;
  final String? currentSegment;
  final bool changeHand;
  final bool loopHandWave;

  const CharacterWidget({
    super.key,
    required this.characterName,
    this.currentSegment,
    this.changeHand = false,
    this.loopHandWave = false,
  });

  @override
  State<CharacterWidget> createState() => _CharacterWidgetState();
}

class _CharacterWidgetState extends State<CharacterWidget> {
  bool isEyeOpen = true;
  bool isMouthOpen = true;
  bool isHandWave = false;

  Timer? _eyeTimer;
  Timer? _mouthTimer;
  Timer? _handTimer;

  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _scheduleNextBlink(); // 永遠眨眼
    if (widget.changeHand) _startHandWave();
    if (widget.currentSegment?.isNotEmpty ?? false) {
      _startMouthAnimation(widget.currentSegment!);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final role = _normalizeCharacterName(widget.characterName);
    for (var code in ['11', '12', '21', '22', '31', '32', '41', '42']) {
      precacheImage(AssetImage('assets/images/$role/$code.png'), context);
    }
  }

  @override
  void didUpdateWidget(covariant CharacterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 換新句子=>嘴巴動畫
    if (widget.currentSegment != oldWidget.currentSegment) {
      _mouthTimer?.cancel();
      if (widget.currentSegment?.isNotEmpty ?? false) {
        _startMouthAnimation(widget.currentSegment!);
      } else {
        setState(() => isMouthOpen = true);
      }
    }

    // 點擊觸發揮手
    if (widget.changeHand && !oldWidget.changeHand) {
      _startHandWave();
    }
  }

  // 1 動嘴巴（會根據句子長度估算持續時間
  void _startMouthAnimation(String text) {
    _mouthTimer?.cancel();

    int textLength = text.length;
    int durationMs = (textLength / 30 * 1000).toInt();
    if (durationMs > 5000) durationMs = 5000;
    if (durationMs < 800) durationMs = 800;

    int elapsed = 0;

    void toggleMouth() {
      if (!mounted) return;
      setState(() => isMouthOpen = !isMouthOpen);

      elapsed += 200;
      if (elapsed >= durationMs) {
        setState(() => isMouthOpen = false);
        return;
      }

      final nextDelay = 300 + _random.nextInt(200);
      _mouthTimer = Timer(Duration(milliseconds: nextDelay), toggleMouth);
    }

    toggleMouth();
  }

  // 2 揮手
  void _startHandWave() {
    _handTimer?.cancel();

    if (widget.loopHandWave) {
      // 無限揮手模式
      _handTimer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        setState(() => isHandWave = !isHandWave);
      });
    } else {
      // 正常只揮 4 次
      int waveCount = 0;
      _handTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
        setState(() => isHandWave = !isHandWave);
        waveCount++;
        if (waveCount >= 4) {
          timer.cancel();
          setState(() => isHandWave = false);
        }
      });
    }
  }

  // 3 眨眼
  void _scheduleNextBlink() {
    int delay = 2000 + _random.nextInt(3000);
    _eyeTimer?.cancel();
    _eyeTimer = Timer(Duration(milliseconds: delay), () {
      setState(() => isEyeOpen = false);
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) {
          setState(() => isEyeOpen = true);
          _scheduleNextBlink();
        }
      });
    });
  }

  @override
  void dispose() {
    _eyeTimer?.cancel();
    _mouthTimer?.cancel();
    _handTimer?.cancel();
    super.dispose();
  }

  /// 把角色名稱轉換成資料夾安全格式
  String _normalizeCharacterName(String name) {
    final map = {
      ['Trump', '川普']: 'trump',
      ['English Girl', '英國少女']: 'english_girl',
      ['Harry Potter', '哈利波特']: 'harry_potter',
      ['American Boy', '美國少年']: 'american_boy',
      ['Teacher', '老師']: 'teacher',
    };

    for (final entry in map.entries) {
      if (entry.key.contains(name)) return entry.value;
    }

    return name.toLowerCase().replaceAll(' ', '_');
  }

  /// 狀態轉圖片碼
  String _getStateCode(bool eye, bool mouth, bool hand) {
    if (eye && mouth && !hand) return '11';
    if (eye && mouth && hand)  return '12';
    if (!eye && mouth && !hand) return '21';
    if (!eye && mouth && hand)  return '22';
    if (eye && !mouth && !hand) return '31';
    if (eye && !mouth && hand)  return '32';
    if (!eye && !mouth && !hand) return '41';
    if (!eye && !mouth && hand)  return '42';
    return '31';
  }

  @override
  Widget build(BuildContext context) {
    final stateCode = _getStateCode(isEyeOpen, isMouthOpen, isHandWave);
    final role = _normalizeCharacterName(widget.characterName);
    final path = 'assets/images/$role/$stateCode.png';

    return GestureDetector(
      onTap: _startHandWave,
      child: Image.asset(path, fit: BoxFit.contain, gaplessPlayback: true,),
    );
  }
}
