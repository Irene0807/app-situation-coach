import 'package:app_situational_coach/l10n/app_localizations.dart';
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
      title: Text(journey.name),
      content: Text(
          '${AppLocalizations.of(context)!.character}: ${journey.character}\n${AppLocalizations.of(context)!.condition}: ${journey.status.isCompleted() ? AppLocalizations.of(context)!.completed : AppLocalizations.of(context)!.uncompleted}'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            journey.status.isCompleted()
                ? context.go('/home/detail:${journey.id}')
                : context.go('/home/journey/continue:${journey.id}');
          },
          child: journey.status.isCompleted()
              ? Text(AppLocalizations.of(context)!.detail)
              : Text(AppLocalizations.of(context)!.continue_),
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
