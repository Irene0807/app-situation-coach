import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class TrumpCharacter extends StatefulWidget {
  final bool isSpeaking;
  const TrumpCharacter({super.key, required this.isSpeaking});

  @override
  State<TrumpCharacter> createState() => _TrumpCharacterState();
}

class _TrumpCharacterState extends State<TrumpCharacter> {
  Artboard? _artboard;
  StateMachineController? _controller;
  SMITrigger? _lipsyncTrigger;
  SMIInput<bool>? _emotionToggle;

  @override
  void initState() {
    super.initState();
  }

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1', // 如果你的 State Machine 名稱不同請修改這行
    );
    if (controller != null) {
      artboard.addController(controller);
      setState(() {
        _artboard = artboard;
        _controller = controller;
        _lipsyncTrigger = controller.findSMI('demo lipsync') as SMITrigger?;
        _emotionToggle = controller.findInput<bool>('toEmotion2');
      });

      // 初始化表情為 emotion 1
      _emotionToggle?.value = false;
    }
  }

  @override
  void didUpdateWidget(covariant TrumpCharacter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSpeaking && _lipsyncTrigger != null) {
      _lipsyncTrigger?.fire();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: _artboard == null
          ? RiveAnimation.asset(
              'assets/character_man.riv',
              fit: BoxFit.contain,
              onInit: _onRiveInit,
            )
          : Rive(artboard: _artboard!, fit: BoxFit.contain),
    );
  }
}
