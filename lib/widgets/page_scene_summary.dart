import 'package:app_situational_coach/states/journey_status_notifier.dart';
import 'package:flutter/material.dart';
import 'package:app_situational_coach/models/journey.dart';
import 'package:app_situational_coach/models/scene.dart';
import 'package:provider/provider.dart';
import '../widgets/animations/character_animation.dart';

class PageSceneSummary extends StatefulWidget {
  final SummaryContent summaryContent;
  final Journey? journey;

  const PageSceneSummary({
    super.key,
    required this.summaryContent,
    this.journey,
  });

  @override
  State<PageSceneSummary> createState() => _PageSceneSummaryState();
}

class _PageSceneSummaryState extends State<PageSceneSummary> {
  late final PageController _pageController;
  late final int _qCount;
  late List<bool> _hasAnswered;
  late List<int?> _selectedIndex;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _qCount = widget.summaryContent.questions.length;
    _hasAnswered = List<bool>.filled(_qCount, false);
    _selectedIndex = List<int?>.filled(_qCount, null);
  }

  void _nextPage() {
    if (_currentIndex < _qCount - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final questions = widget.summaryContent.questions;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Title
            Transform.translate(
              offset: Offset(0, -screenHeight * 0.39),
              child: Text(
                "After our journey!",
                style: TextStyle(
                  fontSize: screenWidth * 0.08,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.5,
                  shadows: [
                    Shadow(
                        blurRadius: 6,
                        offset: Offset(1, 1),
                        color: Colors.black45)
                  ],
                ),
              ),
            ),

            // 黑板
            Transform.translate(
              offset: const Offset(0, 20),
              child: SizedBox(
                width: screenWidth * 0.95,
                height: screenHeight * 0.7,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/billboard.png',
                        fit: BoxFit.contain,
                      ),
                    ),

                    // 問題頁
                    Align(
                      alignment: const Alignment(0, -0.4),
                      child: PageView.builder(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _qCount,
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final question = questions[index];
                          final hasAnswered = _hasAnswered[index];
                          final selectedIndex = _selectedIndex[index];

                          Color getButtonColor(int i) {
                            if (!hasAnswered)
                              return Colors.white.withOpacity(0.15);
                            if (i == question.answerId)
                              return Colors.greenAccent.withOpacity(0.75);
                            if (i == selectedIndex &&
                                selectedIndex != question.answerId)
                              return Colors.redAccent.withOpacity(0.75);
                            return Colors.white.withOpacity(0.05);
                          }

                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.1,
                              vertical: screenHeight * 0.1,
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    question.questionText,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.055,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      height: 1.5,
                                      shadows: const [
                                        Shadow(
                                            blurRadius: 4,
                                            offset: Offset(1, 1),
                                            color: Colors.black45)
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.04),
                                  ...List.generate(question.options.length,
                                      (i) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: screenHeight * 0.008),
                                      child: SizedBox(
                                        width: screenWidth * 0.75,
                                        height: screenHeight * 0.07,
                                        child: ElevatedButton(
                                          onPressed: hasAnswered
                                              ? null
                                              : () async {
                                                  final isCorrect =
                                                      (i == question.answerId);

                                                  setState(() {
                                                    _hasAnswered[index] = true;
                                                    _selectedIndex[index] = i;
                                                  });

                                                  Provider.of<JourneyStatusNotifier>(
                                                          context,
                                                          listen: false)
                                                      .appendResponses(
                                                          isCorrect);

                                                  final isLast =
                                                      index == _qCount - 1;

                                                  if (isLast) {
                                                    await Future.delayed(
                                                        const Duration(
                                                            milliseconds: 300));
                                                    Provider.of<JourneyStatusNotifier>(
                                                            context,
                                                            listen: false)
                                                        .setIsPass();
                                                  } else {
                                                    await Future.delayed(
                                                        const Duration(
                                                            seconds: 1));
                                                    _nextPage();
                                                  }
                                                },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: getButtonColor(i),
                                            disabledBackgroundColor:
                                                getButtonColor(i),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              side: const BorderSide(
                                                  color: Colors.white30),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              vertical: screenHeight * 0.01,
                                              horizontal: screenWidth * 0.04,
                                            ),
                                          ),
                                          child: Text(
                                            question.options[i],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: screenWidth * 0.045,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                  if (index == _qCount - 1 &&
                                      _hasAnswered[index])
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: screenHeight * 0.01),
                                      child: const Text(
                                        "Let's go on to next scene!",
                                        style: TextStyle(
                                          color: Colors.greenAccent,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
