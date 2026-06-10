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
  String get connectAction => 'Połącz';

  @override
  String get saveAction => 'Zapisz';

  @override
  String get loginAction => 'Zaloguj';

  @override
  String get createNewAccountAction => 'Utwórz nowe konto';

  @override
  String get logoutAction => 'Wyloguj';

  @override
  String get addServerAction => 'Dodaj serwer';

  @override
  String get addPhotosAction => 'Dodaj zdjęcia';

  @override
  String get addAlbumAction => 'Add album';

  @override
  String get usernameLabel => 'Nazwa użytkownika';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Hasło';

  @override
  String get alreadyRegisteredQuestion => 'Masz już konto?';

  @override
  String get forgotPasswordQuestion => 'Zapomniałeś/aś hasła?';

  @override
  String get vaultServerLabel => 'Serwer Vault';

  @override
  String get albumNameLabel => 'Album name';

  @override
  String get serverUrlLabel => 'URL Serwera';

  @override
  String get apiKeyLabel => 'Klucz Api';

  @override
  String get unknownErrorMessage => 'Wystąpił nieoczekiwany błąd';

  @override
  String genericErrorMessage(Object error) {
    return 'Wystąpił błąd: $error';
  }

  @override
  String failedConnectionTestMessage(Object error) {
    return 'Nie udało się połączyć: $error';
  }

  @override
  String failedConnectionSaveMessage(Object error) {
    return 'Nie udało się zapisać połączenia: $error';
  }

  @override
  String get loadingIndicator => 'Ładowanie...';

  @override
  String get profileScreenTitle => 'Profil';

  @override
  String get vaultsScreenTitle => 'Moje Vaulty';

  @override
  String get albumScreenTitle => 'Album';

  @override
  String get albumsScreenTitle => 'Albumy';

  @override
  String get appTitle => 'Vault';

  @override
  String get navBarTitle => 'Menu';

  @override
  String get albumsNavBarEntry => 'Albumy';

  @override
  String get serverListNavBarEntry => 'Lista Serwerów';
}
