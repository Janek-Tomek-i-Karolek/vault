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
  String get downloadPhoto => 'Download Photo';

  @override
  String get deletePhoto => 'Delete Photo';

  @override
  String get sharePhoto => 'Share Photo';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get connectAction => 'Connect';

  @override
  String get saveAction => 'Save';

  @override
  String get loginAction => 'Login';

  @override
  String get createNewAccountAction => 'Create new account';

  @override
  String get logoutAction => 'Sign out';

  @override
  String get addServerAction => 'Add Server';

  @override
  String get addPhotosAction => 'Add Photos';

  @override
  String get addAlbumAction => 'Add album';

  @override
  String get usernameLabel => 'Username';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get albumNameLabel => 'Album name';

  @override
  String get serverUrlLabel => 'Server URL';

  @override
  String get apiKeyLabel => 'Api Key';

  @override
  String get alreadyRegisteredQuestion => 'Already have an account?';

  @override
  String get forgotPasswordQuestion => 'Forgot password?';

  @override
  String get vaultServerLabel => 'Vault Server';

  @override
  String invalidValuesErrorMessage(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Invalid values',
      one: 'Invalid value',
    );
    return '$_temp0';
  }

  @override
  String get unknownErrorMessage => 'An unknown error occured';

  @override
  String genericErrorMessage(Object error) {
    return 'An error occured: $error';
  }

  @override
  String failedConnectionTestMessage(Object error) {
    return 'Connection test failed: $error';
  }

  @override
  String failedConnectionSaveMessage(Object error) {
    return 'Failed to save connection: $error';
  }

  @override
  String failedAddAlbumMessage(Object error) {
    return 'Failed to add album: $error';
  }

  @override
  String get loadingIndicator => 'Loading...';

  @override
  String get profileScreenTitle => 'Profile';

  @override
  String get vaultsScreenTitle => 'My Vaults';

  @override
  String get albumScreenTitle => 'Album';

  @override
  String get albumsScreenTitle => 'Albums';

  @override
  String get appTitle => 'Vault';

  @override
  String get navBarTitle => 'Menu';

  @override
  String get albumsNavBarEntry => 'Albums';

  @override
  String get serverListNavBarEntry => 'Server List';

  @override
  String get weekday_1 => 'Monday';

  @override
  String get weekday_2 => 'Tuesday';

  @override
  String get weekday_3 => 'Wednesday';

  @override
  String get weekday_4 => 'Thursday';

  @override
  String get weekday_5 => 'Friday';

  @override
  String get weekday_6 => 'Saturday';

  @override
  String get weekday_7 => 'Sunday';

  @override
  String get cameraLabel => 'Camera';

  @override
  String get lensLabel => 'Lens';

  @override
  String get serverLabel => 'Server';

  @override
  String get resolutionLabel => 'Resolution';

  @override
  String get sizeLabel => 'Size';
}
