import 'package:app_situational_coach/widgets/animations/answer_glow_animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:ui';
import '../models/scene.dart';
import '../models/journey.dart';
import '../services/response_generator.dart';
import '../widgets/animations/character_animation.dart';
import '../widgets/animations/continue_dot_animation.dart';
import 'package:app_situational_coach/state/journey_status_notifier.dart';

// 小問題 frame_journey_continue那邊我已經疊一層image了 這邊又疊一層 不過demo來說沒差哈

// 1. 可以輸入跟他進行對話
// 2. 點擊角色 解鎖互動

// 對話內容：origin_script_generator的prompt要再改（詳細內容參考origin_script_prompt.dart）
class PageSceneConversation extends StatefulWidget {
  final ConversationContent conversationContent;
  final String sceneTitle;
  final Journey journey;
  const PageSceneConversation({super.key, required this.conversationContent, required this.sceneTitle,required this.journey,});

  @override
  State<PageSceneConversation> createState() => _PageSceneConversationState();
}

class _PageSceneConversationState extends State<PageSceneConversation> {
  final TextEditingController _controller = TextEditingController();
  ResponseGenerator? responseGenerator;
  Timer? _typingTimer;

  String fullBotText = '';
  String displayedText = '';
  int _textIndex = 0;
  bool isTalking = false;
  bool isThinking = false;
  int roundCount = 0;

  List<String> botTextSegments = []; // 準備分段的文字
  int currentSegmentIndex = 0;

  bool get showGlow =>
    !isTalking &&
    botTextSegments.isNotEmpty &&
    currentSegmentIndex >= botTextSegments.length &&
    roundCount < 7;

  @override
  void initState() {
    super.initState();

    responseGenerator = ResponseGenerator(conversation: widget.conversationContent);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () => startConversation());  // 角色開始主動對話
    });
  }

  // 讓角色主動講第一句話
  Future<void> startConversation() async {
    setState(() {
      isThinking = true;
      displayedText = '';
    });

    final firstResponse = await responseGenerator!.generateResponse("Hello.");

    setState(() => isThinking = false);
    _setBotText(firstResponse);
    setState(() => roundCount = 1);
  }

  // 生成response => response_generator
  Future<void> handleResponse() async {
    if (isTalking || roundCount >= 7 || responseGenerator == null) return;

    final input = _controller.text.trim();
    
    if (input.isEmpty) return;
    _controller.clear();
    FocusScope.of(context).unfocus(); 

    setState(() {
      isTalking = false;
      displayedText = "Thinking...";
      fullBotText = "Thinking...";
      botTextSegments = [];
    });

    final isFinalRound = roundCount >= 6;
    final response = await responseGenerator!.generateResponse(
      input,
      isFinalRound: isFinalRound,
    );
    setState(() => roundCount++);

    final text = (roundCount >= 7)
        ? '$response\n\nThat’s all for our chat today. See you later!'
        : response;
    _setBotText(text);
  }

  // 分段用
  void _setBotText(String text) {
    _typingTimer?.cancel();

    final RegExp regex = RegExp(r'([^?.!]+[?.!])', multiLine: true);
    botTextSegments = regex
        .allMatches(text)
        .map((match) => match.group(0)!.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    currentSegmentIndex = 0;
    _startNextSegment();
  }

  void _startNextSegment() { // 下一段
    if (currentSegmentIndex >= botTextSegments.length) return;

    final currentText = botTextSegments[currentSegmentIndex];
    _typingTimer?.cancel();

    if (currentSegmentIndex == 0) {
      Future.delayed(const Duration(milliseconds: 50), () {
        setState(() {
          fullBotText = currentText;
          displayedText = currentText;
          _textIndex = currentText.length;
          isTalking = false;
          currentSegmentIndex++;
        });
      });
    } else {
      
      setState(() {
        fullBotText = currentText;
        displayedText = '';
        _textIndex = 0;
        isTalking = true;
      });

      _typingTimer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
        if (_textIndex < fullBotText.length) {
          setState(() {
            displayedText += fullBotText[_textIndex++];
          });
        } else {
          timer.cancel();
          setState(() {
          isTalking = false;

          // 如果是最後一段最後一回合，觸發isPass
          if (currentSegmentIndex >= botTextSegments.length - 1 && roundCount >= 7 && mounted) {
            print("[DEBUG] Trigger setIsPass()");
            Provider.of<JourneyStatusNotifier>(context, listen: false).setIsPass();
          }
        });
        }
      });
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
          // 1. 背景模糊層
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
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: const Color.fromARGB(255, 255, 254, 215).withOpacity(0.15),
                  ),
                ),
              ],
            ),
          ),

          // 2. 對話主題 標題
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 28 + MediaQuery.of(context).padding.top),
              child: Text(
                widget.sceneTitle,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(239, 255, 255, 255),
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3,
                      color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.8),
                    )
                  ],
                ),
              ),
            ),
          ),

          // 2. 對話框 + 角色 + 輸入區
          Stack(
            children: [
              const SizedBox(height: 80),
              
              // 角色
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.2,
                  ),
                  child: FractionallySizedBox(
                    widthFactor: 0.83,
                    child: CharacterWidget(
                      characterName: widget.journey.character,
                      currentSegment: (currentSegmentIndex < botTextSegments.length)
                          ? botTextSegments[currentSegmentIndex]
                          : null,
                      changeHand: roundCount == 0, // 第一次進場揮手
                    ),
                  ),
                ),
              ),

              // 對話框
              Align(
                alignment: const Alignment(0.0, -0.47),
                  child: (isThinking || (isTalking && displayedText.isEmpty))
                    ? Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.08,
                          left: MediaQuery.of(context).size.width * 0.05,
                        ),
                        child: const Text(
                          "Thinking...",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.07,
                          vertical: MediaQuery.of(context).size.height * 0.02,
                        ),
                        margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.015,
                        ),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.82,
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
                            fontSize: MediaQuery.of(context).size.width * 0.052,
                            height: 1.4,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
              ),

              // 輸入區
              
              AnimatedPadding(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.05,
                  0,
                  MediaQuery.of(context).size.width * 0.05,
                  MediaQuery.of(context).viewInsets.bottom > 0
                      ? MediaQuery.of(context).viewInsets.bottom + 10
                      : MediaQuery.of(context).size.height * 0.1,
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: showGlow
                      ? AnswerGlowAnimation(child: userInputBox())
                      : userInputBox(),
                ),
              ),

              // 點我繼續
              if (!isTalking && currentSegmentIndex < botTextSegments.length - 1)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      setState(() => currentSegmentIndex++);
                      _startNextSegment();
                    },
                    child: Container(
                      width: 50,  // 可點擊區域寬度
                      height: 50, // 可點擊區域高度
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.5,
                        bottom: MediaQuery.of(context).size.height * 0.58,
                      ),
                      child: ContinueDotAnimation(
                        onTap: () {
                          setState(() => currentSegmentIndex++);
                          _startNextSegment();
                        },
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      // script 浮動按鈕
      floatingActionButton: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.03,   // 左
            bottom: MediaQuery.of(context).size.height * 0.005, // 下
          ),
          child: Opacity(
            opacity: 0.55,
            child: SizedBox(
              width: 44,
              height: 44,
              child: FloatingActionButton(
                backgroundColor: const Color.fromARGB(255, 249, 244, 218),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Script'),
                      content: SingleChildScrollView(
                        child: Text(widget.conversationContent.script),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
                tooltip: 'Show Script',
                child: const Icon(Icons.text_snippet, color: Colors.black87, size: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }

  
  Widget userInputBox() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(
          MediaQuery.of(context).size.width * 0.04,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
          if (showGlow)
            BoxShadow(
              color: const Color(0xFF40CCFF).withOpacity(0.6), // 淡藍光
              blurRadius: 18,
              spreadRadius: 1.5,
            ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
        vertical: MediaQuery.of(context).size.height * 0.015,
      ),
      child: Row(
        children: [
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
            onPressed: handleResponse,
            child: const Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }

}

