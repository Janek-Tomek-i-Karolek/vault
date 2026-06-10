// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'vault_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get welcome => 'Witamy w kolonii!';

  @override
  String get register => 'Zarejestruj';

  @override
  String get unknownErrorMessage => 'Wystąpił nieoczekiwany błąd';

  @override
  String get connectAction => 'Połącz';

  @override
  String get saveAction => 'Save';

  @override
  String get logoutAction => 'Sign out';

  @override
  String get usernameLabel => 'Username';

  @override
  String get emailLabel => 'Email';

  @override
  String failedConnectionTestMessage(Object error) {
    return 'Nie udało się połączyć: $error';
  }

  @override
  String failedConnectionSaveMessage(Object error) {
    return 'Nie udało się zapisać połączenia: $error';
  }

  @override
  String get profileScreenTitle => 'Profile';
}
