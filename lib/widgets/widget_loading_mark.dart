import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_situational_coach/widgets/painters/character_trump.dart';

class WidgetLoadingMark extends StatefulWidget {
  const WidgetLoadingMark({super.key});

  @override
  State<WidgetLoadingMark> createState() => _WidgetLoadingMarkState();
}

class _WidgetLoadingMarkState extends State<WidgetLoadingMark> {
  final List<String> phrases = [
    "I'm thinking, bigly...",
    "Hold on, this is gonna be great.",
    "Processing... Believe me.",
    "Tremendous results incoming!",
    "Just a moment. Very important stuff.",
  ];

  late Timer _textTimer;
  String currentPhrase = "Loading...";

  @override
  void initState() {
    super.initState();
    _updateTextLoop();
  }

  void _updateTextLoop() {
    _textTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      setState(() {
        currentPhrase = (phrases..shuffle()).first;
      });
    });
  }

  @override
  void dispose() {
    _textTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 背景模糊可選
        Positioned.fill(
          child: Container(
            color: const Color.fromARGB(255, 218, 248, 252).withOpacity(0.85),
          ),
        ),

        // 川普角色 + 對話框
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1,  // 左右各占 10%
                  vertical: MediaQuery.of(context).size.height * 0.02, // 上下各占 2%
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 196, 251, 255),
                    border: Border.all(color: const Color.fromARGB(201, 64, 255, 242)),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    currentPhrase,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF005A78),
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 20),
                  SizedBox(
                    width: 100,
                    child: TrumpCharacter(isTalking: true),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}
