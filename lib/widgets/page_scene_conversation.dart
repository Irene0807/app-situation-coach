import 'package:flutter/material.dart';
import '../widgets/agents/agent_controller.dart';
import 'package:provider/provider.dart';
import '../state/conversation_notifier.dart';

class PageSceneConversation extends StatefulWidget {
  final String journeyId;
  final String topic;
  final String place;
  final int day;

  const PageSceneConversation({
    super.key,
    required this.journeyId,
    this.topic = 'garbage dump',
    this.place = 'America garbage dump',
    this.day = 1,
  });

  @override
  State<PageSceneConversation> createState() => _PageSceneConversationState();
}

class _PageSceneConversationState extends State<PageSceneConversation> {
  final TextEditingController _controller = TextEditingController();
  final AgentController _agentController = AgentController();

  String _aiResponse = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _startDialogue(); // 一開始產出第一句
  }

  Future<void> _startDialogue({String userInput = 'Hello!'}) async {
    final conversationNotifier = context.read<ConversationNotifier>();

    setState(() {
      _loading = true;
      _aiResponse = '';
    });

    final response = await _agentController.runDialogueRound(
      character: 'Donald Trump',
      history:
      'Day ${widget.day}\nPlace: ${widget.place}\nTopic: ${widget.topic}\n\n' +
      conversationNotifier.messages.map((m) => m.content).join('\n'),
      userInput: userInput,
      userHistoryAnswers: conversationNotifier.userMessages,
    );

    // 存這輪對話
    conversationNotifier.addUserMessage(userInput);
    conversationNotifier.addAiMessage(response);

    setState(() {
      _aiResponse = response;
      _loading = false;
    });
  }


  Future<void> _submitAnswer() async {
    if (_controller.text.isEmpty) return;

    final userText = _controller.text;
    _controller.clear();

    await _startDialogue(userInput: userText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Journey: ${widget.journeyId}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('AI:', style: Theme.of(context).textTheme.titleMedium),
                  Text(_aiResponse, style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(labelText: 'Your reply'),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _submitAnswer,
                    child: const Text("Send"),
                  ),
                ],
              ),
      ),
    );
  }
}
