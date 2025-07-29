import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_situational_coach/widgets/painters/character_trump.dart';
import 'dart:ui';
import 'package:app_situational_coach/models/message.dart';

// script跑到快瘋掉 先開個暫時的test_page，確定UI ok 之後再放進去

// 1. 可以輸入跟他進行對話
// 2. 點擊川普解鎖功能 - 激怒川普:)

// ---- only for conversation testing --------

class PageConversationTest extends StatefulWidget {
  const PageConversationTest({super.key});

  @override
  State<PageConversationTest> createState() => _PageConversationTestState();
}

class _PageConversationTestState extends State<PageConversationTest> {
  final TextEditingController _controller = TextEditingController();
  String userInput = '';
  String fullBotText = 'Hi! I\'m your AI tutor. Let\'s begin!';
  String displayedText = '';
  int _textIndex = 0;
  bool isTalking = false;
  Timer? _typingTimer;

  void _startTyping() {
    setState(() {
      displayedText = '';
      _textIndex = 0;
      isTalking = true;
    });

    _typingTimer?.cancel();
    _typingTimer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      if (_textIndex < fullBotText.length) {
        setState(() {
          displayedText += fullBotText[_textIndex];
          _textIndex++;
        });
      } else {
        timer.cancel();
        setState(() => isTalking = false);
      }
    });
  }

  void _onSend() {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    setState(() {
      userInput = input;
      fullBotText = 'You said: "$input". Let\'s go!';
    });

    _controller.clear();
    _startTyping();
  }

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    for (var path in [
      'assets/images/trump_1.png',
      'assets/images/trump_2.png',
      'assets/images/trump_3.png',
      'assets/images/trump_4.png',
      'assets/images/trump_5.png',
    ]) {
      precacheImage(AssetImage(path), context);
    }
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    resizeToAvoidBottomInset: false,
    body: Stack(
      children: [
        
        // 1. Background
        Positioned.fill(
          child: Stack(
            children: [
              Center(
                child: Image.asset(
                  'assets/images/seoul_shopping.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.center,
                ),
              ),

              // 模糊 遮罩
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(color: const Color.fromARGB(255, 255, 254, 215).withOpacity(0.15)),
              ),
            ],
          ),
        ),

        Stack(
          children: [
            const SizedBox(height: 80),
            
            // 2. 對話框
            // 理想狀況是對話太長的時候切斷講，可能要顯示一個光暈的點擊讓使用者點下一句，之後再做
            Align(
              alignment: const Alignment(0.0, -0.42),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.07, // 5% 畫面寬度
                  vertical: MediaQuery.of(context).size.height * 0.02, // 2% 畫面高度
                ),
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.015, // 避免貼到底部
                ),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.82, // 最多佔 82% 寬
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 252, 250, 228).withOpacity(0.95),
                  borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.04,
                  ),
                  border: Border.all(
                    color: const Color.fromARGB(255, 255, 242, 128),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 233, 203, 30).withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Text(
                  displayedText,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.052, // 依寬度比例算字體大小
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),



            // 3. Character
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.2,
                ),
                child: FractionallySizedBox(
                  widthFactor: 0.83,
                  child: TrumpCharacter(isTalking: isTalking),
                ),
              ),
            ),

            const Spacer(),

            // 4. 使用者輸入區
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.05,  //左右 5%
                  0,
                  MediaQuery.of(context).size.width * 0.05,
                  MediaQuery.of(context).size.height * 0.08, //底 8%
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * 0.04,  // 圓角根據寬度
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.04,
                    vertical: MediaQuery.of(context).size.height * 0.015,
                  ),
                  child: Row(
                    children: [
                      // 輸入框
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: '輸入你的對話',
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // 送出按鈕
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 64, 204, 255),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * 0.03,
                            vertical: MediaQuery.of(context).size.height * 0.015,
                          ),
                        ),
                        onPressed: _onSend,
                        child: const Icon(Icons.send, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),


          ],
        ),
      ],
    ),
  );
}
}