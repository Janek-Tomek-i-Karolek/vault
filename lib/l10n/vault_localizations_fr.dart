// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'vault_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get welcome => 'Bienvenue';

  @override
  String get register => 'S\'inscrire';

  @override
  String get connectAction => 'Connecter';

  @override
  String get saveAction => 'Sauvegarder';

  @override
  String get loginAction => 'Se connecter';

  @override
  String get createNewAccountAction => 'Créer un compte';

  @override
  String get logoutAction => 'Déconnexion';

  @override
  String get addServerAction => 'Ajouter un serveur';

  @override
  String get addPhotosAction => 'Ajouter des photos';

  @override
  String get addAlbumAction => 'Ajouter un album';

  @override
  String get usernameLabel => 'Nom d\'utilisateur';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get albumNameLabel => 'Nom de l\'album';

  @override
  String get serverUrlLabel => 'L\'URL du serveur';

  @override
  String get apiKeyLabel => 'Clé API';

  @override
  String get alreadyRegisteredQuestion => 'Vous avez déjà un compte ?';

  @override
  String get forgotPasswordQuestion => 'Mot de passe oublié ?';

  @override
  String get vaultServerLabel => 'Serveur Vault';

  @override
  String invalidValuesErrorMessage(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Valeurs incorrectes',
      one: 'Valeur incorrecte',
    );
    return '$_temp0';
  }

  @override
  String get unknownErrorMessage => 'Une erreur inconnue est survenue';

  @override
  String genericErrorMessage(Object error) {
    return 'Une erreur est survenue : $error';
  }

  @override
  String failedConnectionTestMessage(Object error) {
    return 'Échec du test de connexion : $error';
  }

  @override
  String failedConnectionSaveMessage(Object error) {
    return 'Échec de l\'enregistrement de la connexion : $error';
  }

  @override
  String failedAddAlbumMessage(Object error) {
    return 'Échec de l\'ajout de l\'album : $error';
  }

  @override
  String get loadingIndicator => 'Chargement...';

  @override
  String get profileScreenTitle => 'Profil';

  @override
  String get vaultsScreenTitle => 'Mes Vaults';

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
  String get serverListNavBarEntry => 'Liste des serveurs';

  @override
  String get weekday_1 => 'lundi';

  @override
  String get weekday_2 => 'mardi';

  @override
  String get weekday_3 => 'mercredi';

  @override
  String get weekday_4 => 'jeudi';

  @override
  String get weekday_5 => 'vendredi';

  @override
  String get weekday_6 => 'samedi';

  @override
  String get weekday_7 => 'dimanche';

  @override
  String get cameraLabel => 'Caméra';

  @override
  String get lensLabel => 'Objectif';

  @override
  String get serverLabel => 'Serveur';

  @override
  String get resolutionLabel => 'Résolution';

  @override
  String get sizeLabel => 'Taille';
}
