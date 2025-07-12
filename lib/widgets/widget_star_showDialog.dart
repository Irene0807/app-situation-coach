import 'package:app_situational_coach/models/journey.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WidgetStarShowDialog extends StatelessWidget {
  final Journey journey;

  const WidgetStarShowDialog({
    required this.journey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('(待調整) ${journey.name}'),
      content: Text(
          'Character: ${journey.character}\nCondition: ${journey.isCompleted ? "Completed" : "Uncompleted"}'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            journey.isCompleted
                ? context.go('/detail:${journey.id}')
                : context.go('/journey/continue:${journey.id}');
          },
          child: journey.isCompleted
              ? const Text('Detail')
              : const Text('Continue'),
        ),
      ],
    );
  }
}
