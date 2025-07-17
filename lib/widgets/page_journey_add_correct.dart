import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/journey_generator.dart';

//版面尚未設計完成

class PageJourneyAddCorrect extends StatelessWidget {
  final Map<String, String> splitPlan;
  final void Function(String, int, String, String, String) onFinish;
  const PageJourneyAddCorrect(
      {super.key, required this.splitPlan, required this.onFinish});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: splitPlan['name']);
    final TextEditingController dayController =
        TextEditingController(text: splitPlan['day']);
    final TextEditingController characterController =
        TextEditingController(text: splitPlan['character']);
    final TextEditingController descriptionController =
        TextEditingController(text: splitPlan['description']);
    final TextEditingController learningGoalController =
        TextEditingController(text: splitPlan['goal']);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('New Journey',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Journey Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: dayController,
                decoration: InputDecoration(
                  labelText: 'Day',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: characterController,
                decoration: InputDecoration(
                  labelText: 'Character',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Journey Description',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: learningGoalController,
                decoration: InputDecoration(
                  labelText: 'Learning Goal',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // 製作journey schedule
                  // 把journey確實新增到資料庫
                  onFinish(
                      nameController.text,
                      int.parse(dayController.text),
                      characterController.text,
                      descriptionController.text,
                      learningGoalController.text);
                  // 返回上一頁
                  // context.pop();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('Finish'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
