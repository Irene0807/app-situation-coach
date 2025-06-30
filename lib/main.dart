import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'services/navigation.dart';

import 'state/journey_state_notifier.dart';
import 'state/character_notifier.dart';
import 'state/conversation_notifier.dart';
import 'state/journey_list_notifier.dart';
import 'state/setting_notifier.dart';

import 'data/dummy_data.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: const Color.fromARGB(255, 0, 103, 131),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => JourneyStateNotifier()),
        ChangeNotifierProvider(create: (_) => CharacterNotifier()),
        ChangeNotifierProvider(create: (_) => ConversationNotifier()),
        ChangeNotifierProvider(create: (_) => JourneyListNotifier()..addAll(dummyJourneys)),
        ChangeNotifierProvider(create: (_) => SettingNotifier()),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: theme,
      routerConfig: routerConfig,
      restorationScopeId: 'app',
    );
  }
}
