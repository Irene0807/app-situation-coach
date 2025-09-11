import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:app_situational_coach/widgets/animations/character_animation.dart';

class WidgetLoadingMark extends StatefulWidget {
  const WidgetLoadingMark({super.key});

  @override
  State<WidgetLoadingMark> createState() => _WidgetLoadingMarkState();
}

class _WidgetLoadingMarkState extends State<WidgetLoadingMark> {
  late Timer _textTimer;
  final Random _random = Random();

  int _characterIndex = 0;   // 目前角色
  bool _showSlogan = true;   // 1: sloganSentece / 0: waitSentece

  // slogan
  final Map<String, String> sloganSentece = {
    "Trump": "“Make America Great Again!”",
    "TOEFL Interviewer": "“Let’s see how you handle this!”",
    "American Kid": "“Dude, let’s hang out!”",
    "England Kid": "“Hello, would you like some tea?”",
    "Harry Potter": "“Welcome to my magic world!”",
  };

  // 等待詞
  final Map<String, List<String>> waitSentece = {
    "Trump": [
      "Nobody loads better than me, nobody!",
      "We’re making tremendous progress, believe me.",
      "Loading... the best loading, everyone says so.",
      "Hold on, this will be the greatest result ever.",
      "Just a sec, I'm building a wall of ideas!",
    ],
    "TOEFL Interviewer": [
      "Preparing your journey... almost done.",
      "Grammar is important! give me a moment.",
      "One sec, Designing journey...",
    ],
    "American Kid": [
      "Yo, can’t wait for this trip!",
      "Yo dude, can’t wait to hit the road!",
      "Almost ready, we’re gonna have so much fun!",
      "Wait up, I’m packing my skateboard already!",
    ],
    "England Kid": [
      "Almost ready. Shall I pour you some tea?",
      "One moment, preparing a cup of tea...",
      "My favourite subject is literature, what about you?",
      "One moment... I’m humming my favourite song.",
      "Oh! I just thought of a lovely place we could visit.",
      "One more tick, then we’ll start our little adventure.",
    ],
    "Harry Potter": [
      "Accio... results! Oops, not yet.",
      "Wait, the spell takes a few seconds.",
      "Hogwarts owls are delivering... hold on!",
      "Almost done, by Dumbledore’s beard!",
      "The Sorting Hat is making up its mind.",
      "Patience. your journey starts at Platform 9¾.",
    ],
  };

  final List<String> characterOrder = [
    "Trump",
    "TOEFL Interviewer",
    "American Kid",
    "England Kid",
    "Harry Potter",
  ];

  @override
  void initState() {
    super.initState();
    _startPhraseLoop();
  }

  void _startPhraseLoop() {
    _textTimer = Timer.periodic(const Duration(seconds: 6), (_) {
      setState(() {
        if (_showSlogan) {
          _showSlogan = false;
        } else {
          _showSlogan = true;
          _characterIndex = (_characterIndex + 1) % characterOrder.length;
        }
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
    final characterName = characterOrder[_characterIndex];

    String textToShow;
    if (_showSlogan) {
      textToShow = sloganSentece[characterName] ?? "Loading...";
    } else {
      final phrases = waitSentece[characterName] ?? ["Loading..."];
      textToShow = phrases[_random.nextInt(phrases.length)];
    }

    return Stack(
      children: [
        // 背景
        Positioned.fill(
          child: Container(
            color: const Color.fromARGB(255, 218, 248, 252).withOpacity(0.85),
          ),
        ),

        Positioned(
          top: 120,
          left: 0,
          right: 0,
          child: Text(
            "系統運作中，請勿關閉畫面",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF005A78),
              decoration: TextDecoration.none,
            ),
          ),
        ),

        // 角色 + 對話框
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 對話框
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1,
                  vertical: MediaQuery.of(context).size.height * 0.02,
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
                    textToShow,
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

              // 角色動畫
              SizedBox(
                width: 120,
                child: CharacterWidget(
                  characterName: characterName,
                  currentSegment: textToShow, // 嘴巴跟著動
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
