import 'package:app_situational_coach/states/journey_status_notifier.dart';
import 'package:flutter/material.dart';
import 'package:app_situational_coach/models/scene.dart';
import 'package:provider/provider.dart';

class PageSceneSummary extends StatefulWidget {
  final SummaryContent summaryContent;

  const PageSceneSummary({super.key, required this.summaryContent});

  @override
  State<PageSceneSummary> createState() => _PageSceneSummaryState();
}

class _PageSceneSummaryState extends State<PageSceneSummary> {
  final PageController _pageController = PageController();
  late List<int?> selectedAnswers;
  late List<bool> isSubmitted;

  @override
  void initState() {
    super.initState();
    final questionCount = widget.summaryContent.questions.length;
    selectedAnswers = List<int?>.filled(questionCount, null);
    isSubmitted = List<bool>.filled(questionCount, false);
  }

  void _selectAnswer(int questionIndex, int selectedOption) {
    if (isSubmitted[questionIndex]) return; // 禁止已提交後變更答案
    setState(() {
      selectedAnswers[questionIndex] = selectedOption;
    });
    // 儲存答案
    Provider.of<JourneyStatusNotifier>(context, listen: false)
        .appendAnswerIds(selectedOption);
  }

  void _handleButtonPress(int questionIndex) {
    final isLastQuestion =
        questionIndex == widget.summaryContent.questions.length - 1;

    if (!isSubmitted[questionIndex]) {
      // Submit 邏輯
      if (selectedAnswers[questionIndex] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an option')),
        );
        return;
      }
      setState(() {
        isSubmitted[questionIndex] = true;
      });

      // 如果是最後一題，且剛完成提交，就觸發 setIsPass()
      if (isLastQuestion) {
        Provider.of<JourneyStatusNotifier>(context, listen: false).setIsPass();
      }
    } else {
      // Next 邏輯
      if (questionIndex < widget.summaryContent.questions.length - 1) {
        _pageController.nextPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    }
  }

  Widget _buildOptionRow(int questionIndex, int optionIndex) {
    final question = widget.summaryContent.questions[questionIndex];
    final selected = selectedAnswers[questionIndex];
    final correct = question.answerId;
    final submitted = isSubmitted[questionIndex];

    final isCorrect = optionIndex == correct;
    final isSelected = optionIndex == selected;

    Icon? trailingIcon;
    if (submitted) {
      if (isCorrect) {
        trailingIcon = const Icon(Icons.check, color: Colors.green);
      } else if (isSelected && !isCorrect) {
        trailingIcon = const Icon(Icons.close, color: Colors.red);
      }
    }

    return RadioListTile<int>(
      title: Row(
        children: [
          Expanded(
            child: Text(
              question.options[optionIndex],
              style: const TextStyle(color: Colors.white),
            ),
          ),
          if (trailingIcon != null) trailingIcon,
        ],
      ),
      value: optionIndex,
      groupValue: selected,
      onChanged:
          (submitted ? null : (val) => _selectAnswer(questionIndex, val!)),
      activeColor: Colors.greenAccent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final summary = widget.summaryContent.summary;
    final questions = widget.summaryContent.questions;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                summary,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.white54),
              const SizedBox(height: 16),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    final question = questions[index];
                    final submitted = isSubmitted[index];
                    final isLastQuestion = index == questions.length - 1;
                    final allAnswered = isSubmitted.every((s) => s);

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Question ${index + 1}: ${question.questionText}',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 12),
                          ...List.generate(
                              question.options.length,
                              (optionIndex) =>
                                  _buildOptionRow(index, optionIndex)),
                          const SizedBox(height: 12),
                          if (!(isLastQuestion && allAnswered))
                            Center(
                              child: ElevatedButton(
                                onPressed: () => _handleButtonPress(index),
                                child: Text(submitted ? 'Next' : 'Submit'),
                              ),
                            )
                          else if (isLastQuestion && allAnswered)
                            const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                '✅ All done! Great work',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.greenAccent,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
