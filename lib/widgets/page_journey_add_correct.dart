import 'package:app_situational_coach/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

//版面尚未設計完成

class PageJourneyAddCorrect extends StatefulWidget {
  final Map<String, String> splitPlan;
  final void Function(
    String name,
    int day,
    String character,
    String description,
    String goal,
    String group,
  ) onFinish;

  const PageJourneyAddCorrect({
    super.key,
    required this.splitPlan,
    required this.onFinish,
  });

  @override
  State<PageJourneyAddCorrect> createState() => _PageJourneyAddCorrectState();
}

class _PageJourneyAddCorrectState extends State<PageJourneyAddCorrect> {
  late TextEditingController nameController;
  late TextEditingController dayController;
  late TextEditingController characterController;
  late TextEditingController descriptionController;
  late TextEditingController learningGoalController;

  int selectedGroup = 0; // 0 = A, 1 = B

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.splitPlan['name']);
    dayController = TextEditingController(text: widget.splitPlan['day']);
    characterController = TextEditingController(text: widget.splitPlan['character']);
    descriptionController = TextEditingController(text: widget.splitPlan['description']);
    learningGoalController = TextEditingController(text: widget.splitPlan['goal']);
  }

  @override
  void dispose() {
    nameController.dispose();
    dayController.dispose();
    characterController.dispose();
    descriptionController.dispose();
    learningGoalController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.4), width: 1),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.new_journey,
                      style: const TextStyle(
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
                    _buildFrostedTextField(AppLocalizations.of(context)!.journey_name, nameController),
                    const SizedBox(height: 16),
                    _buildFrostedTextField(AppLocalizations.of(context)!.day, dayController,
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 16),
                    _buildFrostedTextField(AppLocalizations.of(context)!.character, characterController),
                    const SizedBox(height: 16),
                    _buildFrostedTextField(AppLocalizations.of(context)!.journey_description, descriptionController,
                        maxLines: 4),
                    const SizedBox(height: 16),
                    _buildFrostedTextField(AppLocalizations.of(context)!.learning_goal, learningGoalController,
                        maxLines: 4),
                    const SizedBox(height: 16),

                    // A/B Group 選擇
                    ToggleButtons(
                      isSelected: [selectedGroup == 0, selectedGroup == 1],
                      onPressed: (index) {
                        setState(() => selectedGroup = index);
                      },
                      borderRadius: BorderRadius.circular(12),
                      selectedColor: Colors.white, // 選中時字體白色
                      color: Colors.white70,        // 沒選中時字體淡白色
                      fillColor: const Color.fromARGB(255, 160, 147, 184), // 選中時背景紫色
                      constraints: const BoxConstraints(
                        minHeight: 36,
                        minWidth: 120,
                      ),
                      children: const [
                        Text("Group A"),
                        Text("Group B"),
                      ],
                    ),


                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        widget.onFinish(
                          nameController.text,
                          int.tryParse(dayController.text) ?? 1,
                          characterController.text,
                          descriptionController.text,
                          learningGoalController.text,
                          selectedGroup == 0 ? "A" : "B",
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4B296B),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(AppLocalizations.of(context)!.finish),
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
