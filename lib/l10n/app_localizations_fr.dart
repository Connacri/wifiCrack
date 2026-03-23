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
  String get admin => 'Administrateur';

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
  String get adminTooltip => 'Administrateur';

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
  String get tabStats => 'Statistiques';

  @override
  String get tabAds => 'Annonces';

  @override
  String get tabTargets => 'Cibles';

  @override
  String get tabMap => 'Carte';

  @override
  String get tabTraces => 'Traces';

  @override
  String get tabContacts => 'Contacts';

  @override
  String get tabConfig => 'Configuration';

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
  String get messengerDashboard => 'Tableau de bord Sigma Messenger';

  @override
  String get noUsersFound => 'Aucun utilisateur trouvé.';

  @override
  String get noActivityAvailable => 'Aucune activité disponible.';

  @override
  String get deleteConversation => 'Effacer la conversation';

  @override
  String confirmDeleteConversation(String pseudo) {
    return 'Supprimer tous les messages avec $pseudo ?';
  }

  @override
  String get conversationDeleted => 'Conversation supprimée localement.';

  @override
  String get p2pSecure => 'P2P Sécurisé';

  @override
  String coinsForUser(String pseudo) {
    return 'Coins pour $pseudo';
  }

  @override
  String coinsAddedToUser(int amount, String pseudo) {
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
  String p2pSecureSubtitle(String id) {
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
  String agoMin(int minutes) {
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
  String get languageSelectorTitle => 'Choisir la langue';

  @override
  String get imageLinkUrl => 'Lien de l\'image (URL)';

  @override
  String get bonusAddedText => 'Bonus de Coins activé ! (Vidéo vue)';

  @override
  String get close => 'Fermer';

  @override
  String copiedToClipboard(String text) {
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
  String sigmaKey(String key) {
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
  String scanError(String error) {
    return 'Erreur lors du scan: $error';
  }

  @override
  String get scanNotSupported =>
      'Le scan WiFi n\'est pas supporté sur cet appareil.';

  @override
  String get gpsDisabled => 'Le GPS est désactivé.';

  @override
  String scanUnavailable(String status) {
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
  String get email => 'E-mail';

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
  String googleError(String error) {
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

  @override
  String get vocalSigma => 'Vocal Sigma';

  @override
  String get defaultMessageContent => 'Message';

  @override
  String get myContacts => 'Mes Contacts';

  @override
  String get myQrCodeTooltip => 'Mon QR Code';

  @override
  String get scanFriendTooltip => 'Scanner un ami';

  @override
  String get friendAddedSuccess => '✅ Ami ajouté avec succès !';

  @override
  String get editPseudoMenu => 'Modifier mon pseudo';

  @override
  String get myPseudoTitle => 'Mon pseudo';

  @override
  String get enterPseudoHint => 'Entrez votre pseudo';

  @override
  String get noContacts => 'Aucun contact';

  @override
  String get scanFriendToStart => 'Scannez le QR Code d\'un ami pour commencer';

  @override
  String get scanFriendButton => 'Scanner un ami';

  @override
  String get addedOn => 'Ajouté le';

  @override
  String get scanQrCodeTitle => 'Scanner un QR Code';

  @override
  String get qrCodeUnreadable => 'QR Code illisible, réessayez.';

  @override
  String get invalidMistralQr => 'Ce QR Code ne provient pas de Mistral P2P.';

  @override
  String invalidLinkError(String error) {
    return 'Lien invalide : $error';
  }

  @override
  String get cannotAddSelf => '🚫 Vous ne pouvez pas vous ajouter vous-même !';

  @override
  String get friendAlreadyAdded => 'ℹ️ Cet ami est déjà dans vos contacts.';

  @override
  String get placeQrInFrame => 'Placez le QR Code dans le cadre';

  @override
  String get retry => 'Réessayer';

  @override
  String get flashlightTooltip => 'Lampe torche';

  @override
  String get shareLinkTooltip => 'Partager le lien';

  @override
  String inviteText(String link) {
    return 'Ajoute-moi sur Mistral2laude P2P !\n$link';
  }

  @override
  String get inviteSubject => 'Invitation Mistral2laude P2P';

  @override
  String get scanMeText =>
      'Faites scanner ce QR Code\npour vous ajouter en contact';

  @override
  String get microphonePermissionDenied => 'Permission microphone refusée';

  @override
  String get connectionNotEstablished =>
      '⚠️ Connexion non établie. Message sauvegardé localement.';

  @override
  String get noMessagesYet => 'Aucun message.\nEnvoyez le premier ! 👋';

  @override
  String get statusConnected => 'Connecté';

  @override
  String get statusConnecting => 'Connexion...';

  @override
  String get statusFailed => 'Échec';

  @override
  String get statusOffline => 'Hors ligne';

  @override
  String get recordingHint => '🔴 Enregistrement...';

  @override
  String get messageHint => 'Message...';

  @override
  String get connectingHint => 'Connexion en cours...';

  @override
  String get initFailed => 'Échec d\'initialisation';

  @override
  String get defaultUserPseudo => 'Utilisateur M2C';

  @override
  String get mobileDevice => 'Appareil Mobile';

  @override
  String get unknownDevice => 'Inconnu';

  @override
  String get productsTab => 'Produits';

  @override
  String get ordersTab => 'Commandes';

  @override
  String get cartTab => 'Panier';

  @override
  String get clientModeTooltip => 'Mode Client';

  @override
  String get adminModeTooltip => 'Mode Admin';

  @override
  String get addProductTooltip => 'Ajouter produit';

  @override
  String get orderCreated => 'Commande créée.';

  @override
  String get orderFailed => 'Échec de la commande.';

  @override
  String get productCreated => 'Produit créé.';

  @override
  String get productUpdated => 'Produit mis à jour.';

  @override
  String get productDeleted => 'Produit supprimé.';

  @override
  String get deleteFailed => 'Échec de la suppression.';

  @override
  String get deleteProductTitle => 'Supprimer le produit';

  @override
  String deleteProductConfirm(String name) {
    return 'Supprimer \"$name\" ?';
  }

  @override
  String get imageUploaded => 'Image téléchargée.';

  @override
  String imageUploadFailed(String error) {
    return 'Échec du téléchargement : $error';
  }

  @override
  String get supabaseBucketNotConfigured =>
      'Le bucket d\'images Supabase n\'est pas configuré.';

  @override
  String get searchProductsPlaceholder => 'Rechercher produits ou SKU';

  @override
  String get inStockFilter => 'En stock';

  @override
  String get includeInactiveFilter => 'Inclure inactifs';

  @override
  String get sortName => 'Nom';

  @override
  String get sortPriceAsc => 'Prix croiss.';

  @override
  String get sortPriceDesc => 'Prix décroiss.';

  @override
  String get sortStockAsc => 'Stock croiss.';

  @override
  String get sortStockDesc => 'Stock décroiss.';

  @override
  String get sortPopularity => 'Popularité';

  @override
  String get gridView => 'Grille';

  @override
  String get listView => 'Liste';

  @override
  String get noProductsMatch => 'Aucun produit ne correspond.';

  @override
  String get clearFilters => 'Effacer filtres';

  @override
  String get allProductsLoaded => 'Tous les produits chargés.';

  @override
  String get saveProductTitle => 'Enregistrer Produit';

  @override
  String get addProductTitle => 'Ajouter Produit';

  @override
  String get editProductTitle => 'Modifier Produit';

  @override
  String get productNameLabel => 'Nom';

  @override
  String get skuLabel => 'SKU / Référence';

  @override
  String get priceLabel => 'Prix (DZD)';

  @override
  String get promoPriceLabel => 'Prix promo (DZD)';

  @override
  String get optionalHelper => 'Optionnel';

  @override
  String get imageLabel => 'URL Image ou Chemin Storage';

  @override
  String get uploadImageButton => 'Télécharger image';

  @override
  String get replaceImageButton => 'Remplacer image';

  @override
  String get uploadingButton => 'Envoi...';

  @override
  String get stockLabel => 'Stock';

  @override
  String get popularityLabel => 'Popularité';

  @override
  String get activeLabel => 'Actif';

  @override
  String get saveButton => 'Enregistrer';

  @override
  String get savingButton => 'Enregistrement...';

  @override
  String get unavailableStatus => 'Indisponible';

  @override
  String get outOfStockStatus => 'Rupture de stock';

  @override
  String get lowStockStatus => 'Stock faible';

  @override
  String get inactiveStatus => 'Inactif';

  @override
  String get promoStatus => 'Promo';

  @override
  String get cartEmpty => 'Le panier est vide.';

  @override
  String get yourCart => 'Votre panier';

  @override
  String get clearCart => 'Vider';

  @override
  String get subtotalLabel => 'Sous-total';

  @override
  String get deliveryLabel => 'Livraison';

  @override
  String get totalLabel => 'Total';

  @override
  String get phoneLabel => 'Téléphone';

  @override
  String get addressLabel => 'Adresse';

  @override
  String get noteLabel => 'Note';

  @override
  String get checkoutButton => 'Commander';

  @override
  String orderTotal(String amount) {
    return 'Total $amount DZD';
  }

  @override
  String itemsCount(int count) {
    return '$count articles';
  }

  @override
  String orderNumber(String id) {
    return 'Commande #$id';
  }

  @override
  String get changeRoleTooltip => 'Changer de rôle (Simulation)';

  @override
  String get orderNotFound => 'Commande non trouvée';

  @override
  String get globalStatus => 'Statut global';

  @override
  String get dateLabel => 'Date';

  @override
  String get customerLabel => 'Client';

  @override
  String get paymentLabel => 'Paiement';

  @override
  String get productsLabel => 'Produits';

  @override
  String priceXQuantity(String price, int quantity) {
    return 'Prix : $price DZD x $quantity';
  }

  @override
  String amountWithCurrency(String amount) {
    return '$amount DZD';
  }

  @override
  String shipmentItemLine(String name, int quantity) {
    return '• $name (x$quantity)';
  }

  @override
  String get noShipmentsYet => 'Aucune expédition pour le moment.';

  @override
  String shipmentsCount(int count) {
    return 'Expéditions ($count)';
  }

  @override
  String packageNumber(String tracking) {
    return 'Colis : $tracking';
  }

  @override
  String carrierLabel(String name) {
    return 'Transporteur : $name';
  }

  @override
  String get packageId => 'ID';

  @override
  String get shippedOn => 'Expédié le';

  @override
  String get itemsInPackage => 'Articles dans ce colis :';

  @override
  String get confirmOrderButton => 'Confirmer la commande';

  @override
  String get allocateStockButton => 'Allouer le stock';

  @override
  String get startPickingButton => 'Démarrer le Picking';

  @override
  String get packingFinishedButton => 'Emballage terminé (Packed)';

  @override
  String get shipButton => 'Générer étiquette & Expédier';

  @override
  String setInTransitButton(String tracking) {
    return 'Mettre en Transit ($tracking)';
  }

  @override
  String confirmDeliveryButton(String tracking) {
    return 'Confirmer Livraison ($tracking)';
  }

  @override
  String get requestReturnButton => 'Demander un retour';

  @override
  String get newShipmentTitle => 'Nouvelle Expédition';

  @override
  String get allItemIncludedNote =>
      'Tous les articles seront inclus dans ce colis pour cet exemple.';

  @override
  String get trackingNumberLabel => 'N° de suivi';

  @override
  String get adminStatusTitle => 'Administration : Statut';

  @override
  String get phoneAddressRequired => 'Le téléphone et l\'adresse sont requis.';

  @override
  String get orderFailedLong => 'Échec de la commande.';

  @override
  String orderCreatedLong(String id) {
    return 'Commande créée : $id';
  }

  @override
  String get placingOrderButton => 'Commande en cours...';

  @override
  String get placeOrderButton => 'Commander';

  @override
  String get loadMoreButton => 'Charger plus';

  @override
  String get searchOrderPlaceholder => 'Rechercher une commande...';

  @override
  String get allFilter => 'Tout';

  @override
  String get orderConfirmedStep => 'Confirmé';

  @override
  String get shippedStep => 'Expédié';

  @override
  String get deliveredStep => 'Livré';

  @override
  String get unknownDate => 'Inconnue';

  @override
  String get p2pMessengerTitle => 'Messagerie P2P';

  @override
  String errorWithDetails(String message) {
    return 'Erreur : $message';
  }

  @override
  String get myQrCode => 'Mon QR Code';

  @override
  String get shareQrCodeTitle => 'Partager votre QR Code';

  @override
  String get shareQrCodeSubtitle =>
      'Laissez vos amis scanner ce code pour vous ajouter à leurs contacts.';

  @override
  String get takeScreenshotToShare =>
      'Prenez une capture d\'écran pour partager votre QR Code.';

  @override
  String get initErrorTitle => 'Erreur d\'initialisation';

  @override
  String get messagesTitle => 'Messages';

  @override
  String get addContactTooltip => 'Ajouter un contact';

  @override
  String get noConversations => 'Aucune conversation';

  @override
  String get addContactToStart =>
      'Ajoutez un contact pour commencer à discuter';

  @override
  String get typingStatus => 'écrit...';

  @override
  String get sayHello => 'Dites bonjour ! 👋';

  @override
  String get yesterday => 'Hier';

  @override
  String get addFriendTitle => 'Ajouter un ami';

  @override
  String get scanFriendQr => 'Scannez le QR Code de votre ami';

  @override
  String get addContactTitle => 'Ajouter un contact';

  @override
  String get yourQrCodeTitle => 'Votre QR Code';

  @override
  String get yourQrCodeSubtitle => 'Montrez ce code à votre ami';

  @override
  String get notAvailable => 'N/D';

  @override
  String get deviceIdLabel => 'ID de l\'appareil';

  @override
  String get contactAddedSuccess => 'Contact ajouté avec succès !';

  @override
  String get dataChannelDisconnected => 'Canal de données déconnecté';

  @override
  String peerNotConnected(String id) {
    return 'Pair non connecté : $id';
  }

  @override
  String errorParsingMessage(String error) {
    return 'Erreur lors de l\'analyse du message : $error';
  }

  @override
  String invalidQrCode(String error) {
    return 'QR Code invalide : $error';
  }

  @override
  String get missingDeviceId => 'ID de l\'appareil manquant';

  @override
  String get missingPseudo => 'Pseudo manquant';

  @override
  String get missingPublicKey => 'Clé publique manquante';

  @override
  String get cannotAddSelfError => 'Impossible de s\'ajouter soi-même';

  @override
  String get invalidPublicKeyFormat => 'Format de clé publique invalide';

  @override
  String errorParsingQrCode(String error) {
    return 'Erreur lors de l\'analyse du QR Code : $error';
  }

  @override
  String get mistral2laudeTitle => 'Mistral2laude P2P';

  @override
  String get friendLabel => 'Ami';

  @override
  String get encryptedMessage => '[Message chiffré]';

  @override
  String get youEncryptedMessage => 'Vous : [Message chiffré]';

  @override
  String get imageMessage => '🖼️ Image';

  @override
  String get fileMessage => '📎 Fichier';

  @override
  String get newMessage => 'Nouveau message';

  @override
  String get reply => 'Répondre';

  @override
  String get quickReply => 'Réponse rapide';

  @override
  String get markAsRead => 'Marquer comme lu';

  @override
  String get isTyping => 'est en train d\'écrire...';

  @override
  String get typingIndicator => 'Écrit...';

  @override
  String get vocalMessage => 'Message vocal';

  @override
  String get gps => 'GPS';

  @override
  String get permissions => 'Autorisations';

  @override
  String get trace => 'Trace';

  @override
  String get mainChannelValue => 'WebRTC P2P';

  @override
  String get formErrors => 'Veuillez corriger les erreurs du formulaire.';

  @override
  String get saveFailed => 'Échec de l\'enregistrement.';

  @override
  String get itemsLabel => 'Articles';

  @override
  String get productInfoSection => 'Infos';

  @override
  String get productImageSection => 'Image';

  @override
  String get productStockStatusSection => 'Stock & statut';

  @override
  String get categoryLabel => 'Catégorie';

  @override
  String get nameRequired => 'Le nom est requis';

  @override
  String get priceRequired => 'Le prix est requis';

  @override
  String get invalidPrice => 'Entrez un prix valide';

  @override
  String get invalidPromoPrice => 'Entrez un prix promo valide';

  @override
  String get promoLowerThanPrice => 'La promo doit être inférieure au prix';

  @override
  String get invalidStock => 'Entrez un stock valide';

  @override
  String get popularityHelper => 'Plus élevé = plus populaire';

  @override
  String get invalidPopularity => 'Entrez une popularité valide';

  @override
  String get addToCart => 'Ajouter au panier';

  @override
  String get stockUnknown => 'Stock inconnu';

  @override
  String get startChatPrompt => 'Commencez la discussion';

  @override
  String get realtimeMessengerTitle => 'Sigma Messenger (Temps réel)';

  @override
  String get clear => 'Effacer';

  @override
  String get warehouseRole => 'Entrepôt';

  @override
  String get carrierRole => 'Transporteur';

  @override
  String get supportRole => 'Support';

  @override
  String get orderStatusCreated => 'Créée';

  @override
  String get orderStatusPendingPayment => 'Paiement en attente';

  @override
  String get orderStatusPaid => 'Payée';

  @override
  String get orderStatusPaymentFailed => 'Échec du paiement';

  @override
  String get orderStatusCancelRequested => 'Annulation demandée';

  @override
  String get orderStatusCancelled => 'Annulée';

  @override
  String get orderStatusOrderConfirmed => 'Confirmée';

  @override
  String get orderStatusStockAllocated => 'Stock alloué';

  @override
  String get orderStatusBackorder => 'Reliquat';

  @override
  String get orderStatusPicking => 'En préparation';

  @override
  String get orderStatusPacked => 'Emballée';

  @override
  String get orderStatusReadyToShip => 'Prête à expédier';

  @override
  String get orderStatusPartiallyShipped => 'Partiellement expédiée';

  @override
  String get orderStatusShipped => 'Expédiée';

  @override
  String get orderStatusPartiallyDelivered => 'Partiellement livrée';

  @override
  String get orderStatusDelivered => 'Livrée';

  @override
  String get orderStatusDeliveryFailed => 'Échec de livraison';

  @override
  String get orderStatusException => 'Exception';

  @override
  String get orderStatusReturnRequested => 'Retour demandé';

  @override
  String get orderStatusReturnInTransit => 'Retour en transit';

  @override
  String get orderStatusReturnReceived => 'Retour reçu';

  @override
  String get orderStatusRefundPending => 'Remboursement en attente';

  @override
  String get orderStatusRefunded => 'Remboursée';

  @override
  String get orderStatusClosed => 'Clôturée';

  @override
  String get shipmentStatusLabelCreated => 'Étiquette créée';

  @override
  String get shipmentStatusPickedUp => 'Récupérée';

  @override
  String get shipmentStatusInTransit => 'En transit';

  @override
  String get shipmentStatusArrivedAtHub => 'Arrivée au hub';

  @override
  String get shipmentStatusCustomsClearance => 'Dédouanement';

  @override
  String get shipmentStatusOutForDelivery => 'En cours de livraison';

  @override
  String get shipmentStatusDelivered => 'Livrée';

  @override
  String get shipmentStatusDeliveryFailed => 'Échec de livraison';

  @override
  String get shipmentStatusException => 'Exception';

  @override
  String get shipmentStatusLost => 'Perdue';

  @override
  String get shipmentStatusDamaged => 'Endommagée';

  @override
  String get shipmentStatusReturnToSender => 'Retour à l\'expéditeur';

  @override
  String get returnStatusRequested => 'Demandé';

  @override
  String get returnStatusAuthorized => 'Autorisé';

  @override
  String get returnStatusLabelIssued => 'Étiquette émise';

  @override
  String get returnStatusInTransit => 'En transit';

  @override
  String get returnStatusReceived => 'Reçu';

  @override
  String get returnStatusRejected => 'Refusé';

  @override
  String get returnStatusRefundPending => 'Remboursement en attente';

  @override
  String get returnStatusRefunded => 'Remboursé';

  @override
  String get paymentStatusPending => 'En attente';

  @override
  String get paymentStatusAuthorized => 'Autorisé';

  @override
  String get paymentStatusCaptured => 'Capturé';

  @override
  String get paymentStatusVoided => 'Annulé';

  @override
  String get paymentStatusRefunded => 'Remboursé';

  @override
  String get paymentStatusFailed => 'Échoué';
}
