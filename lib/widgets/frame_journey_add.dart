import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../widgets/page_journey_add_prompt.dart';
import '../widgets/page_journey_add_correct.dart';
import '../services/journey_generator.dart';
import '../models/journey.dart';
import '../state/journey_list_notifier.dart';
import 'func_run_with_loading.dart';
import '../models/day.dart';
import '../models/status.dart';

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

  Future<void> goToCorrectPage(String userInput) async {
    //使用 userInput 生成 plan
    Map<String, String> plan = await runWithLoading(context, () async {
      Map<String, String> p =
          await _journeyGenerator.generateJourneyPlan(userInput);
      return p;
    });

    //換頁
    setState(() {
      _splitPlan = plan;
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

  // // Helper function to parse schedule string into a map
  // Map<String, String> parseScheduleToMap(String schedule) {
  //   final Map<String, String> map = {};
  //   // 修改正則表達式以符合 <<key>> <<value>> 格式，允許 value 跨行
  //   final regex = RegExp(r'<<(.+?)>>\s*<<([\s\S]*?)>>', dotAll: true);
  //   for (final match in regex.allMatches(schedule)) {
  //     final key = match.group(1)?.trim() ?? '';
  //     final value = match.group(2)?.trim() ?? '';
  //     if (key.isNotEmpty) {
  //       map[key] = value;
  //     }
  //   }
  //   return map;
  // }

  Future<void> submitJourney(String name, int day, String character,
      String description, String goal) async {
    // 包在loading裡面
    await runWithLoading(context, () async {
      //使用 plan 生成 schedule
      String newPlan =
          combinePlanFields(name, day, character, description, goal);
      List<Day> schedule =
          await _journeyGenerator.generateJourneySchedule(newPlan);

      // debug
      if (schedule.length != day) {
        throw Exception('schedule.length != day\n');
      }

      // 保護 context
      if (!mounted) return;

      // 新增 journey 到資料庫
      final journey = Journey(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // 產生id的方式?!
        name: name,
        day: day,
        character: character,
        description: description,
        learningGoal: goal,
        schedule: schedule,
        status: JourneyStatus(), //
      );

      Provider.of<JourneyListNotifier>(context, listen: false)
          .addJourney(journey);

      context.pop(); // 返回上一頁
    });
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
            'assets/images/journey_start_background.jpg',
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
