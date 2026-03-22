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
  String confirmDeleteConversation(Object pseudo);

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
  String coinsForUser(Object pseudo);

  /// No description provided for @coinsAddedToUser.
  ///
  /// In en, this message translates to:
  /// **'{amount} coins added to {pseudo}'**
  String coinsAddedToUser(Object amount, Object pseudo);

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
  String p2pSecureSubtitle(Object id);

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
  String agoMin(Object minutes);

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
  String copiedToClipboard(Object text);

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
  String sigmaKey(Object key);

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
  String scanError(Object error);

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
  String scanUnavailable(Object status);

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
  String googleError(Object error);

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
