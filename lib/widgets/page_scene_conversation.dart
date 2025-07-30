import 'package:flutter/material.dart';
import '../models/scene.dart';
import '../services/response_generator.dart';

/*
這版未涵蓋的部分：
  - dummyJourneys目前無法正常運作 要新建的journey才可以

測試心得：
  - 對話內容：origin_script_generator的prompt要再改（詳細內容參考origin_script_prompt.dart）
*/

class PageSceneConversation extends StatefulWidget {
  final ConversationContent conversationContent; // 改成傳scene
  const PageSceneConversation({super.key, required this.conversationContent});

  @override
  State<PageSceneConversation> createState() => _PageSceneConversationState();
}

class _PageSceneConversationState extends State<PageSceneConversation> {
  ResponseGenerator? responseGenerator;
  String aiResponse = '';
  final TextEditingController _controller = TextEditingController();
  int roundCount = 0;

  @override
  void initState() {
    super.initState();

    final conv = widget.conversationContent;
    responseGenerator = ResponseGenerator(conversation: conv);

    // 進入頁面後，等待一秒角色開始主動對話
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 1), () async {
        await startConversation(); // 主動講第一句話
      });
    });
  }

  // 生成response => response_generator
  Future<void> handleResponse() async {
    if (responseGenerator == null) return;
    if (roundCount >= 20) return;

    final input = _controller.text;
    _controller.clear();
    final response = await responseGenerator!.generateResponse(input);
    setState(() {
      roundCount++;
      if (roundCount >= 20) {
        aiResponse =
            "$response\n\nThat’s all for our chat today. See you later!";
      } else {
        aiResponse = response;
      }
    });
  }

  // 讓角色主動講第一句話
  Future<void> startConversation() async {
    if (responseGenerator == null) return;
    final response = await responseGenerator!.generateResponse("Hello.");
    setState(() {
      roundCount = 1;
      aiResponse = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('只有傳ConversationContent進來')),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // AI回應區
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (aiResponse.isNotEmpty) ...[
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('🤖 $aiResponse'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // 使用者輸入回答區
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Say something...',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => handleResponse(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: handleResponse,
                )
              ],
            ),
          ),
        ],
      ),

      // 測試demo用：顯示當前給角色的script
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // final scriptText = widget.conversationContent?.script ?? 'No script available';
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
        child: const Icon(Icons.text_snippet),
      ),
    );
  }
}
