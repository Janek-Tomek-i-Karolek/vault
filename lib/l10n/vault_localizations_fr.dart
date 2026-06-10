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
  String get usernameLabel => 'Nom d\'utilisateur';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get alreadyRegisteredQuestion => 'Vous avez déjà un compte?';

  @override
  String get forgotPasswordQuestion => 'Mot de passe oublié?';

  @override
  String get vaultServerLabel => 'Un Serveur Vault';

  @override
  String get serverUrlLabel => 'L\'URL du serveur';

  @override
  String get apiKeyLabel => 'Clé API';

  @override
  String get unknownErrorMessage => 'Une erruer inconnue est survenue';

  @override
  String genericErrorMessage(Object error) {
    return 'Une erreur est survenue: $error';
  }

  @override
  String failedConnectionTestMessage(Object error) {
    return 'Échec du test de connexion: $error';
  }

  @override
  String failedConnectionSaveMessage(Object error) {
    return 'Échec de l\'enregistrement de la connexion: $error';
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
}
