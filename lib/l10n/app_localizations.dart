import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_id.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('id'),
    Locale('ja'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'WiFi Fiber Hack'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @commerce.
  ///
  /// In en, this message translates to:
  /// **'Commerce'**
  String get commerce;

  /// No description provided for @p2pChat.
  ///
  /// In en, this message translates to:
  /// **'P2P Chat'**
  String get p2pChat;

  /// No description provided for @publishAd.
  ///
  /// In en, this message translates to:
  /// **'Publish Ad'**
  String get publishAd;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @disconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @pseudo.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get pseudo;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @profileTooltip.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTooltip;

  /// No description provided for @adminTooltip.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get adminTooltip;

  /// No description provided for @chatTooltip.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chatTooltip;

  /// No description provided for @p2pTooltip.
  ///
  /// In en, this message translates to:
  /// **'P2P'**
  String get p2pTooltip;

  /// No description provided for @scanWifi.
  ///
  /// In en, this message translates to:
  /// **'Scan WiFi'**
  String get scanWifi;

  /// No description provided for @scanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning...'**
  String get scanning;

  /// No description provided for @noNetworks.
  ///
  /// In en, this message translates to:
  /// **'No networks found'**
  String get noNetworks;

  /// No description provided for @permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get permissionDenied;

  /// No description provided for @fixPermissions.
  ///
  /// In en, this message translates to:
  /// **'Fix permissions'**
  String get fixPermissions;

  /// No description provided for @detected.
  ///
  /// In en, this message translates to:
  /// **'Detected'**
  String get detected;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @coins.
  ///
  /// In en, this message translates to:
  /// **'Coins'**
  String get coins;

  /// No description provided for @publishAdEarn.
  ///
  /// In en, this message translates to:
  /// **'Publish Ad & Earn'**
  String get publishAdEarn;

  /// No description provided for @adminDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Sigma Dashboard Pro'**
  String get adminDashboardTitle;

  /// No description provided for @logoutSnackBar.
  ///
  /// In en, this message translates to:
  /// **'Disconnected from admin.'**
  String get logoutSnackBar;

  /// No description provided for @logoutTooltip.
  ///
  /// In en, this message translates to:
  /// **'Local Logout'**
  String get logoutTooltip;

  /// No description provided for @tabStats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get tabStats;

  /// No description provided for @tabAds.
  ///
  /// In en, this message translates to:
  /// **'Ads'**
  String get tabAds;

  /// No description provided for @tabTargets.
  ///
  /// In en, this message translates to:
  /// **'Targets'**
  String get tabTargets;

  /// No description provided for @tabMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get tabMap;

  /// No description provided for @tabTraces.
  ///
  /// In en, this message translates to:
  /// **'Traces'**
  String get tabTraces;

  /// No description provided for @tabContacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get tabContacts;

  /// No description provided for @tabConfig.
  ///
  /// In en, this message translates to:
  /// **'Config'**
  String get tabConfig;

  /// No description provided for @securityAdmin.
  ///
  /// In en, this message translates to:
  /// **'🔐 Security Admin'**
  String get securityAdmin;

  /// No description provided for @changePasswordInfo.
  ///
  /// In en, this message translates to:
  /// **'Change the dashboard access password. This change is immediate for all devices.'**
  String get changePasswordInfo;

  /// No description provided for @minPasswordError.
  ///
  /// In en, this message translates to:
  /// **'The password must be at least 6 characters.'**
  String get minPasswordError;

  /// No description provided for @passwordUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'✅ Admin password updated on Supabase!'**
  String get passwordUpdateSuccess;

  /// No description provided for @passwordUpdateError.
  ///
  /// In en, this message translates to:
  /// **'❌ Error during update.'**
  String get passwordUpdateError;

  /// No description provided for @addCarousel.
  ///
  /// In en, this message translates to:
  /// **'📢 Add to Carousel'**
  String get addCarousel;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @publish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get publish;

  /// No description provided for @bannerAdded.
  ///
  /// In en, this message translates to:
  /// **'Banner added!'**
  String get bannerAdded;

  /// No description provided for @userSubmissionsManagement.
  ///
  /// In en, this message translates to:
  /// **'User submissions management'**
  String get userSubmissionsManagement;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @model.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// No description provided for @coinsLabel.
  ///
  /// In en, this message translates to:
  /// **'Coins'**
  String get coinsLabel;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @giveCoins.
  ///
  /// In en, this message translates to:
  /// **'Give Coins'**
  String get giveCoins;

  /// No description provided for @coinsAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Number of coins'**
  String get coinsAmountLabel;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get searchPlaceholder;

  /// No description provided for @bannerText.
  ///
  /// In en, this message translates to:
  /// **'Banner text'**
  String get bannerText;

  /// No description provided for @imageUrl.
  ///
  /// In en, this message translates to:
  /// **'Image URL'**
  String get imageUrl;

  /// No description provided for @externalLink.
  ///
  /// In en, this message translates to:
  /// **'External link'**
  String get externalLink;

  /// No description provided for @editPseudo.
  ///
  /// In en, this message translates to:
  /// **'Edit my Pseudo'**
  String get editPseudo;

  /// No description provided for @newPseudo.
  ///
  /// In en, this message translates to:
  /// **'New Pseudo'**
  String get newPseudo;

  /// No description provided for @pseudoUpdated.
  ///
  /// In en, this message translates to:
  /// **'Pseudo updated!'**
  String get pseudoUpdated;

  /// No description provided for @pseudoError.
  ///
  /// In en, this message translates to:
  /// **'Pseudo unavailable or error.'**
  String get pseudoError;

  /// No description provided for @messengerDashboard.
  ///
  /// In en, this message translates to:
  /// **'Sigma Messenger Dashboard'**
  String get messengerDashboard;

  /// No description provided for @noUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found.'**
  String get noUsersFound;

  /// No description provided for @noActivityAvailable.
  ///
  /// In en, this message translates to:
  /// **'No activity available.'**
  String get noActivityAvailable;

  /// No description provided for @deleteConversation.
  ///
  /// In en, this message translates to:
  /// **'Delete conversation'**
  String get deleteConversation;

  /// No description provided for @confirmDeleteConversation.
  ///
  /// In en, this message translates to:
  /// **'Delete all messages with {pseudo}?'**
  String confirmDeleteConversation(String pseudo);

  /// No description provided for @conversationDeleted.
  ///
  /// In en, this message translates to:
  /// **'Conversation deleted locally.'**
  String get conversationDeleted;

  /// No description provided for @p2pSecure.
  ///
  /// In en, this message translates to:
  /// **'Secure P2P'**
  String get p2pSecure;

  /// No description provided for @coinsForUser.
  ///
  /// In en, this message translates to:
  /// **'Coins for {pseudo}'**
  String coinsForUser(String pseudo);

  /// No description provided for @coinsAddedToUser.
  ///
  /// In en, this message translates to:
  /// **'{amount} coins added to {pseudo}'**
  String coinsAddedToUser(int amount, String pseudo);

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountLabel;

  /// No description provided for @addCoins.
  ///
  /// In en, this message translates to:
  /// **'Add Coins'**
  String get addCoins;

  /// No description provided for @refreshUsers.
  ///
  /// In en, this message translates to:
  /// **'Refresh Users'**
  String get refreshUsers;

  /// No description provided for @changePseudoTooltip.
  ///
  /// In en, this message translates to:
  /// **'Change my pseudo'**
  String get changePseudoTooltip;

  /// No description provided for @userProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get userProfile;

  /// No description provided for @p2pSecureSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Secure P2P • {id}...'**
  String p2pSecureSubtitle(String id);

  /// No description provided for @deleteConversationTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear conversation'**
  String get deleteConversationTooltip;

  /// No description provided for @addCoinsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Give coins'**
  String get addCoinsTooltip;

  /// No description provided for @coinsToAddLabel.
  ///
  /// In en, this message translates to:
  /// **'Number of coins to add'**
  String get coinsToAddLabel;

  /// No description provided for @messageSigmaPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Sigma Message...'**
  String get messageSigmaPlaceholder;

  /// No description provided for @supportChatPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Message to support...'**
  String get supportChatPlaceholder;

  /// No description provided for @userProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'User Profile'**
  String get userProfileTitle;

  /// No description provided for @tabInfo.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get tabInfo;

  /// No description provided for @tabActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get tabActivity;

  /// No description provided for @tabSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get tabSecurity;

  /// No description provided for @tabNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get tabNetwork;

  /// No description provided for @identity.
  ///
  /// In en, this message translates to:
  /// **'Identity'**
  String get identity;

  /// No description provided for @deviceAndSession.
  ///
  /// In en, this message translates to:
  /// **'Device & Session'**
  String get deviceAndSession;

  /// No description provided for @lastActivity.
  ///
  /// In en, this message translates to:
  /// **'Last Activity'**
  String get lastActivity;

  /// No description provided for @createdAt.
  ///
  /// In en, this message translates to:
  /// **'Created at'**
  String get createdAt;

  /// No description provided for @activitySummary.
  ///
  /// In en, this message translates to:
  /// **'Activity Summary'**
  String get activitySummary;

  /// No description provided for @eventsCollected.
  ///
  /// In en, this message translates to:
  /// **'Events collected'**
  String get eventsCollected;

  /// No description provided for @validGpsPoints.
  ///
  /// In en, this message translates to:
  /// **'Valid GPS points'**
  String get validGpsPoints;

  /// No description provided for @maxContactsSeen.
  ///
  /// In en, this message translates to:
  /// **'Max contacts seen'**
  String get maxContactsSeen;

  /// No description provided for @securityStatus.
  ///
  /// In en, this message translates to:
  /// **'Security Status'**
  String get securityStatus;

  /// No description provided for @activeSession.
  ///
  /// In en, this message translates to:
  /// **'Active session'**
  String get activeSession;

  /// No description provided for @lastPing.
  ///
  /// In en, this message translates to:
  /// **'Last ping'**
  String get lastPing;

  /// No description provided for @agoMin.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min ago'**
  String agoMin(int minutes);

  /// No description provided for @anomalyDetected.
  ///
  /// In en, this message translates to:
  /// **'Anomaly detected'**
  String get anomalyDetected;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None (local heuristic)'**
  String get none;

  /// No description provided for @securityNote.
  ///
  /// In en, this message translates to:
  /// **'Note: this tab displays application security signals based on available data (not a full server audit).'**
  String get securityNote;

  /// No description provided for @networkStatus.
  ///
  /// In en, this message translates to:
  /// **'Network Status'**
  String get networkStatus;

  /// No description provided for @mainChannel.
  ///
  /// In en, this message translates to:
  /// **'Main channel'**
  String get mainChannel;

  /// No description provided for @presence.
  ///
  /// In en, this message translates to:
  /// **'Presence'**
  String get presence;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @geolocSamples.
  ///
  /// In en, this message translates to:
  /// **'Geoloc samples'**
  String get geolocSamples;

  /// No description provided for @rawDebugData.
  ///
  /// In en, this message translates to:
  /// **'Raw debug data'**
  String get rawDebugData;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @sigmaAdProposalTitle.
  ///
  /// In en, this message translates to:
  /// **'🚀 Submit your Sigma Ad'**
  String get sigmaAdProposalTitle;

  /// No description provided for @submitAdSuccess.
  ///
  /// In en, this message translates to:
  /// **'✅ Submission sent! Wait for admin validation for your coins.'**
  String get submitAdSuccess;

  /// No description provided for @submitAdInfo.
  ///
  /// In en, this message translates to:
  /// **'Send an image and description to earn coins!'**
  String get submitAdInfo;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @bonusActivated.
  ///
  /// In en, this message translates to:
  /// **'Coin Bonus activated! (Video watched)'**
  String get bonusActivated;

  /// No description provided for @watchVideoBonus.
  ///
  /// In en, this message translates to:
  /// **'Watch a video for +50 bonus Coins'**
  String get watchVideoBonus;

  /// No description provided for @languageSelectorTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Language / Choisir la langue'**
  String get languageSelectorTitle;

  /// No description provided for @imageLinkUrl.
  ///
  /// In en, this message translates to:
  /// **'Image Link (URL)'**
  String get imageLinkUrl;

  /// No description provided for @bonusAddedText.
  ///
  /// In en, this message translates to:
  /// **'Coin Bonus activated! (Video watched)'**
  String get bonusAddedText;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Key copied: {text}'**
  String copiedToClipboard(String text);

  /// No description provided for @disconnectTooltip.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnectTooltip;

  /// No description provided for @connectTooltip.
  ///
  /// In en, this message translates to:
  /// **'Calculate & Connect'**
  String get connectTooltip;

  /// No description provided for @audioUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Vocal not available.'**
  String get audioUnavailable;

  /// No description provided for @supportSigmaPro.
  ///
  /// In en, this message translates to:
  /// **'Sigma Pro Support'**
  String get supportSigmaPro;

  /// No description provided for @p2pEncryptedChat.
  ///
  /// In en, this message translates to:
  /// **'Encrypted P2P Messaging'**
  String get p2pEncryptedChat;

  /// No description provided for @needHelpMessage.
  ///
  /// In en, this message translates to:
  /// **'Need help? Send us a message.'**
  String get needHelpMessage;

  /// No description provided for @chooseAdminRole.
  ///
  /// In en, this message translates to:
  /// **'Choose your Admin role'**
  String get chooseAdminRole;

  /// No description provided for @configRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Required Configuration'**
  String get configRequiredTitle;

  /// No description provided for @configRequiredInfo.
  ///
  /// In en, this message translates to:
  /// **'To work, Sigma needs: \n'**
  String get configRequiredInfo;

  /// No description provided for @configVisibleNote.
  ///
  /// In en, this message translates to:
  /// **'Without this, you will not be visible on the Sigma map.'**
  String get configVisibleNote;

  /// No description provided for @configureNow.
  ///
  /// In en, this message translates to:
  /// **'Configure Now'**
  String get configureNow;

  /// No description provided for @accessDenied.
  ///
  /// In en, this message translates to:
  /// **'Access denied.'**
  String get accessDenied;

  /// No description provided for @sigmaKey.
  ///
  /// In en, this message translates to:
  /// **'Sigma Key: {key}'**
  String sigmaKey(String key);

  /// No description provided for @wifiDisabled.
  ///
  /// In en, this message translates to:
  /// **'WiFi is disabled.'**
  String get wifiDisabled;

  /// No description provided for @locationWifiPermsRequired.
  ///
  /// In en, this message translates to:
  /// **'Location/WiFi permissions required.'**
  String get locationWifiPermsRequired;

  /// No description provided for @gpsRequiredAndroid.
  ///
  /// In en, this message translates to:
  /// **'GPS is required to scan on Android.'**
  String get gpsRequiredAndroid;

  /// No description provided for @noCompatibleNetworks.
  ///
  /// In en, this message translates to:
  /// **'No compatible network detected nearby.'**
  String get noCompatibleNetworks;

  /// No description provided for @scanError.
  ///
  /// In en, this message translates to:
  /// **'Scan error: {error}'**
  String scanError(String error);

  /// No description provided for @scanNotSupported.
  ///
  /// In en, this message translates to:
  /// **'WiFi scan is not supported on this device.'**
  String get scanNotSupported;

  /// No description provided for @gpsDisabled.
  ///
  /// In en, this message translates to:
  /// **'GPS is disabled.'**
  String get gpsDisabled;

  /// No description provided for @scanUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Scan is unavailable ({status}).'**
  String scanUnavailable(String status);

  /// No description provided for @manualKeyEntryNote.
  ///
  /// In en, this message translates to:
  /// **'Please enter the key manually if connection fails.'**
  String get manualKeyEntryNote;

  /// No description provided for @authRequired.
  ///
  /// In en, this message translates to:
  /// **'Authentication required'**
  String get authRequired;

  /// No description provided for @chooseRole.
  ///
  /// In en, this message translates to:
  /// **'Choose your role'**
  String get chooseRole;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @validate.
  ///
  /// In en, this message translates to:
  /// **'Validate'**
  String get validate;

  /// No description provided for @authTitle.
  ///
  /// In en, this message translates to:
  /// **'Authentication'**
  String get authTitle;

  /// No description provided for @commerceLogin.
  ///
  /// In en, this message translates to:
  /// **'Commerce Login'**
  String get commerceLogin;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @loginGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get loginGoogle;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'No account? Sign up'**
  String get noAccount;

  /// No description provided for @hasAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login'**
  String get hasAccount;

  /// No description provided for @resetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Reset email sent!'**
  String get resetEmailSent;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields.'**
  String get fillAllFields;

  /// No description provided for @googleError.
  ///
  /// In en, this message translates to:
  /// **'Google error: {error}'**
  String googleError(String error);

  /// No description provided for @permsRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Permissions Required'**
  String get permsRequiredTitle;

  /// No description provided for @permsRequiredInfo.
  ///
  /// In en, this message translates to:
  /// **'To use this app, you must:\n\n'**
  String get permsRequiredInfo;

  /// No description provided for @permsFatalNote.
  ///
  /// In en, this message translates to:
  /// **'Without this, the application cannot work.'**
  String get permsFatalNote;

  /// No description provided for @understandAndConfigure.
  ///
  /// In en, this message translates to:
  /// **'I understand, configure'**
  String get understandAndConfigure;

  /// No description provided for @commerceDisconnectConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to logout from commerce?'**
  String get commerceDisconnectConfirm;

  /// No description provided for @startDiscussion.
  ///
  /// In en, this message translates to:
  /// **'Start the discussion'**
  String get startDiscussion;

  /// No description provided for @yourMessage.
  ///
  /// In en, this message translates to:
  /// **'Your message...'**
  String get yourMessage;

  /// No description provided for @orderErrorUnidentified.
  ///
  /// In en, this message translates to:
  /// **'Unable to place order: unidentified user.'**
  String get orderErrorUnidentified;

  /// No description provided for @client.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get client;

  /// No description provided for @vendor.
  ///
  /// In en, this message translates to:
  /// **'Vendor'**
  String get vendor;

  /// No description provided for @deliveryPerson.
  ///
  /// In en, this message translates to:
  /// **'Delivery Person'**
  String get deliveryPerson;

  /// No description provided for @wholesaler.
  ///
  /// In en, this message translates to:
  /// **'Wholesaler'**
  String get wholesaler;

  /// No description provided for @vocalSigma.
  ///
  /// In en, this message translates to:
  /// **'Sigma Voice'**
  String get vocalSigma;

  /// No description provided for @defaultMessageContent.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get defaultMessageContent;

  /// No description provided for @myContacts.
  ///
  /// In en, this message translates to:
  /// **'My Contacts'**
  String get myContacts;

  /// No description provided for @myQrCodeTooltip.
  ///
  /// In en, this message translates to:
  /// **'My QR Code'**
  String get myQrCodeTooltip;

  /// No description provided for @scanFriendTooltip.
  ///
  /// In en, this message translates to:
  /// **'Scan a friend'**
  String get scanFriendTooltip;

  /// No description provided for @friendAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'✅ Friend added successfully!'**
  String get friendAddedSuccess;

  /// No description provided for @editPseudoMenu.
  ///
  /// In en, this message translates to:
  /// **'Edit my pseudo'**
  String get editPseudoMenu;

  /// No description provided for @myPseudoTitle.
  ///
  /// In en, this message translates to:
  /// **'My pseudo'**
  String get myPseudoTitle;

  /// No description provided for @enterPseudoHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your pseudo'**
  String get enterPseudoHint;

  /// No description provided for @noContacts.
  ///
  /// In en, this message translates to:
  /// **'No contacts'**
  String get noContacts;

  /// No description provided for @scanFriendToStart.
  ///
  /// In en, this message translates to:
  /// **'Scan a friend\'s QR Code to start'**
  String get scanFriendToStart;

  /// No description provided for @scanFriendButton.
  ///
  /// In en, this message translates to:
  /// **'Scan a friend'**
  String get scanFriendButton;

  /// No description provided for @addedOn.
  ///
  /// In en, this message translates to:
  /// **'Added on'**
  String get addedOn;

  /// No description provided for @scanQrCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan a QR Code'**
  String get scanQrCodeTitle;

  /// No description provided for @qrCodeUnreadable.
  ///
  /// In en, this message translates to:
  /// **'QR Code unreadable, try again.'**
  String get qrCodeUnreadable;

  /// No description provided for @invalidMistralQr.
  ///
  /// In en, this message translates to:
  /// **'This QR Code is not from Mistral P2P.'**
  String get invalidMistralQr;

  /// No description provided for @invalidLinkError.
  ///
  /// In en, this message translates to:
  /// **'Invalid link: {error}'**
  String invalidLinkError(String error);

  /// No description provided for @cannotAddSelf.
  ///
  /// In en, this message translates to:
  /// **'🚫 You cannot add yourself!'**
  String get cannotAddSelf;

  /// No description provided for @friendAlreadyAdded.
  ///
  /// In en, this message translates to:
  /// **'ℹ️ This friend is already in your contacts.'**
  String get friendAlreadyAdded;

  /// No description provided for @placeQrInFrame.
  ///
  /// In en, this message translates to:
  /// **'Place the QR Code in the frame'**
  String get placeQrInFrame;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @flashlightTooltip.
  ///
  /// In en, this message translates to:
  /// **'Flashlight'**
  String get flashlightTooltip;

  /// No description provided for @shareLinkTooltip.
  ///
  /// In en, this message translates to:
  /// **'Share link'**
  String get shareLinkTooltip;

  /// No description provided for @inviteText.
  ///
  /// In en, this message translates to:
  /// **'Add me on Mistral2laude P2P!\n{link}'**
  String inviteText(String link);

  /// No description provided for @inviteSubject.
  ///
  /// In en, this message translates to:
  /// **'Mistral2laude P2P Invitation'**
  String get inviteSubject;

  /// No description provided for @scanMeText.
  ///
  /// In en, this message translates to:
  /// **'Scan this QR Code\nto add me as a contact'**
  String get scanMeText;

  /// No description provided for @microphonePermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission denied'**
  String get microphonePermissionDenied;

  /// No description provided for @connectionNotEstablished.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Connection not established. Message saved locally.'**
  String get connectionNotEstablished;

  /// No description provided for @noMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages.\nSend the first one! 👋'**
  String get noMessagesYet;

  /// No description provided for @statusConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get statusConnected;

  /// No description provided for @statusConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get statusConnecting;

  /// No description provided for @statusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get statusFailed;

  /// No description provided for @statusOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get statusOffline;

  /// No description provided for @recordingHint.
  ///
  /// In en, this message translates to:
  /// **'🔴 Recording...'**
  String get recordingHint;

  /// No description provided for @messageHint.
  ///
  /// In en, this message translates to:
  /// **'Message...'**
  String get messageHint;

  /// No description provided for @connectingHint.
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get connectingHint;

  /// No description provided for @initFailed.
  ///
  /// In en, this message translates to:
  /// **'Initialization failed'**
  String get initFailed;

  /// No description provided for @defaultUserPseudo.
  ///
  /// In en, this message translates to:
  /// **'M2C User'**
  String get defaultUserPseudo;

  /// No description provided for @mobileDevice.
  ///
  /// In en, this message translates to:
  /// **'Mobile Device'**
  String get mobileDevice;

  /// No description provided for @unknownDevice.
  ///
  /// In en, this message translates to:
  /// **'Unknown Device'**
  String get unknownDevice;

  /// No description provided for @productsTab.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get productsTab;

  /// No description provided for @ordersTab.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get ordersTab;

  /// No description provided for @cartTab.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cartTab;

  /// No description provided for @clientModeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Client mode'**
  String get clientModeTooltip;

  /// No description provided for @adminModeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Admin mode'**
  String get adminModeTooltip;

  /// No description provided for @addProductTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add product'**
  String get addProductTooltip;

  /// No description provided for @orderCreated.
  ///
  /// In en, this message translates to:
  /// **'Order created.'**
  String get orderCreated;

  /// No description provided for @orderFailed.
  ///
  /// In en, this message translates to:
  /// **'Order failed.'**
  String get orderFailed;

  /// No description provided for @productCreated.
  ///
  /// In en, this message translates to:
  /// **'Product created.'**
  String get productCreated;

  /// No description provided for @productUpdated.
  ///
  /// In en, this message translates to:
  /// **'Product updated.'**
  String get productUpdated;

  /// No description provided for @productDeleted.
  ///
  /// In en, this message translates to:
  /// **'Product deleted.'**
  String get productDeleted;

  /// No description provided for @deleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Delete failed.'**
  String get deleteFailed;

  /// No description provided for @deleteProductTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete product'**
  String get deleteProductTitle;

  /// No description provided for @deleteProductConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String deleteProductConfirm(String name);

  /// No description provided for @imageUploaded.
  ///
  /// In en, this message translates to:
  /// **'Image uploaded.'**
  String get imageUploaded;

  /// No description provided for @imageUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Image upload failed: {error}'**
  String imageUploadFailed(String error);

  /// No description provided for @supabaseBucketNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Supabase image bucket is not configured.'**
  String get supabaseBucketNotConfigured;

  /// No description provided for @searchProductsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search products or SKU'**
  String get searchProductsPlaceholder;

  /// No description provided for @inStockFilter.
  ///
  /// In en, this message translates to:
  /// **'In stock'**
  String get inStockFilter;

  /// No description provided for @includeInactiveFilter.
  ///
  /// In en, this message translates to:
  /// **'Include inactive'**
  String get includeInactiveFilter;

  /// No description provided for @sortName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get sortName;

  /// No description provided for @sortPriceAsc.
  ///
  /// In en, this message translates to:
  /// **'Price low-high'**
  String get sortPriceAsc;

  /// No description provided for @sortPriceDesc.
  ///
  /// In en, this message translates to:
  /// **'Price high-low'**
  String get sortPriceDesc;

  /// No description provided for @sortStockAsc.
  ///
  /// In en, this message translates to:
  /// **'Stock low-high'**
  String get sortStockAsc;

  /// No description provided for @sortStockDesc.
  ///
  /// In en, this message translates to:
  /// **'Stock high-low'**
  String get sortStockDesc;

  /// No description provided for @sortPopularity.
  ///
  /// In en, this message translates to:
  /// **'Popularity'**
  String get sortPopularity;

  /// No description provided for @gridView.
  ///
  /// In en, this message translates to:
  /// **'Grid'**
  String get gridView;

  /// No description provided for @listView.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get listView;

  /// No description provided for @noProductsMatch.
  ///
  /// In en, this message translates to:
  /// **'No products match your filters.'**
  String get noProductsMatch;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No description provided for @allProductsLoaded.
  ///
  /// In en, this message translates to:
  /// **'All products loaded.'**
  String get allProductsLoaded;

  /// No description provided for @saveProductTitle.
  ///
  /// In en, this message translates to:
  /// **'Save Product'**
  String get saveProductTitle;

  /// No description provided for @addProductTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get addProductTitle;

  /// No description provided for @editProductTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get editProductTitle;

  /// No description provided for @productNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get productNameLabel;

  /// No description provided for @skuLabel.
  ///
  /// In en, this message translates to:
  /// **'SKU / Reference'**
  String get skuLabel;

  /// No description provided for @priceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price (DZD)'**
  String get priceLabel;

  /// No description provided for @promoPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Promo price (DZD)'**
  String get promoPriceLabel;

  /// No description provided for @optionalHelper.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optionalHelper;

  /// No description provided for @imageLabel.
  ///
  /// In en, this message translates to:
  /// **'Image URL or Storage path'**
  String get imageLabel;

  /// No description provided for @uploadImageButton.
  ///
  /// In en, this message translates to:
  /// **'Upload image'**
  String get uploadImageButton;

  /// No description provided for @replaceImageButton.
  ///
  /// In en, this message translates to:
  /// **'Replace image'**
  String get replaceImageButton;

  /// No description provided for @uploadingButton.
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get uploadingButton;

  /// No description provided for @stockLabel.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stockLabel;

  /// No description provided for @popularityLabel.
  ///
  /// In en, this message translates to:
  /// **'Popularity'**
  String get popularityLabel;

  /// No description provided for @activeLabel.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeLabel;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @savingButton.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get savingButton;

  /// No description provided for @unavailableStatus.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailableStatus;

  /// No description provided for @outOfStockStatus.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get outOfStockStatus;

  /// No description provided for @lowStockStatus.
  ///
  /// In en, this message translates to:
  /// **'Low stock'**
  String get lowStockStatus;

  /// No description provided for @inactiveStatus.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactiveStatus;

  /// No description provided for @promoStatus.
  ///
  /// In en, this message translates to:
  /// **'Promo'**
  String get promoStatus;

  /// No description provided for @cartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Cart is empty.'**
  String get cartEmpty;

  /// No description provided for @yourCart.
  ///
  /// In en, this message translates to:
  /// **'Your cart'**
  String get yourCart;

  /// No description provided for @clearCart.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearCart;

  /// No description provided for @subtotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotalLabel;

  /// No description provided for @deliveryLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get deliveryLabel;

  /// No description provided for @totalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneLabel;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressLabel;

  /// No description provided for @noteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get noteLabel;

  /// No description provided for @checkoutButton.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkoutButton;

  /// No description provided for @orderTotal.
  ///
  /// In en, this message translates to:
  /// **'Total {amount} DZD'**
  String orderTotal(String amount);

  /// No description provided for @itemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String itemsCount(int count);

  /// No description provided for @orderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order #{id}'**
  String orderNumber(String id);

  /// No description provided for @changeRoleTooltip.
  ///
  /// In en, this message translates to:
  /// **'Change role (Simulation)'**
  String get changeRoleTooltip;

  /// No description provided for @orderNotFound.
  ///
  /// In en, this message translates to:
  /// **'Order not found'**
  String get orderNotFound;

  /// No description provided for @globalStatus.
  ///
  /// In en, this message translates to:
  /// **'Global status'**
  String get globalStatus;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @customerLabel.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customerLabel;

  /// No description provided for @paymentLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get paymentLabel;

  /// No description provided for @productsLabel.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get productsLabel;

  /// No description provided for @priceXQuantity.
  ///
  /// In en, this message translates to:
  /// **'Price: {price} DZD x {quantity}'**
  String priceXQuantity(String price, int quantity);

  /// No description provided for @amountWithCurrency.
  ///
  /// In en, this message translates to:
  /// **'{amount} DZD'**
  String amountWithCurrency(String amount);

  /// No description provided for @shipmentItemLine.
  ///
  /// In en, this message translates to:
  /// **'• {name} (x{quantity})'**
  String shipmentItemLine(String name, int quantity);

  /// No description provided for @noShipmentsYet.
  ///
  /// In en, this message translates to:
  /// **'No shipments yet.'**
  String get noShipmentsYet;

  /// No description provided for @shipmentsCount.
  ///
  /// In en, this message translates to:
  /// **'Shipments ({count})'**
  String shipmentsCount(int count);

  /// No description provided for @packageNumber.
  ///
  /// In en, this message translates to:
  /// **'Package: {tracking}'**
  String packageNumber(String tracking);

  /// No description provided for @carrierLabel.
  ///
  /// In en, this message translates to:
  /// **'Carrier: {name}'**
  String carrierLabel(String name);

  /// No description provided for @packageId.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get packageId;

  /// No description provided for @shippedOn.
  ///
  /// In en, this message translates to:
  /// **'Shipped on'**
  String get shippedOn;

  /// No description provided for @itemsInPackage.
  ///
  /// In en, this message translates to:
  /// **'Items in this package:'**
  String get itemsInPackage;

  /// No description provided for @confirmOrderButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm order'**
  String get confirmOrderButton;

  /// No description provided for @allocateStockButton.
  ///
  /// In en, this message translates to:
  /// **'Allocate stock'**
  String get allocateStockButton;

  /// No description provided for @startPickingButton.
  ///
  /// In en, this message translates to:
  /// **'Start Picking'**
  String get startPickingButton;

  /// No description provided for @packingFinishedButton.
  ///
  /// In en, this message translates to:
  /// **'Packing finished (Packed)'**
  String get packingFinishedButton;

  /// No description provided for @shipButton.
  ///
  /// In en, this message translates to:
  /// **'Label & Ship'**
  String get shipButton;

  /// No description provided for @setInTransitButton.
  ///
  /// In en, this message translates to:
  /// **'Set In Transit ({tracking})'**
  String setInTransitButton(String tracking);

  /// No description provided for @confirmDeliveryButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delivery ({tracking})'**
  String confirmDeliveryButton(String tracking);

  /// No description provided for @requestReturnButton.
  ///
  /// In en, this message translates to:
  /// **'Request a return'**
  String get requestReturnButton;

  /// No description provided for @newShipmentTitle.
  ///
  /// In en, this message translates to:
  /// **'New Shipment'**
  String get newShipmentTitle;

  /// No description provided for @allItemIncludedNote.
  ///
  /// In en, this message translates to:
  /// **'All items will be included in this package for this example.'**
  String get allItemIncludedNote;

  /// No description provided for @trackingNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Tracking Number'**
  String get trackingNumberLabel;

  /// No description provided for @adminStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Administration : Status'**
  String get adminStatusTitle;

  /// No description provided for @phoneAddressRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone and address are required.'**
  String get phoneAddressRequired;

  /// No description provided for @orderFailedLong.
  ///
  /// In en, this message translates to:
  /// **'Order failed.'**
  String get orderFailedLong;

  /// No description provided for @orderCreatedLong.
  ///
  /// In en, this message translates to:
  /// **'Order created: {id}'**
  String orderCreatedLong(String id);

  /// No description provided for @placingOrderButton.
  ///
  /// In en, this message translates to:
  /// **'Placing order...'**
  String get placingOrderButton;

  /// No description provided for @placeOrderButton.
  ///
  /// In en, this message translates to:
  /// **'Place order'**
  String get placeOrderButton;

  /// No description provided for @loadMoreButton.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get loadMoreButton;

  /// No description provided for @searchOrderPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search an order...'**
  String get searchOrderPlaceholder;

  /// No description provided for @allFilter.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allFilter;

  /// No description provided for @orderConfirmedStep.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get orderConfirmedStep;

  /// No description provided for @shippedStep.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get shippedStep;

  /// No description provided for @deliveredStep.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get deliveredStep;

  /// No description provided for @unknownDate.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownDate;

  /// No description provided for @p2pMessengerTitle.
  ///
  /// In en, this message translates to:
  /// **'P2P Messenger'**
  String get p2pMessengerTitle;

  /// No description provided for @errorWithDetails.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorWithDetails(String message);

  /// No description provided for @myQrCode.
  ///
  /// In en, this message translates to:
  /// **'My QR Code'**
  String get myQrCode;

  /// No description provided for @shareQrCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Share your QR Code'**
  String get shareQrCodeTitle;

  /// No description provided for @shareQrCodeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let your friends scan this code to add you to their contacts.'**
  String get shareQrCodeSubtitle;

  /// No description provided for @takeScreenshotToShare.
  ///
  /// In en, this message translates to:
  /// **'Take a screenshot to share your QR Code.'**
  String get takeScreenshotToShare;

  /// No description provided for @initErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Initialization Error'**
  String get initErrorTitle;

  /// No description provided for @messagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messagesTitle;

  /// No description provided for @addContactTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add Contact'**
  String get addContactTooltip;

  /// No description provided for @noConversations.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get noConversations;

  /// No description provided for @addContactToStart.
  ///
  /// In en, this message translates to:
  /// **'Add a contact to start chatting'**
  String get addContactToStart;

  /// No description provided for @typingStatus.
  ///
  /// In en, this message translates to:
  /// **'typing...'**
  String get typingStatus;

  /// No description provided for @sayHello.
  ///
  /// In en, this message translates to:
  /// **'Say hello! 👋'**
  String get sayHello;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @addFriendTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Friend'**
  String get addFriendTitle;

  /// No description provided for @scanFriendQr.
  ///
  /// In en, this message translates to:
  /// **'Scan your friend\'s QR Code'**
  String get scanFriendQr;

  /// No description provided for @addContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Contact'**
  String get addContactTitle;

  /// No description provided for @yourQrCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Your QR Code'**
  String get yourQrCodeTitle;

  /// No description provided for @yourQrCodeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show this code to your friend'**
  String get yourQrCodeSubtitle;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailable;

  /// No description provided for @deviceIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Device ID'**
  String get deviceIdLabel;

  /// No description provided for @contactAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Contact added successfully!'**
  String get contactAddedSuccess;

  /// No description provided for @dataChannelDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Data channel disconnected'**
  String get dataChannelDisconnected;

  /// No description provided for @peerNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Peer not connected: {id}'**
  String peerNotConnected(String id);

  /// No description provided for @errorParsingMessage.
  ///
  /// In en, this message translates to:
  /// **'Error parsing message: {error}'**
  String errorParsingMessage(String error);

  /// No description provided for @invalidQrCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid QR Code: {error}'**
  String invalidQrCode(String error);

  /// No description provided for @missingDeviceId.
  ///
  /// In en, this message translates to:
  /// **'Missing Device ID'**
  String get missingDeviceId;

  /// No description provided for @missingPseudo.
  ///
  /// In en, this message translates to:
  /// **'Missing Pseudo'**
  String get missingPseudo;

  /// No description provided for @missingPublicKey.
  ///
  /// In en, this message translates to:
  /// **'Missing Public Key'**
  String get missingPublicKey;

  /// No description provided for @cannotAddSelfError.
  ///
  /// In en, this message translates to:
  /// **'Cannot add yourself'**
  String get cannotAddSelfError;

  /// No description provided for @invalidPublicKeyFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid public key format'**
  String get invalidPublicKeyFormat;

  /// No description provided for @errorParsingQrCode.
  ///
  /// In en, this message translates to:
  /// **'Error parsing QR Code: {error}'**
  String errorParsingQrCode(String error);

  /// No description provided for @mistral2laudeTitle.
  ///
  /// In en, this message translates to:
  /// **'Mistral2laude P2P'**
  String get mistral2laudeTitle;

  /// No description provided for @friendLabel.
  ///
  /// In en, this message translates to:
  /// **'Friend'**
  String get friendLabel;

  /// No description provided for @encryptedMessage.
  ///
  /// In en, this message translates to:
  /// **'[Encrypted message]'**
  String get encryptedMessage;

  /// No description provided for @youEncryptedMessage.
  ///
  /// In en, this message translates to:
  /// **'You: [Encrypted message]'**
  String get youEncryptedMessage;

  /// No description provided for @imageMessage.
  ///
  /// In en, this message translates to:
  /// **'🖼️ Image'**
  String get imageMessage;

  /// No description provided for @fileMessage.
  ///
  /// In en, this message translates to:
  /// **'📎 File'**
  String get fileMessage;

  /// No description provided for @newMessage.
  ///
  /// In en, this message translates to:
  /// **'New message'**
  String get newMessage;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @quickReply.
  ///
  /// In en, this message translates to:
  /// **'Quick reply'**
  String get quickReply;

  /// No description provided for @markAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark as read'**
  String get markAsRead;

  /// No description provided for @isTyping.
  ///
  /// In en, this message translates to:
  /// **'is typing...'**
  String get isTyping;

  /// No description provided for @typingIndicator.
  ///
  /// In en, this message translates to:
  /// **'Typing...'**
  String get typingIndicator;

  /// No description provided for @vocalMessage.
  ///
  /// In en, this message translates to:
  /// **'Vocal message'**
  String get vocalMessage;

  /// No description provided for @gps.
  ///
  /// In en, this message translates to:
  /// **'GPS'**
  String get gps;

  /// No description provided for @permissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get permissions;

  /// No description provided for @trace.
  ///
  /// In en, this message translates to:
  /// **'Trace'**
  String get trace;

  /// No description provided for @mainChannelValue.
  ///
  /// In en, this message translates to:
  /// **'WebRTC P2P'**
  String get mainChannelValue;

  /// No description provided for @formErrors.
  ///
  /// In en, this message translates to:
  /// **'Please fix the form errors.'**
  String get formErrors;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Save failed.'**
  String get saveFailed;

  /// No description provided for @itemsLabel.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get itemsLabel;

  /// No description provided for @productInfoSection.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get productInfoSection;

  /// No description provided for @productImageSection.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get productImageSection;

  /// No description provided for @productStockStatusSection.
  ///
  /// In en, this message translates to:
  /// **'Stock & status'**
  String get productStockStatusSection;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @priceRequired.
  ///
  /// In en, this message translates to:
  /// **'Price is required'**
  String get priceRequired;

  /// No description provided for @invalidPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid price'**
  String get invalidPrice;

  /// No description provided for @invalidPromoPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid promo price'**
  String get invalidPromoPrice;

  /// No description provided for @promoLowerThanPrice.
  ///
  /// In en, this message translates to:
  /// **'Promo must be lower than price'**
  String get promoLowerThanPrice;

  /// No description provided for @invalidStock.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid stock'**
  String get invalidStock;

  /// No description provided for @popularityHelper.
  ///
  /// In en, this message translates to:
  /// **'Higher means more popular'**
  String get popularityHelper;

  /// No description provided for @invalidPopularity.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid popularity'**
  String get invalidPopularity;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get addToCart;

  /// No description provided for @stockUnknown.
  ///
  /// In en, this message translates to:
  /// **'Stock unknown'**
  String get stockUnknown;

  /// No description provided for @startChatPrompt.
  ///
  /// In en, this message translates to:
  /// **'Start the conversation'**
  String get startChatPrompt;

  /// No description provided for @realtimeMessengerTitle.
  ///
  /// In en, this message translates to:
  /// **'Sigma Messenger (Realtime)'**
  String get realtimeMessengerTitle;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @warehouseRole.
  ///
  /// In en, this message translates to:
  /// **'Warehouse'**
  String get warehouseRole;

  /// No description provided for @carrierRole.
  ///
  /// In en, this message translates to:
  /// **'Carrier'**
  String get carrierRole;

  /// No description provided for @supportRole.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get supportRole;

  /// No description provided for @orderStatusCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get orderStatusCreated;

  /// No description provided for @orderStatusPendingPayment.
  ///
  /// In en, this message translates to:
  /// **'Pending payment'**
  String get orderStatusPendingPayment;

  /// No description provided for @orderStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get orderStatusPaid;

  /// No description provided for @orderStatusPaymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment failed'**
  String get orderStatusPaymentFailed;

  /// No description provided for @orderStatusCancelRequested.
  ///
  /// In en, this message translates to:
  /// **'Cancel requested'**
  String get orderStatusCancelRequested;

  /// No description provided for @orderStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get orderStatusCancelled;

  /// No description provided for @orderStatusOrderConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get orderStatusOrderConfirmed;

  /// No description provided for @orderStatusStockAllocated.
  ///
  /// In en, this message translates to:
  /// **'Stock allocated'**
  String get orderStatusStockAllocated;

  /// No description provided for @orderStatusBackorder.
  ///
  /// In en, this message translates to:
  /// **'Backorder'**
  String get orderStatusBackorder;

  /// No description provided for @orderStatusPicking.
  ///
  /// In en, this message translates to:
  /// **'Picking'**
  String get orderStatusPicking;

  /// No description provided for @orderStatusPacked.
  ///
  /// In en, this message translates to:
  /// **'Packed'**
  String get orderStatusPacked;

  /// No description provided for @orderStatusReadyToShip.
  ///
  /// In en, this message translates to:
  /// **'Ready to ship'**
  String get orderStatusReadyToShip;

  /// No description provided for @orderStatusPartiallyShipped.
  ///
  /// In en, this message translates to:
  /// **'Partially shipped'**
  String get orderStatusPartiallyShipped;

  /// No description provided for @orderStatusShipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get orderStatusShipped;

  /// No description provided for @orderStatusPartiallyDelivered.
  ///
  /// In en, this message translates to:
  /// **'Partially delivered'**
  String get orderStatusPartiallyDelivered;

  /// No description provided for @orderStatusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get orderStatusDelivered;

  /// No description provided for @orderStatusDeliveryFailed.
  ///
  /// In en, this message translates to:
  /// **'Delivery failed'**
  String get orderStatusDeliveryFailed;

  /// No description provided for @orderStatusException.
  ///
  /// In en, this message translates to:
  /// **'Exception'**
  String get orderStatusException;

  /// No description provided for @orderStatusReturnRequested.
  ///
  /// In en, this message translates to:
  /// **'Return requested'**
  String get orderStatusReturnRequested;

  /// No description provided for @orderStatusReturnInTransit.
  ///
  /// In en, this message translates to:
  /// **'Return in transit'**
  String get orderStatusReturnInTransit;

  /// No description provided for @orderStatusReturnReceived.
  ///
  /// In en, this message translates to:
  /// **'Return received'**
  String get orderStatusReturnReceived;

  /// No description provided for @orderStatusRefundPending.
  ///
  /// In en, this message translates to:
  /// **'Refund pending'**
  String get orderStatusRefundPending;

  /// No description provided for @orderStatusRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get orderStatusRefunded;

  /// No description provided for @orderStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get orderStatusClosed;

  /// No description provided for @shipmentStatusLabelCreated.
  ///
  /// In en, this message translates to:
  /// **'Label created'**
  String get shipmentStatusLabelCreated;

  /// No description provided for @shipmentStatusPickedUp.
  ///
  /// In en, this message translates to:
  /// **'Picked up'**
  String get shipmentStatusPickedUp;

  /// No description provided for @shipmentStatusInTransit.
  ///
  /// In en, this message translates to:
  /// **'In transit'**
  String get shipmentStatusInTransit;

  /// No description provided for @shipmentStatusArrivedAtHub.
  ///
  /// In en, this message translates to:
  /// **'Arrived at hub'**
  String get shipmentStatusArrivedAtHub;

  /// No description provided for @shipmentStatusCustomsClearance.
  ///
  /// In en, this message translates to:
  /// **'Customs clearance'**
  String get shipmentStatusCustomsClearance;

  /// No description provided for @shipmentStatusOutForDelivery.
  ///
  /// In en, this message translates to:
  /// **'Out for delivery'**
  String get shipmentStatusOutForDelivery;

  /// No description provided for @shipmentStatusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get shipmentStatusDelivered;

  /// No description provided for @shipmentStatusDeliveryFailed.
  ///
  /// In en, this message translates to:
  /// **'Delivery failed'**
  String get shipmentStatusDeliveryFailed;

  /// No description provided for @shipmentStatusException.
  ///
  /// In en, this message translates to:
  /// **'Exception'**
  String get shipmentStatusException;

  /// No description provided for @shipmentStatusLost.
  ///
  /// In en, this message translates to:
  /// **'Lost'**
  String get shipmentStatusLost;

  /// No description provided for @shipmentStatusDamaged.
  ///
  /// In en, this message translates to:
  /// **'Damaged'**
  String get shipmentStatusDamaged;

  /// No description provided for @shipmentStatusReturnToSender.
  ///
  /// In en, this message translates to:
  /// **'Return to sender'**
  String get shipmentStatusReturnToSender;

  /// No description provided for @returnStatusRequested.
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get returnStatusRequested;

  /// No description provided for @returnStatusAuthorized.
  ///
  /// In en, this message translates to:
  /// **'Authorized'**
  String get returnStatusAuthorized;

  /// No description provided for @returnStatusLabelIssued.
  ///
  /// In en, this message translates to:
  /// **'Label issued'**
  String get returnStatusLabelIssued;

  /// No description provided for @returnStatusInTransit.
  ///
  /// In en, this message translates to:
  /// **'In transit'**
  String get returnStatusInTransit;

  /// No description provided for @returnStatusReceived.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get returnStatusReceived;

  /// No description provided for @returnStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get returnStatusRejected;

  /// No description provided for @returnStatusRefundPending.
  ///
  /// In en, this message translates to:
  /// **'Refund pending'**
  String get returnStatusRefundPending;

  /// No description provided for @returnStatusRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get returnStatusRefunded;

  /// No description provided for @paymentStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get paymentStatusPending;

  /// No description provided for @paymentStatusAuthorized.
  ///
  /// In en, this message translates to:
  /// **'Authorized'**
  String get paymentStatusAuthorized;

  /// No description provided for @paymentStatusCaptured.
  ///
  /// In en, this message translates to:
  /// **'Captured'**
  String get paymentStatusCaptured;

  /// No description provided for @paymentStatusVoided.
  ///
  /// In en, this message translates to:
  /// **'Voided'**
  String get paymentStatusVoided;

  /// No description provided for @paymentStatusRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get paymentStatusRefunded;

  /// No description provided for @paymentStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get paymentStatusFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'id',
    'ja',
    'pt',
    'ru',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'id':
      return AppLocalizationsId();
    case 'ja':
      return AppLocalizationsJa();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
