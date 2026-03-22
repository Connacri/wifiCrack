// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'WiFi Fibre Hack';

  @override
  String get home => 'Accueil';

  @override
  String get map => 'Carte';

  @override
  String get scan => 'Scanner';

  @override
  String get settings => 'Paramètres';

  @override
  String get admin => 'Admin';

  @override
  String get commerce => 'Commerce';

  @override
  String get p2pChat => 'Chat P2P';

  @override
  String get publishAd => 'Publier une annonce';

  @override
  String get connect => 'Connexion';

  @override
  String get disconnect => 'Déconnexion';

  @override
  String get copy => 'Copier';

  @override
  String get share => 'Partager';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirm => 'Confirmer';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get save => 'Enregistrer';

  @override
  String get search => 'Rechercher';

  @override
  String get loading => 'Chargement...';

  @override
  String get error => 'Erreur';

  @override
  String get success => 'Succès';

  @override
  String get password => 'Mot de passe';

  @override
  String get pseudo => 'Pseudo';

  @override
  String get login => 'S\'identifier';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get language => 'Langue';

  @override
  String get theme => 'Thème';

  @override
  String get light => 'Clair';

  @override
  String get dark => 'Sombre';

  @override
  String get system => 'Système';

  @override
  String get about => 'À propos';

  @override
  String get version => 'Version';

  @override
  String get profileTooltip => 'Profil';

  @override
  String get adminTooltip => 'Admin';

  @override
  String get chatTooltip => 'Chat';

  @override
  String get p2pTooltip => 'P2P';

  @override
  String get scanWifi => 'Scanner WiFi';

  @override
  String get scanning => 'Analyse en cours...';

  @override
  String get noNetworks => 'Aucun réseau trouvé';

  @override
  String get permissionDenied => 'Permission refusée';

  @override
  String get fixPermissions => 'Corriger les permissions';

  @override
  String get detected => 'Détecté';

  @override
  String get connected => 'Connecté';

  @override
  String get failed => 'Échec';

  @override
  String get coins => 'Pièces';

  @override
  String get publishAdEarn => 'Publier une annonce et gagner';

  @override
  String get adminDashboardTitle => 'Sigma Dashboard Pro';

  @override
  String get logoutSnackBar => 'Déconnecté de l\'admin.';

  @override
  String get logoutTooltip => 'Déconnexion locale';

  @override
  String get tabStats => 'Stats';

  @override
  String get tabAds => 'Ads';

  @override
  String get tabTargets => 'Cibles';

  @override
  String get tabMap => 'Carte';

  @override
  String get tabTraces => 'Traces';

  @override
  String get tabContacts => 'Contacts';

  @override
  String get tabConfig => 'Config';

  @override
  String get securityAdmin => '🔐 Sécurité Admin';

  @override
  String get changePasswordInfo =>
      'Changez le mot de passe d\'accès au dashboard. Ce changement est immédiat pour tous les appareils.';

  @override
  String get minPasswordError =>
      'Le mot de passe doit faire au moins 6 caractères.';

  @override
  String get passwordUpdateSuccess =>
      '✅ Mot de passe Admin mis à jour sur Supabase !';

  @override
  String get passwordUpdateError => '❌ Erreur lors de la mise à jour.';

  @override
  String get addCarousel => '📢 Ajouter au Carrousel';

  @override
  String get saveChanges => 'Enregistrer les modifications';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get publish => 'Publier';

  @override
  String get bannerAdded => 'Bannière ajoutée !';

  @override
  String get userSubmissionsManagement =>
      'Gestion des soumissions utilisateurs';

  @override
  String get unknown => 'Inconnu';

  @override
  String get model => 'Modèle';

  @override
  String get coinsLabel => 'Coins';

  @override
  String get chat => 'Chat';

  @override
  String get giveCoins => 'Donner Coins';

  @override
  String get coinsAmountLabel => 'Nombre de coins';

  @override
  String get add => 'Ajouter';

  @override
  String get online => 'En ligne';

  @override
  String get offline => 'Hors ligne';

  @override
  String get searchPlaceholder => 'Rechercher...';

  @override
  String get bannerText => 'Texte de la bannière';

  @override
  String get imageUrl => 'URL de l\'image';

  @override
  String get externalLink => 'Lien externe';

  @override
  String get editPseudo => 'Modifier mon Pseudo';

  @override
  String get newPseudo => 'Nouveau Pseudo';

  @override
  String get pseudoUpdated => 'Pseudo mis à jour !';

  @override
  String get pseudoError => 'Pseudo indisponible ou erreur.';

  @override
  String get messengerDashboard => 'Sigma Messenger Dashboard';

  @override
  String get noUsersFound => 'Aucun utilisateur trouvé.';

  @override
  String get noActivityAvailable => 'Aucune activité disponible.';

  @override
  String get deleteConversation => 'Effacer la conversation';

  @override
  String confirmDeleteConversation(Object pseudo) {
    return 'Supprimer tous les messages avec $pseudo ?';
  }

  @override
  String get conversationDeleted => 'Conversation supprimée localement.';

  @override
  String get p2pSecure => 'P2P Sécurisé';

  @override
  String coinsForUser(Object pseudo) {
    return 'Coins pour $pseudo';
  }

  @override
  String coinsAddedToUser(Object amount, Object pseudo) {
    return '$amount coins ajoutés à $pseudo';
  }

  @override
  String get amountLabel => 'Montant';

  @override
  String get addCoins => 'Ajouter des Coins';

  @override
  String get refreshUsers => 'Rafraîchir les utilisateurs';

  @override
  String get changePseudoTooltip => 'Changer mon pseudo';

  @override
  String get userProfile => 'Profil';

  @override
  String p2pSecureSubtitle(Object id) {
    return 'P2P Sécurisé • $id...';
  }

  @override
  String get deleteConversationTooltip => 'Effacer conversation';

  @override
  String get addCoinsTooltip => 'Donner des coins';

  @override
  String get coinsToAddLabel => 'Nombre de coins à ajouter';

  @override
  String get messageSigmaPlaceholder => 'Message Sigma...';

  @override
  String get supportChatPlaceholder => 'Message au support...';

  @override
  String get userProfileTitle => 'Profil utilisateur';

  @override
  String get tabInfo => 'Infos';

  @override
  String get tabActivity => 'Activité';

  @override
  String get tabSecurity => 'Sécurité';

  @override
  String get tabNetwork => 'Réseau';

  @override
  String get identity => 'Identité';

  @override
  String get deviceAndSession => 'Appareil & Session';

  @override
  String get lastActivity => 'Dernière activité';

  @override
  String get createdAt => 'Créé le';

  @override
  String get activitySummary => 'Résumé activité';

  @override
  String get eventsCollected => 'Événements collectés';

  @override
  String get validGpsPoints => 'Points GPS valides';

  @override
  String get maxContactsSeen => 'Contacts max vus';

  @override
  String get securityStatus => 'État sécurité';

  @override
  String get activeSession => 'Session active';

  @override
  String get lastPing => 'Dernier ping';

  @override
  String agoMin(Object minutes) {
    return 'il y a $minutes min';
  }

  @override
  String get anomalyDetected => 'Anomalie détectée';

  @override
  String get none => 'Aucune (heuristique locale)';

  @override
  String get securityNote =>
      'Note: cet onglet affiche des signaux de sécurité applicatifs basés sur les données disponibles (pas un audit serveur complet).';

  @override
  String get networkStatus => 'État réseau';

  @override
  String get mainChannel => 'Canal principal';

  @override
  String get presence => 'Présence';

  @override
  String get available => 'Disponible';

  @override
  String get unavailable => 'Indisponible';

  @override
  String get geolocSamples => 'Échantillons de géoloc';

  @override
  String get rawDebugData => 'Données brutes (debug)';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get sigmaAdProposalTitle => '🚀 Propose ton annonce Sigma';

  @override
  String get submitAdSuccess =>
      '✅ Soumission envoyée ! Attend la validation de l\'admin pour tes coins.';

  @override
  String get submitAdInfo =>
      'Envoie une image, une description et gagne des coins !';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get submit => 'Soumettre';

  @override
  String get bonusActivated => 'Bonus de Coins activé ! (Vidéo vue)';

  @override
  String get watchVideoBonus => 'Regarder une vidéo pour +50 Coins bonus';

  @override
  String get languageSelectorTitle => 'Select Language / Choisir la langue';

  @override
  String get imageLinkUrl => 'Lien de l\'image (URL)';

  @override
  String get bonusAddedText => 'Bonus de Coins activé ! (Vidéo vue)';

  @override
  String get close => 'Fermer';

  @override
  String copiedToClipboard(Object text) {
    return 'Clé copiée : $text';
  }

  @override
  String get disconnectTooltip => 'Déconnecter';

  @override
  String get connectTooltip => 'Calculer & Connecter';

  @override
  String get audioUnavailable => 'Vocal non disponible.';

  @override
  String get supportSigmaPro => 'Support Sigma Pro';

  @override
  String get p2pEncryptedChat => 'Messagerie P2P Chiffrée';

  @override
  String get needHelpMessage => 'Besoin d\'aide ? Envoyez-nous un message.';

  @override
  String get chooseAdminRole => 'Choisissez votre rôle Admin';

  @override
  String get configRequiredTitle => 'Configuration Requise';

  @override
  String get configRequiredInfo => 'Pour fonctionner, Sigma a besoin de : \n';

  @override
  String get configVisibleNote =>
      'Sans cela, vous ne serez pas visible sur la carte Sigma.';

  @override
  String get configureNow => 'Configurer Maintenant';

  @override
  String get accessDenied => 'Accès refusé.';

  @override
  String sigmaKey(Object key) {
    return 'Clé Sigma: $key';
  }

  @override
  String get wifiDisabled => 'Le WiFi est désactivé.';

  @override
  String get locationWifiPermsRequired =>
      'Permissions de localisation/WiFi requises.';

  @override
  String get gpsRequiredAndroid =>
      'Le GPS est requis pour scanner sur Android.';

  @override
  String get noCompatibleNetworks =>
      'Aucun réseau compatible détecté à proximité.';

  @override
  String scanError(Object error) {
    return 'Erreur lors du scan: $error';
  }

  @override
  String get scanNotSupported =>
      'Le scan WiFi n\'est pas supporté sur cet appareil.';

  @override
  String get gpsDisabled => 'Le GPS est désactivé.';

  @override
  String scanUnavailable(Object status) {
    return 'Le scan est indisponible ($status).';
  }

  @override
  String get manualKeyEntryNote =>
      'Veuillez entrer la clé manuellement si la connexion échoue.';

  @override
  String get authRequired => 'Authentification requise';

  @override
  String get chooseRole => 'Choisissez votre rôle';

  @override
  String get user => 'Utilisateur';

  @override
  String get validate => 'Valider';

  @override
  String get authTitle => 'Authentification';

  @override
  String get commerceLogin => 'Connexion Commerce';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get email => 'Email';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get loginGoogle => 'Continuer avec Google';

  @override
  String get noAccount => 'Pas de compte ? S\'inscrire';

  @override
  String get hasAccount => 'Déjà un compte ? Se connecter';

  @override
  String get resetEmailSent => 'Email de réinitialisation envoyé !';

  @override
  String get fillAllFields => 'Veuillez remplir tous les champs.';

  @override
  String googleError(Object error) {
    return 'Erreur Google: $error';
  }

  @override
  String get permsRequiredTitle => 'Autorisations Requises';

  @override
  String get permsRequiredInfo =>
      'Pour utiliser cette application, vous devez impérativement :\n\n';

  @override
  String get permsFatalNote =>
      'Sans cela, l\'application ne peut pas fonctionner.';

  @override
  String get understandAndConfigure => 'J\'ai compris, configurer';

  @override
  String get commerceDisconnectConfirm =>
      'Voulez-vous vous déconnecter du commerce ?';

  @override
  String get startDiscussion => 'Commencez la discussion';

  @override
  String get yourMessage => 'Votre message...';

  @override
  String get orderErrorUnidentified =>
      'Impossible de passer commande : utilisateur non identifié.';

  @override
  String get client => 'Client';

  @override
  String get vendor => 'Vendeur';

  @override
  String get deliveryPerson => 'Livreur';

  @override
  String get wholesaler => 'Grossiste';
}
