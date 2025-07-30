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
      title: Text('${journey.name}'),
      content: Text(
          'Character: ${journey.character}\nCondition: ${journey.status.isCompleted() ? "Completed" : "Uncompleted"}'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            journey.status.isCompleted()
                ? context.go('/detail:${journey.id}')
                : context.go('/journey/continue:${journey.id}');
          },
          child: journey.status.isCompleted()
              ? const Text('Detail')
              : const Text('Continue'),
        ),
      ],
    );
  }
}

/* 
測試schedule時用的code

    content: SingleChildScrollView(
      child: Text((() {
        String s = '';
        for (int i = 0; i < journey.schedule.length; i++) {
          s += journey.schedule[i].title;
          s += '\n\n';
          for (int j = 0; j < journey.schedule[i].scenes.length; j++) {
            s += journey.schedule[i].scenes[j].title;
            s += '\n\n';
            s += journey.schedule[i].scenes[j].location;
            s += '\n\n';
            s += journey.schedule[i].scenes[j].learningTheme;
            s += '\n\n';
            s += journey.schedule[i].scenes[j].dialogueTopic;
            s += '\n\n';
          }
        }
        return s;
      })()),
    )
*/
