import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'vault_localizations_en.dart';
import 'vault_localizations_fr.dart';
import 'vault_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/vault_localizations.dart';
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
    Locale('fr'),
    Locale('pl'),
  ];

  /// Register screen greeting
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @connectAction.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connectAction;

  /// No description provided for @saveAction.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveAction;

  /// No description provided for @loginAction.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginAction;

  /// No description provided for @createNewAccountAction.
  ///
  /// In en, this message translates to:
  /// **'Create new account'**
  String get createNewAccountAction;

  /// No description provided for @logoutAction.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get logoutAction;

  /// No description provided for @addServerAction.
  ///
  /// In en, this message translates to:
  /// **'Add Server'**
  String get addServerAction;

  /// No description provided for @addPhotosAction.
  ///
  /// In en, this message translates to:
  /// **'Add Photos'**
  String get addPhotosAction;

  /// No description provided for @addAlbumAction.
  ///
  /// In en, this message translates to:
  /// **'Add album'**
  String get addAlbumAction;

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @alreadyRegisteredQuestion.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyRegisteredQuestion;

  /// No description provided for @forgotPasswordQuestion.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPasswordQuestion;

  /// No description provided for @vaultServerLabel.
  ///
  /// In en, this message translates to:
  /// **'Vault Server'**
  String get vaultServerLabel;

  /// No description provided for @albumNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Album name'**
  String get albumNameLabel;

  /// No description provided for @serverUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Server URL'**
  String get serverUrlLabel;

  /// No description provided for @apiKeyLabel.
  ///
  /// In en, this message translates to:
  /// **'Api Key'**
  String get apiKeyLabel;

  /// No description provided for @unknownErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occured'**
  String get unknownErrorMessage;

  /// No description provided for @genericErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'An error occured: {error}'**
  String genericErrorMessage(Object error);

  /// No description provided for @failedConnectionTestMessage.
  ///
  /// In en, this message translates to:
  /// **'Connection test failed: {error}'**
  String failedConnectionTestMessage(Object error);

  /// No description provided for @failedConnectionSaveMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to save connection: {error}'**
  String failedConnectionSaveMessage(Object error);

  /// No description provided for @loadingIndicator.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loadingIndicator;

  /// No description provided for @profileScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileScreenTitle;

  /// No description provided for @vaultsScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'My Vaults'**
  String get vaultsScreenTitle;

  /// No description provided for @albumScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Album'**
  String get albumScreenTitle;

  /// No description provided for @albumsScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get albumsScreenTitle;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Vault'**
  String get appTitle;

  /// No description provided for @navBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get navBarTitle;

  /// No description provided for @albumsNavBarEntry.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get albumsNavBarEntry;

  /// No description provided for @serverListNavBarEntry.
  ///
  /// In en, this message translates to:
  /// **'Server List'**
  String get serverListNavBarEntry;
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
      <String>['en', 'fr', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
