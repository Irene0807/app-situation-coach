import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// page_home.dart
  ///
  /// In en, this message translates to:
  /// **'START'**
  String get start;

  /// page_journey_start.dart
  ///
  /// In en, this message translates to:
  /// **'Start Your Journey'**
  String get start_your_journey;

  /// page_journey_start.dart
  ///
  /// In en, this message translates to:
  /// **'Create New Journey'**
  String get create_new_journey;

  /// page_journey_start.dart
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get go_back;

  /// page_journey_add_prompt.dart
  ///
  /// In en, this message translates to:
  /// **'describe your journey here'**
  String get describe_your_journey_here;

  /// page_journey_add_prompt.dart
  ///
  /// In en, this message translates to:
  /// **'Let\'s Go'**
  String get lets_go;

  /// widget_letter.dart
  ///
  /// In en, this message translates to:
  /// **'Dear Traveler,\n\n    Imagine your ideal journey.\n    Where would you go?\n    How long would you stay?\n    What would you experience?\n    What’s the purpose of your adventure?\n\n    Describe it freely.\n\n\n\n\n\n\n\n                                              Your Best'**
  String get letter_content;

  /// widget_loading_mark.dart
  ///
  /// In en, this message translates to:
  /// **'I\'m thinking, bigly...'**
  String get im_thinking_bigly;

  /// widget_loading_mark.dart
  ///
  /// In en, this message translates to:
  /// **'Hold on, this is gonna be great.'**
  String get hold_on_this_is_gonna_be_great;

  /// widget_loading_mark.dart
  ///
  /// In en, this message translates to:
  /// **'Processing... Believe me.'**
  String get processing_believe_me;

  /// widget_loading_mark.dart
  ///
  /// In en, this message translates to:
  /// **'Tremendous results incoming!'**
  String get tremendous_results_incoming;

  /// widget_loading_mark.dart
  ///
  /// In en, this message translates to:
  /// **'Just a moment. Very important stuff.'**
  String get just_a_moment_very_important_stuff;

  /// widget_loading_mark.dart
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// page_journey_add_correct.dart
  ///
  /// In en, this message translates to:
  /// **'New Journey'**
  String get new_journey;

  /// page_journey_add_correct.dart
  ///
  /// In en, this message translates to:
  /// **'Journey Name'**
  String get journey_name;

  /// page_journey_add_correct.dart
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// page_journey_add_correct.dart + widget_star_showDialog.dart
  ///
  /// In en, this message translates to:
  /// **'Character'**
  String get character;

  /// page_journey_add_correct.dart
  ///
  /// In en, this message translates to:
  /// **'Journey Description'**
  String get journey_description;

  /// page_journey_add_correct.dart
  ///
  /// In en, this message translates to:
  /// **'Learning Goal'**
  String get learning_goal;

  /// page_journey_add_correct.dart
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// widget_star_showDialog.dart
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get condition;

  /// widget_star_showDialog.dart
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// widget_star_showDialog.dart
  ///
  /// In en, this message translates to:
  /// **'Uncompleted'**
  String get uncompleted;

  /// widget_star_showDialog.dart
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// widget_star_showDialog.dart
  ///
  /// In en, this message translates to:
  /// **'Detail'**
  String get detail;

  /// widget_star_showDialog.dart
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_;

  /// page_character.dart
  ///
  /// In en, this message translates to:
  /// **'years old'**
  String get years_old;

  /// page_character.dart
  ///
  /// In en, this message translates to:
  /// **'Your Travel Companion'**
  String get your_travel_companion;

  /// page_character.dart
  ///
  /// In en, this message translates to:
  /// **'Tap the card to view the back'**
  String get tap_the_card_to_view_the_back;

  /// page_character.dart
  ///
  /// In en, this message translates to:
  /// **'Background'**
  String get background;

  /// page_character.dart
  ///
  /// In en, this message translates to:
  /// **'Personality Traits'**
  String get personality_traits;

  /// page_character.dart
  ///
  /// In en, this message translates to:
  /// **'Tone and Style'**
  String get tone_and_style;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
