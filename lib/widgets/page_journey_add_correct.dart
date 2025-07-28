import 'package:flutter/material.dart';
import 'dart:ui';

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
      backgroundColor: Colors.transparent, // 你已經有圖片背景
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2), // 半透明白
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.4), width: 1),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'New Journey',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 2,
                            color: Colors.black45,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildFrostedTextField('Journey Name', nameController),
                    const SizedBox(height: 16),
                    _buildFrostedTextField('Day', dayController,
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 16),
                    _buildFrostedTextField('Character', characterController),
                    const SizedBox(height: 16),
                    _buildFrostedTextField(
                        'Journey Description', descriptionController,
                        maxLines: 4),
                    const SizedBox(height: 16),
                    _buildFrostedTextField(
                        'Learning Goal', learningGoalController,
                        maxLines: 4),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        onFinish(
                          nameController.text,
                          int.parse(dayController.text),
                          characterController.text,
                          descriptionController.text,
                          learningGoalController.text,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4B296B),
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Finish'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFrostedTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.white),
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white30),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white70, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
