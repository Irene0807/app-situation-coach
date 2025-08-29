import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';

import 'services/navigation.dart';

import 'state/character_notifier.dart';
import 'state/conversation_notifier.dart';
import 'state/journey_list_notifier.dart';
import 'state/setting_notifier.dart';

import 'data/dummy_data.dart';

// 關於UI語言調整的部分 可能要把語言設定寫到DB 否則每次開app都會被重置

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
        // 只有FrameJourneyContinue需要 故從router那邊餵過去
        // ChangeNotifierProvider(create: (_) => JourneyStateNotifier()),
        ChangeNotifierProvider(create: (_) => CharacterNotifier()),
        ChangeNotifierProvider(create: (_) => ConversationNotifier()),
        ChangeNotifierProvider(
            create: (_) => JourneyListNotifier()..addAll(dummyJourneys)),
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
      // UI語言 系統語言中文->中文 系統語言其他->英文
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [
        Locale('en'),
        Locale('zh'),
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale != null && locale.languageCode == 'zh') {
          return const Locale('zh'); // 中文
        }
        return const Locale('en'); // 其他語言 → 英文
      },
    );
  }
}
