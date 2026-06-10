// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'vault_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcome => 'Welcome!';

  @override
  String get register => 'Register';

  @override
  String get unknownErrorMessage => 'An unknown error occured';

  @override
  String get connectAction => 'Connect';

  @override
  String get saveAction => 'Save';

  @override
  String get logoutAction => 'Sign out';

  @override
  String get addServerAction => 'Add Server';

  @override
  String get usernameLabel => 'Username';

  @override
  String get emailLabel => 'Email';

  @override
  String get vaultServerLabel => 'Vault Server';

  @override
  String get serverUrlLabel => 'Server URL';

  @override
  String get apiKeyLabel => 'Api Key';

  @override
  String failedConnectionTestMessage(Object error) {
    return 'Connection test failed: $error';
  }

  @override
  String failedConnectionSaveMessage(Object error) {
    return 'Failed to save connection: $error';
  }

  @override
  String get profileScreenTitle => 'Profile';

  @override
  String get vaultsScreenTitle => 'My Vaults';
}
