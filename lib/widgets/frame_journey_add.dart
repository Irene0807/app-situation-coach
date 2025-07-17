import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../widgets/page_journey_add_prompt.dart';
import '../widgets/page_journey_add_correct.dart';
import '../services/journey_generator.dart';
import '../models/journey.dart';
import '../state/journey_list_notifier.dart';

enum FrameJourneyAddTab {
  prompt,
  correct,
}

// 狀態會動 所以用StatefulWidget
class FrameJourneyAdd extends StatefulWidget {
  const FrameJourneyAdd({super.key, required this.selectedTab});

  final FrameJourneyAddTab selectedTab;

  @override
  State<FrameJourneyAdd> createState() => _FrameJourneyAddState();
}

class _FrameJourneyAddState extends State<FrameJourneyAdd>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late TabController _tabController;
  late int _currentIndex;
  Map<String, String> _splitPlan = {};
  final JourneyGenerator _journeyGenerator = JourneyGenerator(); // 新增

  // 移除原本的 pages，改用 getter 以便傳遞 callback
  List<Widget> get pages => [
        PageJourneyAddPrompt(onLetsGo: goToCorrectPage),
        PageJourneyAddCorrect(splitPlan: _splitPlan, onFinish: submitJourney),
      ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedTab.index;
    _pageController = PageController(initialPage: _currentIndex);
    _tabController = TabController(length: pages.length, vsync: this);
    _tabController.index = _currentIndex;
  }

  // Function to extract value for a key from the plan string
  String extractValue(String key, String text) {
    final regex = RegExp(r'<<' + key + r'>>\s*([\s\S]*?)(?=(<<|$))');
    final match = regex.firstMatch(text);
    return match != null ? match.group(1)?.trim() ?? '' : '';
  }

  Map<String, String> getSplitPlan(String plan) {
    // List of keys to extract
    final List<String> keys = [
      'name',
      'day',
      'character',
      'description',
      'goal'
    ];
    Map<String, String> splitPlan = {
      for (var key in keys) key: extractValue(key, plan)
    };
    return splitPlan;
  }

  Future<void> goToCorrectPage(String userInput) async {
    //使用 userInput 生成 plan
    String plan = await _journeyGenerator.generateJourneyPlan(userInput);

    //換頁
    setState(() {
      _splitPlan = getSplitPlan(plan);
    });
    _pageController.animateToPage(
      FrameJourneyAddTab.correct.index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
    _tabController.index = FrameJourneyAddTab.correct.index;
  }

  // 將欄位組合成原始格式的 plan 字串
  String combinePlanFields(
      String name, int day, String character, String description, String goal) {
    return '''
Journey name: $name
Number of days: $day
Companion: $character
Journey description: $description
Learning Goal: $goal
''';
  }

  // Helper function to parse schedule string into a map
  Map<String, String> parseScheduleToMap(String schedule) {
    final Map<String, String> map = {};
    // 修改正則表達式以符合 <<key>> <<value>> 格式，允許 value 跨行
    final regex = RegExp(r'<<(.+?)>>\s*<<([\s\S]*?)>>', dotAll: true);
    for (final match in regex.allMatches(schedule)) {
      final key = match.group(1)?.trim() ?? '';
      final value = match.group(2)?.trim() ?? '';
      if (key.isNotEmpty) {
        map[key] = value;
      }
    }
    return map;
  }

  Future<void> submitJourney(String name, int day, String character,
      String description, String goal) async {
    //使用 plan 生成 schedule
    String newPlan = combinePlanFields(name, day, character, description, goal);
    String schedule = await _journeyGenerator.generateJourneySchedule(newPlan);

    // 保護 context
    if (!mounted) return;

    //把schedule轉成map格式
    Map<String, String> scheduleMap = parseScheduleToMap(schedule);

    // 新增 journey 到資料庫
    final journey = Journey(
      id: UniqueKey().toString(), // 產生id的方式?!
      name: name,
      day: day,
      character: character,
      description: description,
      learningGoal: goal,
      schedule: scheduleMap,
      isCompleted: false,
    );

    Provider.of<JourneyListNotifier>(context, listen: false)
        .addJourney(journey);

    // debug用 顯示生成的journey schedule
    setState(() {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: SingleChildScrollView(child: Text(schedule)),
              actions: [
                TextButton(
                  onPressed: () {
                    context.pop();
                    context.pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
    });

    // context.pop(); // 返回上一頁
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/add_background.png',
            fit: BoxFit.cover,
          ),
        ),
        PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(), // 禁止滑動翻頁
          children: pages,
        ),
      ],
    );
  }
}
