import 'package:app_situational_coach/models/question.dart';
import 'package:app_situational_coach/models/journey.dart';
import 'package:app_situational_coach/states/journey_status_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PagePreTest extends StatefulWidget {
  const PagePreTest({super.key});

  @override
  State<PagePreTest> createState() => _PagePreTestState();
}

class _PagePreTestState extends State<PagePreTest> {
  final PageController _pageController = PageController();
  late List<Question> questions;
  late List<int?> selectedAnswers;
  late List<bool> isSubmitted;
  int correctCnt = 0;

  @override
  void initState() {
    super.initState();
    final journey =
        Provider.of<JourneyStatusNotifier>(context, listen: false).journey;
    questions = journey.preTest ?? [];
    selectedAnswers = List<int?>.filled(questions.length, null);
    isSubmitted = List<bool>.filled(questions.length, false);
  }

  void _selectAnswer(int questionIndex, int selectedOption) {
    if (isSubmitted[questionIndex]) return;
    setState(() {
      selectedAnswers[questionIndex] = selectedOption;
    });
  }

  void _handleButtonPress(int questionIndex, bool isCorrect) {
    final isLast = questionIndex == questions.length - 1;
    if (!isSubmitted[questionIndex]) {
      if (selectedAnswers[questionIndex] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select an option')));
        return;
      }
      setState(() => isSubmitted[questionIndex] = true);
      // 記錄使用者選項
      Provider.of<JourneyStatusNotifier>(context, listen: false)
          .appendResponses(selectedAnswers[questionIndex]!);
      // 計算答對題數
      if (selectedAnswers[questionIndex] == questions[questionIndex].answerId) {
        correctCnt += 1;
      }
      if (isLast) {
        // 紀錄答對題數
        Provider.of<JourneyStatusNotifier>(context, listen: false)
            .appendCorrectNum(correctCnt);
        // 標記isPass
        Provider.of<JourneyStatusNotifier>(context, listen: false).setIsPass();
      }
    } else {
      if (!isLast) {
        _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
      }
    }
  }

  Widget _buildOptionRow(int questionIndex, int optionIndex) {
    final question = questions[questionIndex];
    final selected = selectedAnswers[questionIndex];
    final submitted = isSubmitted[questionIndex];
    final correct = question.answerId;

    final isCorrect = optionIndex == correct;
    final isSelected = optionIndex == selected;

    Icon? trailing;
    if (submitted) {
      if (isCorrect) {
        trailing =
            const Icon(Icons.check, color: Color.fromARGB(255, 0, 255, 8));
      } else if (isSelected && !isCorrect) {
        trailing =
            const Icon(Icons.close, color: Color.fromARGB(255, 255, 17, 0));
      }
    }

    return Theme(
      data: Theme.of(context).copyWith(
        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.greenAccent;
            }
            return const Color.fromARGB(132, 255, 255, 255);
          }),
        ),
      ),
      child: RadioListTile<int>(
        title: Row(
          children: [
            Expanded(
              child: Text(
                question.options[optionIndex],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
        value: optionIndex,
        groupValue: selected,
        onChanged:
            submitted ? null : (val) => _selectAnswer(questionIndex, val!),
        activeColor: Colors.greenAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                '🎯 Mission Start!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.amberAccent,
                  shadows: [
                    Shadow(
                        blurRadius: 4,
                        offset: Offset(1, 1),
                        color: Colors.black54),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Let’s see what you already know!",
                style: TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(224, 255, 255, 255),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 3.0),
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      final q = questions[index];
                      final submitted = isSubmitted[index];
                      final isLast = index == questions.length - 1;
                      final allDone = isSubmitted.every((s) => s);

                      String? feedback;
                      if (submitted && selectedAnswers[index] != null) {
                        final isCorrect = selectedAnswers[index] == q.answerId;
                        feedback = isCorrect ? "Nice job!" : "Oops! Almost!";
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Q${index + 1}. ${q.questionText}',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 12),
                          ...List.generate(q.options.length,
                              (i) => _buildOptionRow(index, i)),
                          const SizedBox(height: 20),
                          if (feedback != null)
                            Center(
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                opacity: 1.0,
                                child: Text(
                                  feedback,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: feedback.contains("Nice")
                                        ? Colors.greenAccent
                                        : Colors.redAccent,
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 40),
                          if (!(isLast && allDone))
                            Center(
                              child: ElevatedButton(
                                onPressed: () => _handleButtonPress(index,
                                    selectedAnswers[index] == q.answerId),
                                child: Text(submitted ? 'Next' : 'Submit'),
                              ),
                            )
                          else
                            const Center(
                              child: Text(
                                '✅ Pre-test complete! Ready to start your journey!',
                                style: TextStyle(
                                    color: Colors.greenAccent,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
