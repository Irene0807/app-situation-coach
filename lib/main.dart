import 'package:app_situational_coach/repositories/user_repository.dart';
import 'package:app_situational_coach/services/authentication.dart';
import 'package:app_situational_coach/services/database.dart';
import 'package:app_situational_coach/states/user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'services/navigation.dart';
import 'states/character_notifier.dart';
import 'states/conversation_notifier.dart';
import 'states/journey_list_notifier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'firebase_options.dart';
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

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Defer the first frame until `FlutterNativeSplash.remove()` is called
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Make sure you have your Firebase options configured
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize services
  AuthenticationService authService = AuthenticationService();
  DatabaseService dbService = DatabaseService();

  // Initialize repositories
  UserRepository userRepository =
      UserRepository(authService: authService, dbService: dbService);

  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => CharacterNotifier()),
        // ChangeNotifierProvider(create: (_) => ConversationNotifier()),
        // ChangeNotifierProvider(create: (_) => SettingNotifier()),
        ChangeNotifierProvider(
            create: (_) => JourneyListNotifier()..addAll(dummyJourneys)),

        ChangeNotifierProvider<UserNotifier>(
          create: (_) => UserNotifier(userRepository),
        ),
      ],
      child: const App(),
    ),
  );

  // Remove splash screen once auth state is initialized
  FlutterNativeSplash.remove();
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
