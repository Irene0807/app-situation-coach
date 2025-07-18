import 'package:flutter/material.dart';
import '../models/journey.dart';
import '../models/message.dart';
import '../services/script_generator.dart';
import '../services/response_generator.dart';
import '../data/dummy_data.dart';

/*
此頁面僅供測試 & 說明 如何使用script_generator & response_generator（UI部分全是唬爛）
  - 測試一：生成script => script_generator
  - 測試二：生成response => response_generator
  
ps. 現在這版continue因為有大動script跟response，跟之前那版的continue很不一樣
    script跟response generator的取用參考這版會比較正確

這版未涵蓋的部分：
  - frame跟UI等state的切換(目前版本僅為測試用)
  - 目前的journey是從dummy_data取的，未接起來真正的journey_generator (因為不想每次測試都要建一次旅程)
    (dummyJourneys裡面需要把schedule填上才能取，我目前只填了第一個旅程 所以其他旅程還不能跑是正常的)

測試心得：
  - script大概30秒內可以生成，response很快 算蠻流暢的！
  - 對話內容：origin_script_generator的prompt要再改（詳細內容參考origin_script_prompt.dart）
*/

class PageJourneyContinue extends StatefulWidget {
  final String journeyId; // 傳進來的旅程 ID
  const PageJourneyContinue({super.key, required this.journeyId});

  @override
  State<PageJourneyContinue> createState() => _PageJourneyContinueState();
}

class _PageJourneyContinueState extends State<PageJourneyContinue> {
  Journey? journey;
  int selectedDay = 1;
  int selectedScene = 1;
  String script = '';
  final List<Message> history = [];
  ResponseGenerator? responseGenerator;
  String aiResponse = '';
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 這裡暫時寫的是去 dummyJourneys 找對應旅程
    final id = widget.journeyId.replaceFirst(':', '');
    journey = dummyJourneys.firstWhere(
      (j) => j.id == id,
      orElse: () => Journey(
        id: '',
        name: '',
        day: 1,
        character: '',
        description: '',
        learningGoal: '',
        schedule: {},
      ),
    );
  }

  // 測試一：生成script => script_generator
  Future<void> generateScript() async {
    setState(() {
      script = 'Generating...';
    });
    final result = await ScriptGenerator().generateRefinedScript(
      journey: journey!,
      day: selectedDay,
      scene: selectedScene,
      userBloomLevel: 0.5,
      character: journey!.character,
    );
    setState(() {
      script = result;
      responseGenerator = ResponseGenerator(script: script, history: history);
    });
  }

  // 測試二：生成response => response_generator
  Future<void> handleResponse() async {
    if (responseGenerator == null) return;
    final input = _controller.text;
    _controller.clear();
    final response = await responseGenerator!.generateResponse(input);
    setState(() {
      aiResponse = response;
    });
  }

  // 按下 "Start Conversation" 按鈕後 讓機器人先說出第一句話
  Future<void> startConversation() async {
    if (responseGenerator == null) return;
    final response = await responseGenerator!.generateResponse("Hello");
    setState(() {
      aiResponse = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (journey == null) {
      return const Scaffold(
        body: Center(child: Text('Journey not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Journey: ${journey!.name}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 上方控制列：選 Day / Scene，並按下產生script
              Row(
                children: [
                  DropdownButton<int>(
                    value: selectedDay,
                    items: [1, 2, 3].map((d) => DropdownMenuItem(value: d, child: Text('Day $d'))).toList(),
                    onChanged: (v) => setState(() => selectedDay = v!),
                  ),
                  const SizedBox(width: 16),
                  DropdownButton<int>(
                    value: selectedScene,
                    items: [1, 2, 3].map((s) => DropdownMenuItem(value: s, child: Text('Scene $s'))).toList(),
                    onChanged: (v) => setState(() => selectedScene = v!),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: generateScript,
                    child: const Text('Generate Script'),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Text('Script:\n$script'), // 顯示目前script
              const Divider(),

              //下方控制列：按下後讓機器人先說出第一句話，然後開始後續對話
              ElevatedButton(
                  onPressed: startConversation,
                  child: const Text('Start Conversation'),
                ),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Your Input'),
                onSubmitted: (_) => handleResponse(),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: handleResponse,
                child: const Text('Send to AI'),
              ),
              const SizedBox(height: 16),
              Text('AI Response:\n$aiResponse'),
            ],
          ),
        ),
      ),
    );
  }
}
