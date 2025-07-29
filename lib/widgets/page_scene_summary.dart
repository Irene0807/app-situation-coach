import 'package:flutter/material.dart';
import 'package:app_situational_coach/models/scene.dart';

class PageSceneSummary extends StatefulWidget {
  final SummaryContent summaryContent;

  const PageSceneSummary({super.key, required this.summaryContent});

  @override
  State<PageSceneSummary> createState() => _PageSceneSummaryState();
}

class _PageSceneSummaryState extends State<PageSceneSummary> {
  final PageController _pageController = PageController();
  late List<int?> selectedAnswers;

  @override
  void initState() {
    super.initState();
    selectedAnswers =
        List<int?>.filled(widget.summaryContent.questions.length, null);
  }

  void _selectAnswer(int questionIndex, int selectedOption) {
    setState(() {
      selectedAnswers[questionIndex] = selectedOption;
    });
  }

  void _submitAnswer(int questionIndex) {
    final selected = selectedAnswers[questionIndex];
    if (selected == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('請先選擇一個選項')),
      );
      return;
    }

    // 如果不是最後一題，跳到下一題；是最後一題可換成顯示總結或完成畫面
    if (questionIndex < widget.summaryContent.questions.length - 1) {
      _pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('完成'),
          content: Text('你已完成所有題目'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('確定'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final summary = widget.summaryContent.summary;
    final questions = widget.summaryContent.questions;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Summary 區塊
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

                // 題目 PageView
                SizedBox(
                  height: 400, // 給足夠空間顯示題目與選項
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      final question = questions[index];
                      return Column(
                        mainAxisSize: MainAxisSize.min,
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

                          // 選項列表
                          ...List.generate(question.options.length,
                              (optionIndex) {
                            return RadioListTile<int>(
                              title: Text(
                                question.options[optionIndex],
                                style: const TextStyle(color: Colors.white),
                              ),
                              value: optionIndex,
                              groupValue: selectedAnswers[index],
                              onChanged: (value) {
                                if (value != null) _selectAnswer(index, value);
                              },
                              activeColor: Colors.greenAccent,
                            );
                          }),

                          const SizedBox(height: 12),

                          Center(
                            child: ElevatedButton(
                              onPressed: () => _submitAnswer(index),
                              child: const Text('Next'),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
