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
  String get admin => 'Administrator';

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
  String get adminTooltip => 'Administrator';

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
  String get messengerDashboard => 'Sigma Messenger-Dashboard';

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
  String get supportChatPlaceholder => 'Nachricht an den Support...';

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
  String get client => 'Kunde';

  @override
  String get vendor => 'Verk?ufer';

  @override
  String get deliveryPerson => 'Zusteller';

  @override
  String get wholesaler => 'Gro?h?ndler';

  @override
  String get vocalSigma => 'Sigma-Stimme';

  @override
  String get defaultMessageContent => 'Nachricht';

  @override
  String get myContacts => 'Meine Kontakte';

  @override
  String get myQrCodeTooltip => 'Mein QR-Code';

  @override
  String get scanFriendTooltip => 'Freund scannen';

  @override
  String get friendAddedSuccess => '? Freund erfolgreich hinzugef?gt!';

  @override
  String get editPseudoMenu => 'Mein Pseudonym bearbeiten';

  @override
  String get myPseudoTitle => 'Mein Pseudonym';

  @override
  String get enterPseudoHint => 'Gib dein Pseudonym ein';

  @override
  String get noContacts => 'Keine Kontakte';

  @override
  String get scanFriendToStart =>
      'Scanne den QR-Code eines Freundes, um zu starten';

  @override
  String get scanFriendButton => 'Freund scannen';

  @override
  String get addedOn => 'Hinzugef?gt am';

  @override
  String get scanQrCodeTitle => 'QR-Code scannen';

  @override
  String get qrCodeUnreadable => 'QR-Code unlesbar, bitte erneut versuchen.';

  @override
  String get invalidMistralQr => 'Dieser QR-Code stammt nicht von Mistral P2P.';

  @override
  String invalidLinkError(String error) {
    return 'Ung?ltiger Link: $error';
  }

  @override
  String get cannotAddSelf => '?? Du kannst dich nicht selbst hinzuf?gen!';

  @override
  String get friendAlreadyAdded =>
      '?? Dieser Freund ist bereits in deinen Kontakten.';

  @override
  String get placeQrInFrame => 'Platziere den QR-Code im Rahmen';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get flashlightTooltip => 'Taschenlampe';

  @override
  String get shareLinkTooltip => 'Link teilen';

  @override
  String inviteText(String link) {
    return 'F?ge mich bei Mistral2laude P2P hinzu!\n$link';
  }

  @override
  String get inviteSubject => 'Mistral2laude P2P Einladung';

  @override
  String get scanMeText =>
      'Scanne diesen QR-Code\num mich als Kontakt hinzuzuf?gen';

  @override
  String get microphonePermissionDenied => 'Mikrofonberechtigung verweigert';

  @override
  String get connectionNotEstablished =>
      '?? Verbindung nicht hergestellt. Nachricht lokal gespeichert.';

  @override
  String get noMessagesYet => 'Keine Nachrichten.\nSende die erste! ??';

  @override
  String get statusConnected => 'Verbunden';

  @override
  String get statusConnecting => 'Verbinde...';

  @override
  String get statusFailed => 'Fehlgeschlagen';

  @override
  String get statusOffline => 'Offline';

  @override
  String get recordingHint => '?? Aufnahme...';

  @override
  String get messageHint => 'Nachricht...';

  @override
  String get connectingHint => 'Verbinde...';

  @override
  String get initFailed => 'Initialisierung fehlgeschlagen';

  @override
  String get defaultUserPseudo => 'M2C Benutzer';

  @override
  String get mobileDevice => 'Mobiles Ger?t';

  @override
  String get unknownDevice => 'Unbekanntes Ger?t';

  @override
  String get productsTab => 'Produkte';

  @override
  String get ordersTab => 'Bestellungen';

  @override
  String get cartTab => 'Warenkorb';

  @override
  String get clientModeTooltip => 'Kundenmodus';

  @override
  String get adminModeTooltip => 'Admin-Modus';

  @override
  String get addProductTooltip => 'Produkt hinzuf?gen';

  @override
  String get orderCreated => 'Bestellung erstellt.';

  @override
  String get orderFailed => 'Bestellung fehlgeschlagen.';

  @override
  String get productCreated => 'Produkt erstellt.';

  @override
  String get productUpdated => 'Produkt aktualisiert.';

  @override
  String get productDeleted => 'Produkt gel?scht.';

  @override
  String get deleteFailed => 'L?schen fehlgeschlagen.';

  @override
  String get deleteProductTitle => 'Produkt l?schen';

  @override
  String deleteProductConfirm(String name) {
    return '\"$name\" l?schen?';
  }

  @override
  String get imageUploaded => 'Bild hochgeladen.';

  @override
  String imageUploadFailed(String error) {
    return 'Bild-Upload fehlgeschlagen: $error';
  }

  @override
  String get supabaseBucketNotConfigured =>
      'Supabase-Bild-Bucket ist nicht konfiguriert.';

  @override
  String get searchProductsPlaceholder => 'Produkte oder SKU suchen';

  @override
  String get inStockFilter => 'Auf Lager';

  @override
  String get includeInactiveFilter => 'Inaktive einschlie?en';

  @override
  String get sortName => 'Name';

  @override
  String get sortPriceAsc => 'Preis aufsteigend';

  @override
  String get sortPriceDesc => 'Preis absteigend';

  @override
  String get sortStockAsc => 'Bestand aufsteigend';

  @override
  String get sortStockDesc => 'Bestand absteigend';

  @override
  String get sortPopularity => 'Beliebtheit';

  @override
  String get gridView => 'Gitter';

  @override
  String get listView => 'Liste';

  @override
  String get noProductsMatch => 'Keine Produkte passen zu deinen Filtern.';

  @override
  String get clearFilters => 'Filter l?schen';

  @override
  String get allProductsLoaded => 'Alle Produkte geladen.';

  @override
  String get saveProductTitle => 'Produkt speichern';

  @override
  String get addProductTitle => 'Produkt hinzuf?gen';

  @override
  String get editProductTitle => 'Produkt bearbeiten';

  @override
  String get productNameLabel => 'Name';

  @override
  String get skuLabel => 'SKU / Referenz';

  @override
  String get priceLabel => 'Preis (DZD)';

  @override
  String get promoPriceLabel => 'Aktionspreis (DZD)';

  @override
  String get optionalHelper => 'Optional';

  @override
  String get imageLabel => 'Bild-URL oder Storage-Pfad';

  @override
  String get uploadImageButton => 'Bild hochladen';

  @override
  String get replaceImageButton => 'Bild ersetzen';

  @override
  String get uploadingButton => 'Wird hochgeladen...';

  @override
  String get stockLabel => 'Bestand';

  @override
  String get popularityLabel => 'Beliebtheit';

  @override
  String get activeLabel => 'Aktiv';

  @override
  String get saveButton => 'Speichern';

  @override
  String get savingButton => 'Speichern...';

  @override
  String get unavailableStatus => 'Nicht verf?gbar';

  @override
  String get outOfStockStatus => 'Nicht auf Lager';

  @override
  String get lowStockStatus => 'Niedriger Bestand';

  @override
  String get inactiveStatus => 'Inaktiv';

  @override
  String get promoStatus => 'Aktion';

  @override
  String get cartEmpty => 'Warenkorb ist leer.';

  @override
  String get yourCart => 'Dein Warenkorb';

  @override
  String get clearCart => 'Leeren';

  @override
  String get subtotalLabel => 'Zwischensumme';

  @override
  String get deliveryLabel => 'Lieferung';

  @override
  String get totalLabel => 'Gesamt';

  @override
  String get phoneLabel => 'Telefon';

  @override
  String get addressLabel => 'Adresse';

  @override
  String get noteLabel => 'Notiz';

  @override
  String get checkoutButton => 'Zur Kasse';

  @override
  String orderTotal(String amount) {
    return 'Gesamt $amount DZD';
  }

  @override
  String itemsCount(int count) {
    return '$count Artikel';
  }

  @override
  String orderNumber(String id) {
    return 'Bestellung #$id';
  }

  @override
  String get changeRoleTooltip => 'Rolle ?ndern (Simulation)';

  @override
  String get orderNotFound => 'Bestellung nicht gefunden';

  @override
  String get globalStatus => 'Gesamtstatus';

  @override
  String get dateLabel => 'Datum';

  @override
  String get customerLabel => 'Kunde';

  @override
  String get paymentLabel => 'Zahlung';

  @override
  String get productsLabel => 'Produkte';

  @override
  String priceXQuantity(String price, int quantity) {
    return 'Preis: $price DZD x $quantity';
  }

  @override
  String amountWithCurrency(String amount) {
    return '$amount DZD';
  }

  @override
  String shipmentItemLine(String name, int quantity) {
    return '? $name (x$quantity)';
  }

  @override
  String get noShipmentsYet => 'Noch keine Sendungen.';

  @override
  String shipmentsCount(int count) {
    return 'Sendungen ($count)';
  }

  @override
  String packageNumber(String tracking) {
    return 'Paket: $tracking';
  }

  @override
  String carrierLabel(String name) {
    return 'Transporteur: $name';
  }

  @override
  String get packageId => 'ID';

  @override
  String get shippedOn => 'Versandt am';

  @override
  String get itemsInPackage => 'Artikel in diesem Paket:';

  @override
  String get confirmOrderButton => 'Bestellung best?tigen';

  @override
  String get allocateStockButton => 'Bestand zuweisen';

  @override
  String get startPickingButton => 'Kommissionierung starten';

  @override
  String get packingFinishedButton => 'Packen abgeschlossen (Verpackt)';

  @override
  String get shipButton => 'Etikettieren & Versenden';

  @override
  String setInTransitButton(String tracking) {
    return 'In Transit setzen ($tracking)';
  }

  @override
  String confirmDeliveryButton(String tracking) {
    return 'Lieferung best?tigen ($tracking)';
  }

  @override
  String get requestReturnButton => 'R?cksendung anfordern';

  @override
  String get newShipmentTitle => 'Neue Sendung';

  @override
  String get allItemIncludedNote =>
      'Alle Artikel werden in diesem Paket f?r dieses Beispiel enthalten sein.';

  @override
  String get trackingNumberLabel => 'Sendungsnummer';

  @override
  String get adminStatusTitle => 'Administration: Status';

  @override
  String get phoneAddressRequired => 'Telefon und Adresse sind erforderlich.';

  @override
  String get orderFailedLong => 'Bestellung fehlgeschlagen.';

  @override
  String orderCreatedLong(String id) {
    return 'Bestellung erstellt: $id';
  }

  @override
  String get placingOrderButton => 'Bestellung wird aufgegeben...';

  @override
  String get placeOrderButton => 'Bestellung aufgeben';

  @override
  String get loadMoreButton => 'Mehr laden';

  @override
  String get searchOrderPlaceholder => 'Bestellung suchen...';

  @override
  String get allFilter => 'Alle';

  @override
  String get orderConfirmedStep => 'Best?tigt';

  @override
  String get shippedStep => 'Versandt';

  @override
  String get deliveredStep => 'Zugestellt';

  @override
  String get unknownDate => 'Unbekannt';

  @override
  String get p2pMessengerTitle => 'P2P-Messenger';

  @override
  String errorWithDetails(String message) {
    return 'Fehler: $message';
  }

  @override
  String get myQrCode => 'Mein QR-Code';

  @override
  String get shareQrCodeTitle => 'Teile deinen QR-Code';

  @override
  String get shareQrCodeSubtitle =>
      'Lass deine Freunde diesen Code scannen, um dich zu ihren Kontakten hinzuzuf?gen.';

  @override
  String get takeScreenshotToShare =>
      'Mach einen Screenshot, um deinen QR-Code zu teilen.';

  @override
  String get initErrorTitle => 'Initialisierungsfehler';

  @override
  String get messagesTitle => 'Nachrichten';

  @override
  String get addContactTooltip => 'Kontakt hinzuf?gen';

  @override
  String get noConversations => 'Noch keine Unterhaltungen';

  @override
  String get addContactToStart => 'F?ge einen Kontakt hinzu, um zu chatten';

  @override
  String get typingStatus => 'schreibt...';

  @override
  String get sayHello => 'Sag hallo! ??';

  @override
  String get yesterday => 'Gestern';

  @override
  String get addFriendTitle => 'Freund hinzuf?gen';

  @override
  String get scanFriendQr => 'Scanne den QR-Code deines Freundes';

  @override
  String get addContactTitle => 'Kontakt hinzuf?gen';

  @override
  String get yourQrCodeTitle => 'Dein QR-Code';

  @override
  String get yourQrCodeSubtitle => 'Zeige diesen Code deinem Freund';

  @override
  String get notAvailable => 'k. A.';

  @override
  String get deviceIdLabel => 'Geräte-ID';

  @override
  String get contactAddedSuccess => 'Kontakt erfolgreich hinzugef?gt!';

  @override
  String get dataChannelDisconnected => 'Datenkanal getrennt';

  @override
  String peerNotConnected(String id) {
    return 'Peer nicht verbunden: $id';
  }

  @override
  String errorParsingMessage(String error) {
    return 'Fehler beim Parsen der Nachricht: $error';
  }

  @override
  String invalidQrCode(String error) {
    return 'Ung?ltiger QR-Code: $error';
  }

  @override
  String get missingDeviceId => 'Fehlende Geräte-ID';

  @override
  String get missingPseudo => 'Pseudonym fehlt';

  @override
  String get missingPublicKey => '?ffentlicher Schl?ssel fehlt';

  @override
  String get cannotAddSelfError => 'Du kannst dich nicht selbst hinzuf?gen';

  @override
  String get invalidPublicKeyFormat =>
      'Ung?ltiges Format des ?ffentlichen Schl?ssels';

  @override
  String errorParsingQrCode(String error) {
    return 'Fehler beim Parsen des QR-Codes: $error';
  }

  @override
  String get mistral2laudeTitle => 'Mistral2laude P2P';

  @override
  String get friendLabel => 'Freund';

  @override
  String get encryptedMessage => '[Verschl?sselte Nachricht]';

  @override
  String get youEncryptedMessage => 'Du: [Verschl?sselte Nachricht]';

  @override
  String get imageMessage => '??? Bild';

  @override
  String get fileMessage => '?? Datei';

  @override
  String get newMessage => 'Neue Nachricht';

  @override
  String get reply => 'Antworten';

  @override
  String get quickReply => 'Schnelle Antwort';

  @override
  String get markAsRead => 'Als gelesen markieren';

  @override
  String get isTyping => 'schreibt...';

  @override
  String get typingIndicator => 'Tippt...';

  @override
  String get vocalMessage => 'Sprachnachricht';

  @override
  String get gps => 'GPS';

  @override
  String get permissions => 'Berechtigungen';

  @override
  String get trace => 'Spur';

  @override
  String get mainChannelValue => 'WebRTC P2P';

  @override
  String get formErrors => 'Bitte beheben Sie die Formularfehler.';

  @override
  String get saveFailed => 'Speichern fehlgeschlagen.';

  @override
  String get itemsLabel => 'Artikel';

  @override
  String get productInfoSection => 'Informationen';

  @override
  String get productImageSection => 'Bild';

  @override
  String get productStockStatusSection => 'Bestand & Status';

  @override
  String get categoryLabel => 'Kategorie';

  @override
  String get nameRequired => 'Name ist erforderlich';

  @override
  String get priceRequired => 'Preis ist erforderlich';

  @override
  String get invalidPrice => 'Geben Sie einen gültigen Preis ein';

  @override
  String get invalidPromoPrice => 'Geben Sie einen gültigen Aktionspreis ein';

  @override
  String get promoLowerThanPrice =>
      'Aktionspreis muss niedriger als der Preis sein';

  @override
  String get invalidStock => 'Geben Sie einen gültigen Bestand ein';

  @override
  String get popularityHelper => 'Höher bedeutet beliebter';

  @override
  String get invalidPopularity => 'Geben Sie eine gültige Popularität ein';

  @override
  String get addToCart => 'In den Warenkorb';

  @override
  String get stockUnknown => 'Bestand unbekannt';

  @override
  String get startChatPrompt => 'Starten Sie die Unterhaltung';

  @override
  String get realtimeMessengerTitle => 'Sigma Messenger (Echtzeit)';

  @override
  String get clear => 'Leeren';

  @override
  String get warehouseRole => 'Lager';

  @override
  String get carrierRole => 'Spediteur';

  @override
  String get supportRole => 'Support-Team';

  @override
  String get orderStatusCreated => 'Erstellt';

  @override
  String get orderStatusPendingPayment => 'Zahlung ausstehend';

  @override
  String get orderStatusPaid => 'Bezahlt';

  @override
  String get orderStatusPaymentFailed => 'Zahlung fehlgeschlagen';

  @override
  String get orderStatusCancelRequested => 'Stornierung angefordert';

  @override
  String get orderStatusCancelled => 'Storniert';

  @override
  String get orderStatusOrderConfirmed => 'Bestätigt';

  @override
  String get orderStatusStockAllocated => 'Bestand zugewiesen';

  @override
  String get orderStatusBackorder => 'Rückstand';

  @override
  String get orderStatusPicking => 'Kommissionierung';

  @override
  String get orderStatusPacked => 'Verpackt';

  @override
  String get orderStatusReadyToShip => 'Versandbereit';

  @override
  String get orderStatusPartiallyShipped => 'Teilweise versandt';

  @override
  String get orderStatusShipped => 'Versandt';

  @override
  String get orderStatusPartiallyDelivered => 'Teilweise geliefert';

  @override
  String get orderStatusDelivered => 'Geliefert';

  @override
  String get orderStatusDeliveryFailed => 'Lieferung fehlgeschlagen';

  @override
  String get orderStatusException => 'Ausnahme';

  @override
  String get orderStatusReturnRequested => 'Rücksendung angefordert';

  @override
  String get orderStatusReturnInTransit => 'Rücksendung unterwegs';

  @override
  String get orderStatusReturnReceived => 'Rücksendung erhalten';

  @override
  String get orderStatusRefundPending => 'Rückerstattung ausstehend';

  @override
  String get orderStatusRefunded => 'Erstattet';

  @override
  String get orderStatusClosed => 'Abgeschlossen';

  @override
  String get shipmentStatusLabelCreated => 'Etikett erstellt';

  @override
  String get shipmentStatusPickedUp => 'Abgeholt';

  @override
  String get shipmentStatusInTransit => 'Unterwegs';

  @override
  String get shipmentStatusArrivedAtHub => 'Am Hub angekommen';

  @override
  String get shipmentStatusCustomsClearance => 'Zollabfertigung';

  @override
  String get shipmentStatusOutForDelivery => 'In Zustellung';

  @override
  String get shipmentStatusDelivered => 'Zugestellt';

  @override
  String get shipmentStatusDeliveryFailed => 'Zustellung fehlgeschlagen';

  @override
  String get shipmentStatusException => 'Ausnahme';

  @override
  String get shipmentStatusLost => 'Verloren';

  @override
  String get shipmentStatusDamaged => 'Beschädigt';

  @override
  String get shipmentStatusReturnToSender => 'Rücksendung an Absender';

  @override
  String get returnStatusRequested => 'Angefordert';

  @override
  String get returnStatusAuthorized => 'Autorisiert';

  @override
  String get returnStatusLabelIssued => 'Etikett ausgestellt';

  @override
  String get returnStatusInTransit => 'Unterwegs';

  @override
  String get returnStatusReceived => 'Erhalten';

  @override
  String get returnStatusRejected => 'Abgelehnt';

  @override
  String get returnStatusRefundPending => 'Rückerstattung ausstehend';

  @override
  String get returnStatusRefunded => 'Erstattet';

  @override
  String get paymentStatusPending => 'Ausstehend';

  @override
  String get paymentStatusAuthorized => 'Autorisiert';

  @override
  String get paymentStatusCaptured => 'Abgebucht';

  @override
  String get paymentStatusVoided => 'Storniert';

  @override
  String get paymentStatusRefunded => 'Erstattet';

  @override
  String get paymentStatusFailed => 'Fehlgeschlagen';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get orderNoteLabel => 'Order Note (optional)';

  @override
  String addedToCart(String product) {
    return '$product added to cart';
  }

  @override
  String get bestSeller => 'Bestseller';

  @override
  String get readMore => 'mehr lesen';

  @override
  String get showLess => 'weniger anzeigen';
}
