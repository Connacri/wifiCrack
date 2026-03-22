// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'WiFi Fibre Hack';

  @override
  String get home => 'Startseite';

  @override
  String get map => 'Karte';

  @override
  String get scan => 'Scannen';

  @override
  String get settings => 'Einstellungen';

  @override
  String get admin => 'Admin';

  @override
  String get commerce => 'Handel';

  @override
  String get p2pChat => 'P2P-Chat';

  @override
  String get publishAd => 'Anzeige aufgeben';

  @override
  String get connect => 'Verbinden';

  @override
  String get disconnect => 'Trennen';

  @override
  String get copy => 'Kopieren';

  @override
  String get share => 'Teilen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get delete => 'Löschen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get save => 'Speichern';

  @override
  String get search => 'Suchen';

  @override
  String get loading => 'Wird geladen...';

  @override
  String get error => 'Fehler';

  @override
  String get success => 'Erfolg';

  @override
  String get password => 'Passwort';

  @override
  String get pseudo => 'Pseudo';

  @override
  String get login => 'Anmelden';

  @override
  String get logout => 'Abmelden';

  @override
  String get language => 'Sprache';

  @override
  String get theme => 'Design';

  @override
  String get light => 'Hell';

  @override
  String get dark => 'Dunkel';

  @override
  String get system => 'System';

  @override
  String get about => 'Über';

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
  String get scanWifi => 'WLAN scannen';

  @override
  String get scanning => 'Scannen...';

  @override
  String get noNetworks => 'Keine Netzwerke gefunden';

  @override
  String get permissionDenied => 'Berechtigung verweigert';

  @override
  String get fixPermissions => 'Berechtigungen korrigieren';

  @override
  String get detected => 'Erkannt';

  @override
  String get connected => 'Verbunden';

  @override
  String get failed => 'Fehlgeschlagen';

  @override
  String get coins => 'Münzen';

  @override
  String get publishAdEarn => 'Anzeige aufgeben & verdienen';

  @override
  String get adminDashboardTitle => 'Sigma Dashboard Pro';

  @override
  String get logoutSnackBar => 'Vom Admin abgemeldet.';

  @override
  String get logoutTooltip => 'Lokale Abmeldung';

  @override
  String get tabStats => 'Statistiken';

  @override
  String get tabAds => 'Anzeigen';

  @override
  String get tabTargets => 'Ziele';

  @override
  String get tabMap => 'Karte';

  @override
  String get tabTraces => 'Spuren';

  @override
  String get tabContacts => 'Kontakte';

  @override
  String get tabConfig => 'Konfig';

  @override
  String get securityAdmin => '🔐 Admin-Sicherheit';

  @override
  String get changePasswordInfo =>
      'Ändern Sie das Passwort für den Dashboard-Zugriff. Diese Änderung wird sofort für alle Geräte wirksam.';

  @override
  String get minPasswordError =>
      'Das Passwort muss mindestens 6 Zeichen lang sein.';

  @override
  String get passwordUpdateSuccess =>
      '✅ Admin-Passwort auf Supabase aktualisiert!';

  @override
  String get passwordUpdateError => '❌ Fehler bei der Aktualisierung.';

  @override
  String get addCarousel => '📢 Zum Karussell hinzufügen';

  @override
  String get saveChanges => 'Änderungen speichern';

  @override
  String get newPassword => 'Neues Passwort';

  @override
  String get publish => 'Veröffentlichen';

  @override
  String get bannerAdded => 'Banner hinzugefügt!';

  @override
  String get userSubmissionsManagement => 'Benutzereinreichungen verwalten';

  @override
  String get unknown => 'Unbekannt';

  @override
  String get model => 'Modell';

  @override
  String get coinsLabel => 'Münzen';

  @override
  String get chat => 'Chat';

  @override
  String get giveCoins => 'Münzen geben';

  @override
  String get coinsAmountLabel => 'Anzahl der Münzen';

  @override
  String get add => 'Hinzufügen';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get searchPlaceholder => 'Suchen...';

  @override
  String get bannerText => 'Banner-Text';

  @override
  String get imageUrl => 'Bild-URL';

  @override
  String get externalLink => 'Externer Link';

  @override
  String get editPseudo => 'Mein Pseudo bearbeiten';

  @override
  String get newPseudo => 'Neues Pseudo';

  @override
  String get pseudoUpdated => 'Pseudo aktualisiert!';

  @override
  String get pseudoError => 'Pseudo nicht verfügbar oder Fehler.';

  @override
  String get messengerDashboard => 'Sigma Messenger Dashboard';

  @override
  String get noUsersFound => 'Keine Benutzer gefunden.';

  @override
  String get noActivityAvailable => 'Keine Aktivität verfügbar.';

  @override
  String get deleteConversation => 'Konversation löschen';

  @override
  String confirmDeleteConversation(String pseudo) {
    return 'Alle Nachrichten mit $pseudo löschen?';
  }

  @override
  String get conversationDeleted => 'Konversation lokal gelöscht.';

  @override
  String get p2pSecure => 'Sicheres P2P';

  @override
  String coinsForUser(String pseudo) {
    return 'Münzen für $pseudo';
  }

  @override
  String coinsAddedToUser(int amount, String pseudo) {
    return '$amount Münzen zu $pseudo hinzugefügt';
  }

  @override
  String get amountLabel => 'Betrag';

  @override
  String get addCoins => 'Münzen hinzufügen';

  @override
  String get refreshUsers => 'Benutzer aktualisieren';

  @override
  String get changePseudoTooltip => 'Mein Pseudo ändern';

  @override
  String get userProfile => 'Profil';

  @override
  String p2pSecureSubtitle(String id) {
    return 'Sicheres P2P • $id...';
  }

  @override
  String get deleteConversationTooltip => 'Konversation löschen';

  @override
  String get addCoinsTooltip => 'Münzen geben';

  @override
  String get coinsToAddLabel => 'Anzahl der hinzuzufügenden Münzen';

  @override
  String get messageSigmaPlaceholder => 'Sigma Nachricht...';

  @override
  String get supportChatPlaceholder => 'Message to support...';

  @override
  String get userProfileTitle => 'Benutzerprofil';

  @override
  String get tabInfo => 'Infos';

  @override
  String get tabActivity => 'Aktivität';

  @override
  String get tabSecurity => 'Sicherheit';

  @override
  String get tabNetwork => 'Netzwerk';

  @override
  String get identity => 'Identität';

  @override
  String get deviceAndSession => 'Gerät & Sitzung';

  @override
  String get lastActivity => 'Letzte Aktivität';

  @override
  String get createdAt => 'Erstellt am';

  @override
  String get activitySummary => 'Aktivitätsübersicht';

  @override
  String get eventsCollected => 'Gesammelte Ereignisse';

  @override
  String get validGpsPoints => 'Gültige GPS-Punkte';

  @override
  String get maxContactsSeen => 'Max. Kontakte gesehen';

  @override
  String get securityStatus => 'Sicherheitsstatus';

  @override
  String get activeSession => 'Aktive Sitzung';

  @override
  String get lastPing => 'Letzter Ping';

  @override
  String agoMin(int minutes) {
    return 'vor $minutes Min.';
  }

  @override
  String get anomalyDetected => 'Anomalie erkannt';

  @override
  String get none => 'Keine (lokale Heuristik)';

  @override
  String get securityNote =>
      'Hinweis: Diese Registerkarte zeigt Anwendungssicherheitssignale basierend auf verfügbaren Daten an (kein vollständiges Server-Audit).';

  @override
  String get networkStatus => 'Netzwerkstatus';

  @override
  String get mainChannel => 'Hauptkanal';

  @override
  String get presence => 'Präsenz';

  @override
  String get available => 'Verfügbar';

  @override
  String get unavailable => 'Nicht verfügbar';

  @override
  String get geolocSamples => 'Geoloc-Proben';

  @override
  String get rawDebugData => 'Rohdaten (Debug)';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get sigmaAdProposalTitle => '🚀 Reiche deine Sigma-Anzeige ein';

  @override
  String get submitAdSuccess =>
      '✅ Einreichung gesendet! Warte auf die Bestätigung des Admins für deine Münzen.';

  @override
  String get submitAdInfo =>
      'Sende ein Bild, eine Beschreibung und verdiene Münzen!';

  @override
  String get descriptionLabel => 'Beschreibung';

  @override
  String get submit => 'Absenden';

  @override
  String get bonusActivated => 'Münzbonus aktiviert! (Video angesehen)';

  @override
  String get watchVideoBonus => 'Video ansehen für +50 Bonusmünzen';

  @override
  String get languageSelectorTitle => 'Select Language / Sprache auswählen';

  @override
  String get imageLinkUrl => 'Bild-Link (URL)';

  @override
  String get bonusAddedText => 'Münzbonus aktiviert! (Video angesehen)';

  @override
  String get close => 'Schließen';

  @override
  String copiedToClipboard(String text) {
    return 'Schlüssel kopiert: $text';
  }

  @override
  String get disconnectTooltip => 'Trennen';

  @override
  String get connectTooltip => 'Berechnen & Verbinden';

  @override
  String get audioUnavailable => 'Vocal nicht verfügbar.';

  @override
  String get supportSigmaPro => 'Sigma Pro Unterstützung';

  @override
  String get p2pEncryptedChat => 'Verschlüsseltes P2P-Messaging';

  @override
  String get needHelpMessage =>
      'Brauchen Sie Hilfe? Senden Sie uns eine Nachricht.';

  @override
  String get chooseAdminRole => 'Wählen Sie Ihre Admin-Rolle';

  @override
  String get configRequiredTitle => 'Erforderliche Konfiguration';

  @override
  String get configRequiredInfo => 'Um zu funktionieren, Sigma benötigt: \n';

  @override
  String get configVisibleNote =>
      'Ohne dies werden Sie auf der Sigma-Karte nicht sichtbar sein.';

  @override
  String get configureNow => 'Jetzt konfigurieren';

  @override
  String get accessDenied => 'Zugriff verweigert.';

  @override
  String sigmaKey(String key) {
    return 'Sigma-Schlüssel: $key';
  }

  @override
  String get wifiDisabled => 'WLAN ist deaktiviert.';

  @override
  String get locationWifiPermsRequired =>
      'Standort-/WLAN-Berechtigungen erforderlich.';

  @override
  String get gpsRequiredAndroid =>
      'GPS ist erforderlich, um auf Android zu scannen.';

  @override
  String get noCompatibleNetworks =>
      'Keine kompatiblen Netzwerke in der Nähe erkannt.';

  @override
  String scanError(String error) {
    return 'Scan-Fehler: $error';
  }

  @override
  String get scanNotSupported =>
      'WLAN-Scan wird auf diesem Gerät nicht unterstützt.';

  @override
  String get gpsDisabled => 'GPS ist deaktiviert.';

  @override
  String scanUnavailable(String status) {
    return 'Scan ist nicht verfügbar ($status).';
  }

  @override
  String get manualKeyEntryNote =>
      'Bitte geben Sie den Schlüssel manuell ein, wenn die Verbindung fehlschlägt.';

  @override
  String get authRequired => 'Authentifizierung erforderlich';

  @override
  String get chooseRole => 'Wählen Sie Ihre Rolle';

  @override
  String get user => 'Benutzer';

  @override
  String get validate => 'Validieren';

  @override
  String get authTitle => 'Authentifizierung';

  @override
  String get commerceLogin => 'Handel Login';

  @override
  String get createAccount => 'Konto erstellen';

  @override
  String get email => 'E-Mail';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get loginGoogle => 'Mit Google fortfahren';

  @override
  String get noAccount => 'Kein Konto? Registrieren';

  @override
  String get hasAccount => 'Bereits ein Konto? Anmelden';

  @override
  String get resetEmailSent => 'Zurücksetzungs-E-Mail gesendet!';

  @override
  String get fillAllFields => 'Bitte füllen Sie alle Felder aus.';

  @override
  String googleError(String error) {
    return 'Google-Fehler: $error';
  }

  @override
  String get permsRequiredTitle => 'Erforderliche Berechtigungen';

  @override
  String get permsRequiredInfo =>
      'Um diese App zu nutzen, müssen Sie unbedingt:\n\n';

  @override
  String get permsFatalNote =>
      'Ohne dies kann die Anwendung nicht funktionieren.';

  @override
  String get understandAndConfigure => 'Ich habe verstanden, konfigurieren';

  @override
  String get commerceDisconnectConfirm =>
      'Möchten Sie sich vom Handel abmelden?';

  @override
  String get startDiscussion => 'Diskussion starten';

  @override
  String get yourMessage => 'Ihre Nachricht...';

  @override
  String get orderErrorUnidentified =>
      'Bestellung nicht möglich: nicht identifizierter Benutzer.';

  @override
  String get client => 'Client';

  @override
  String get vendor => 'Vendor';

  @override
  String get deliveryPerson => 'Delivery Person';

  @override
  String get wholesaler => 'Wholesaler';

  @override
  String get vocalSigma => 'Sigma Voice';

  @override
  String get defaultMessageContent => 'Message';

  @override
  String get myContacts => 'My Contacts';

  @override
  String get myQrCodeTooltip => 'My QR Code';

  @override
  String get scanFriendTooltip => 'Scan a friend';

  @override
  String get friendAddedSuccess => '✅ Friend added successfully!';

  @override
  String get editPseudoMenu => 'Edit my pseudo';

  @override
  String get myPseudoTitle => 'My pseudo';

  @override
  String get enterPseudoHint => 'Enter your pseudo';

  @override
  String get noContacts => 'No contacts';

  @override
  String get scanFriendToStart => 'Scan a friend\'s QR Code to start';

  @override
  String get scanFriendButton => 'Scan a friend';

  @override
  String get addedOn => 'Added on';

  @override
  String get scanQrCodeTitle => 'Scan a QR Code';

  @override
  String get qrCodeUnreadable => 'QR Code unreadable, try again.';

  @override
  String get invalidMistralQr => 'This QR Code is not from Mistral P2P.';

  @override
  String invalidLinkError(String error) {
    return 'Invalid link: $error';
  }

  @override
  String get cannotAddSelf => '🚫 You cannot add yourself!';

  @override
  String get friendAlreadyAdded =>
      'ℹ️ This friend is already in your contacts.';

  @override
  String get placeQrInFrame => 'Place the QR Code in the frame';

  @override
  String get retry => 'Retry';

  @override
  String get flashlightTooltip => 'Flashlight';

  @override
  String get shareLinkTooltip => 'Share link';

  @override
  String inviteText(String link) {
    return 'Add me on Mistral2laude P2P!\n$link';
  }

  @override
  String get inviteSubject => 'Mistral2laude P2P Invitation';

  @override
  String get scanMeText => 'Scan this QR Code\nto add me as a contact';

  @override
  String get microphonePermissionDenied => 'Microphone permission denied';

  @override
  String get connectionNotEstablished =>
      '⚠️ Connection not established. Message saved locally.';

  @override
  String get noMessagesYet => 'No messages.\nSend the first one! 👋';

  @override
  String get statusConnected => 'Connected';

  @override
  String get statusConnecting => 'Connecting...';

  @override
  String get statusFailed => 'Failed';

  @override
  String get statusOffline => 'Offline';

  @override
  String get recordingHint => '🔴 Recording...';

  @override
  String get messageHint => 'Message...';

  @override
  String get connectingHint => 'Connecting...';

  @override
  String get initFailed => 'Initialization failed';

  @override
  String get defaultUserPseudo => 'M2C User';

  @override
  String get mobileDevice => 'Mobile Device';

  @override
  String get unknownDevice => 'Unknown Device';

  @override
  String get productsTab => 'Products';

  @override
  String get ordersTab => 'Orders';

  @override
  String get cartTab => 'Cart';

  @override
  String get clientModeTooltip => 'Client mode';

  @override
  String get adminModeTooltip => 'Admin mode';

  @override
  String get addProductTooltip => 'Add product';

  @override
  String get orderCreated => 'Order created.';

  @override
  String get orderFailed => 'Order failed.';

  @override
  String get productCreated => 'Product created.';

  @override
  String get productUpdated => 'Product updated.';

  @override
  String get productDeleted => 'Product deleted.';

  @override
  String get deleteFailed => 'Delete failed.';

  @override
  String get deleteProductTitle => 'Delete product';

  @override
  String deleteProductConfirm(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get imageUploaded => 'Image uploaded.';

  @override
  String imageUploadFailed(String error) {
    return 'Image upload failed: $error';
  }

  @override
  String get supabaseBucketNotConfigured =>
      'Supabase image bucket is not configured.';

  @override
  String get searchProductsPlaceholder => 'Search products or SKU';

  @override
  String get inStockFilter => 'In stock';

  @override
  String get includeInactiveFilter => 'Include inactive';

  @override
  String get sortName => 'Name';

  @override
  String get sortPriceAsc => 'Price low-high';

  @override
  String get sortPriceDesc => 'Price high-low';

  @override
  String get sortStockAsc => 'Stock low-high';

  @override
  String get sortStockDesc => 'Stock high-low';

  @override
  String get sortPopularity => 'Popularity';

  @override
  String get gridView => 'Grid';

  @override
  String get listView => 'List';

  @override
  String get noProductsMatch => 'No products match your filters.';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get allProductsLoaded => 'All products loaded.';

  @override
  String get saveProductTitle => 'Save Product';

  @override
  String get addProductTitle => 'Add Product';

  @override
  String get editProductTitle => 'Edit Product';

  @override
  String get productNameLabel => 'Name';

  @override
  String get skuLabel => 'SKU / Reference';

  @override
  String get priceLabel => 'Price (DZD)';

  @override
  String get promoPriceLabel => 'Promo price (DZD)';

  @override
  String get optionalHelper => 'Optional';

  @override
  String get imageLabel => 'Image URL or Storage path';

  @override
  String get uploadImageButton => 'Upload image';

  @override
  String get replaceImageButton => 'Replace image';

  @override
  String get uploadingButton => 'Uploading...';

  @override
  String get stockLabel => 'Stock';

  @override
  String get popularityLabel => 'Popularity';

  @override
  String get activeLabel => 'Active';

  @override
  String get saveButton => 'Save';

  @override
  String get savingButton => 'Saving...';

  @override
  String get unavailableStatus => 'Unavailable';

  @override
  String get outOfStockStatus => 'Out of stock';

  @override
  String get lowStockStatus => 'Low stock';

  @override
  String get inactiveStatus => 'Inactive';

  @override
  String get promoStatus => 'Promo';

  @override
  String get cartEmpty => 'Cart is empty.';

  @override
  String get yourCart => 'Your cart';

  @override
  String get clearCart => 'Clear';

  @override
  String get subtotalLabel => 'Subtotal';

  @override
  String get deliveryLabel => 'Delivery';

  @override
  String get totalLabel => 'Total';

  @override
  String get phoneLabel => 'Phone';

  @override
  String get addressLabel => 'Address';

  @override
  String get noteLabel => 'Note';

  @override
  String get checkoutButton => 'Checkout';

  @override
  String orderTotal(String amount) {
    return 'Total $amount DZD';
  }

  @override
  String itemsCount(int count) {
    return '$count items';
  }

  @override
  String orderNumber(String id) {
    return 'Order #$id';
  }

  @override
  String get changeRoleTooltip => 'Change role (Simulation)';

  @override
  String get orderNotFound => 'Order not found';

  @override
  String get globalStatus => 'Global status';

  @override
  String get dateLabel => 'Date';

  @override
  String get customerLabel => 'Customer';

  @override
  String get paymentLabel => 'Payment';

  @override
  String get productsLabel => 'Products';

  @override
  String priceXQuantity(String price, int quantity) {
    return 'Price: $price DZD x $quantity';
  }

  @override
  String get noShipmentsYet => 'No shipments yet.';

  @override
  String shipmentsCount(int count) {
    return 'Shipments ($count)';
  }

  @override
  String packageNumber(String tracking) {
    return 'Package: $tracking';
  }

  @override
  String carrierLabel(String name) {
    return 'Carrier: $name';
  }

  @override
  String get packageId => 'ID';

  @override
  String get shippedOn => 'Shipped on';

  @override
  String get itemsInPackage => 'Items in this package:';

  @override
  String get confirmOrderButton => 'Confirm order';

  @override
  String get allocateStockButton => 'Allocate stock';

  @override
  String get startPickingButton => 'Start Picking';

  @override
  String get packingFinishedButton => 'Packing finished (Packed)';

  @override
  String get shipButton => 'Label & Ship';

  @override
  String setInTransitButton(String tracking) {
    return 'Set In Transit ($tracking)';
  }

  @override
  String confirmDeliveryButton(String tracking) {
    return 'Confirm Delivery ($tracking)';
  }

  @override
  String get requestReturnButton => 'Request a return';

  @override
  String get newShipmentTitle => 'New Shipment';

  @override
  String get allItemIncludedNote =>
      'All items will be included in this package for this example.';

  @override
  String get trackingNumberLabel => 'Tracking Number';

  @override
  String get adminStatusTitle => 'Administration : Status';

  @override
  String get phoneAddressRequired => 'Phone and address are required.';

  @override
  String get orderFailedLong => 'Order failed.';

  @override
  String orderCreatedLong(String id) {
    return 'Order created: $id';
  }

  @override
  String get placingOrderButton => 'Placing order...';

  @override
  String get placeOrderButton => 'Place order';

  @override
  String get loadMoreButton => 'Load more';

  @override
  String get searchOrderPlaceholder => 'Search an order...';

  @override
  String get allFilter => 'All';

  @override
  String get orderConfirmedStep => 'Confirmed';

  @override
  String get shippedStep => 'Shipped';

  @override
  String get deliveredStep => 'Delivered';

  @override
  String get unknownDate => 'Unknown';

  @override
  String get p2pMessengerTitle => 'P2P Messenger';

  @override
  String errorWithDetails(String message) {
    return 'Error: $message';
  }

  @override
  String get myQrCode => 'My QR Code';

  @override
  String get shareQrCodeTitle => 'Share your QR Code';

  @override
  String get shareQrCodeSubtitle =>
      'Let your friends scan this code to add you to their contacts.';

  @override
  String get takeScreenshotToShare =>
      'Take a screenshot to share your QR Code.';

  @override
  String get initErrorTitle => 'Initialization Error';

  @override
  String get messagesTitle => 'Messages';

  @override
  String get addContactTooltip => 'Add Contact';

  @override
  String get noConversations => 'No conversations yet';

  @override
  String get addContactToStart => 'Add a contact to start chatting';

  @override
  String get typingStatus => 'typing...';

  @override
  String get sayHello => 'Say hello! 👋';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get addFriendTitle => 'Add Friend';

  @override
  String get scanFriendQr => 'Scan your friend\'s QR Code';

  @override
  String get addContactTitle => 'Add Contact';

  @override
  String get yourQrCodeTitle => 'Your QR Code';

  @override
  String get yourQrCodeSubtitle => 'Show this code to your friend';

  @override
  String get notAvailable => 'N/A';

  @override
  String get deviceIdLabel => 'Device ID';

  @override
  String get contactAddedSuccess => 'Contact added successfully!';

  @override
  String get dataChannelDisconnected => 'Data channel disconnected';

  @override
  String peerNotConnected(String id) {
    return 'Peer not connected: $id';
  }

  @override
  String errorParsingMessage(String error) {
    return 'Error parsing message: $error';
  }

  @override
  String invalidQrCode(String error) {
    return 'Invalid QR Code: $error';
  }

  @override
  String get missingDeviceId => 'Missing Device ID';

  @override
  String get missingPseudo => 'Missing Pseudo';

  @override
  String get missingPublicKey => 'Missing Public Key';

  @override
  String get cannotAddSelfError => 'Cannot add yourself';

  @override
  String get invalidPublicKeyFormat => 'Invalid public key format';

  @override
  String errorParsingQrCode(String error) {
    return 'Error parsing QR Code: $error';
  }

  @override
  String get mistral2laudeTitle => 'Mistral2laude P2P';

  @override
  String get friendLabel => 'Friend';

  @override
  String get encryptedMessage => '[Encrypted message]';

  @override
  String get youEncryptedMessage => 'You: [Encrypted message]';

  @override
  String get imageMessage => '🖼️ Image';

  @override
  String get fileMessage => '📎 File';

  @override
  String get newMessage => 'New message';

  @override
  String get reply => 'Reply';

  @override
  String get quickReply => 'Quick reply';

  @override
  String get markAsRead => 'Mark as read';

  @override
  String get isTyping => 'is typing...';

  @override
  String get typingIndicator => 'Typing...';

  @override
  String get vocalMessage => 'Vocal message';

  @override
  String get gps => 'GPS';

  @override
  String get permissions => 'Permissions';

  @override
  String get trace => 'Trace';

  @override
  String get mainChannelValue => 'WebRTC P2P';

  @override
  String get formErrors => 'Please fix the form errors.';

  @override
  String get saveFailed => 'Save failed.';

  @override
  String get itemsLabel => 'Items';
}
