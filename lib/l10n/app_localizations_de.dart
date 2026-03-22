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
  String confirmDeleteConversation(Object pseudo) {
    return 'Alle Nachrichten mit $pseudo löschen?';
  }

  @override
  String get conversationDeleted => 'Konversation lokal gelöscht.';

  @override
  String get p2pSecure => 'Sicheres P2P';

  @override
  String coinsForUser(Object pseudo) {
    return 'Münzen für $pseudo';
  }

  @override
  String coinsAddedToUser(Object amount, Object pseudo) {
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
  String p2pSecureSubtitle(Object id) {
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
  String agoMin(Object minutes) {
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
  String copiedToClipboard(Object text) {
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
  String sigmaKey(Object key) {
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
  String scanError(Object error) {
    return 'Scan-Fehler: $error';
  }

  @override
  String get scanNotSupported =>
      'WLAN-Scan wird auf diesem Gerät nicht unterstützt.';

  @override
  String get gpsDisabled => 'GPS ist deaktiviert.';

  @override
  String scanUnavailable(Object status) {
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
  String googleError(Object error) {
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
}
