import 'package:app_situational_coach/states/user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'page_journey_add_prompt.dart';
import 'page_journey_add_correct.dart';
import '../services/gemini/journey_generator.dart';
import '../models/journey.dart';
import '../states/journey_list_notifier.dart';
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

  Future<void> submitJourney(String name, int day, String character,
      String description, String goal) async {
    // 包在loading裡面
    await runWithLoading(context, () async {
      //使用 plan 生成 schedule
      List<Day> schedule = await _journeyGenerator.generateJourneySchedule(
          name, day, character, description, goal);

      // 每個旅程初始的bloom都是1
      int bloomLevel = 1;

      // 新增 journey 到資料庫
      final journey = Journey(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // 產生id的方式?!
        name: name,
        day: day,
        character: character,
        description: description,
        learningGoal: goal,
        schedule: schedule,
        bloomLevel: bloomLevel,
        status: JourneyStatus(),
      );

      // 上傳db
      if (!mounted) return;
      await Provider.of<UserNotifier>(context, listen: false)
          .uploadJourney(journey);

      // 先跑好第一個scene的Content
      await schedule[0].scenes[0].generateAllContent(journey: journey);

      // 上傳db
      if (!mounted) return;
      await Provider.of<UserNotifier>(context, listen: false)
          .initializeSceneContent(
              journey.id, schedule[0].scenes[0].id, schedule[0].scenes[0]);

      if (!mounted) return;
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
