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
    dayController = TextEditingController(text: "3"); //測測可改1
    characterController = TextEditingController(text: widget.splitPlan['character']);
    descriptionController = TextEditingController(text: widget.splitPlan['description']);
    learningGoalController = TextEditingController(text: "Food");
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
                    // 1. 旅程名稱
                    _buildFrostedTextField(AppLocalizations.of(context)!.journey_name, nameController),
                    const SizedBox(height: 6),
                    // 2. 天數（固定）
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.day_fixed,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 1),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white30),
                          ),
                          child: const Text(
                            "3",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // 3. 角色（選擇）
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.character,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 1),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white30),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: characterController.text.isNotEmpty ? characterController.text : null,
                            dropdownColor: const Color.fromARGB(255, 160, 147, 184),
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            items: const [
                              DropdownMenuItem(value: "Trump", child: Text("Trump")),
                              DropdownMenuItem(value: "Harry Potter", child: Text("Harry Potter")),
                              DropdownMenuItem(value: "American Boy", child: Text("American Boy")),
                              DropdownMenuItem(value: "English Girl", child: Text("English Girl")),
                              DropdownMenuItem(value: "Teacher", child: Text("Teacher")),
                            ],
                            onChanged: (value) {
                              setState(() {
                                characterController.text = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // 4. 場景
                    _buildFrostedTextField(AppLocalizations.of(context)!.journey_description, descriptionController,
                        maxLines: 4),
                    const SizedBox(height: 6),
                    // 5. 主題（固定）
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.learning_goal_fixed,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 1),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white30),
                          ),
                          child: Text(
                            learningGoalController.text, // 固定 "Food"
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 6. A/B Group 選擇
                    ToggleButtons(
                      isSelected: [selectedGroup == 0, selectedGroup == 1],
                      onPressed: (index) {
                        setState(() => selectedGroup = index);
                      },
                      borderRadius: BorderRadius.circular(12),
                      selectedColor: Colors.white,
                      color: Colors.white70,
                      fillColor: const Color.fromARGB(255, 160, 147, 184),
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
