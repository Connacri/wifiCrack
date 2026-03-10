import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'contact.dart';
import 'conversation.dart';
import 'crypto_service.dart';
import 'database_service.dart';
import 'qrcode_service.dart';
import 'webrtc_service.dart';
import 'messaging_service.dart';
import 'signaling_service.dart';

/// Façade de messagerie pour les écrans [AddFriendScreen] et [MyQRCodeScreen].
///
/// Design : délègue aux mêmes singletons que [AppProvider] afin d'éviter
/// toute duplication d'état. Le QR code est pré-calculé à l'init pour
/// rendre [generateMyQRCode()] synchrone dans les builders Consumer.
///
/// Enregistrement dans main.dart (MultiProvider) :
/// ```dart
/// ChangeNotifierProxyProvider<AppProvider, MessagingProvider>(
///   create: (_) => MessagingProvider(),
///   update: (_, appProvider, previous) =>
///       (previous ?? MessagingProvider())..updateFromAppProvider(appProvider),
/// ),
/// ```
class MessagingProvider with ChangeNotifier {
  // ── Services singletons ────────────────────────────────────────────────────
  final CryptoService _crypto = CryptoService();
  final DatabaseService _database = DatabaseService();

  // ── Services injectés depuis AppProvider ────────────────────────────────────
  WebRTCService? _webrtc;
  MessagingService? _messaging;

  // ── État interne ────────────────────────────────────────────────────────────
  String? _deviceId;
  String? _pseudo;
  QRCodeService? _qrCodeService;

  /// QR code de l'utilisateur courant (mis en cache à l'initialisation).
  String _cachedQRCode = '';

  bool _isInitialized = false;
  bool _isLoading = false;
  String? _errorMessage;

  List<Contact> _contacts = [];
  List<Conversation> _conversations = [];

  // ── Getters publics ─────────────────────────────────────────────────────────
  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get deviceId => _deviceId;
  String? get pseudo => _pseudo;
  List<Contact> get contacts => List.unmodifiable(_contacts);
  List<Conversation> get conversations => List.unmodifiable(_conversations);

  // ── Initialisation autonome (sans AppProvider) ────────────────────────────

  /// À appeler une seule fois si [MessagingProvider] est utilisé en standalone
  /// (sans [ChangeNotifierProxyProvider]).
  Future<void> initialize() async {
    if (_isInitialized) return;
    _isLoading = true;
    notifyListeners();

    try {
      await _database.initialize();
      await _loadIdentity();
      await _buildQRCodeCache();
      await _refreshContacts();
      await _refreshConversations();

      _isInitialized = true;
      _errorMessage = null;
    } catch (e, st) {
      _errorMessage = e.toString();
      debugPrint('MessagingProvider.initialize error: $e\n$st');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Mise à jour depuis AppProvider (via ProxyProvider) ────────────────────

  /// Appelé automatiquement par [ChangeNotifierProxyProvider] à chaque rebuild
  /// de [AppProvider]. Synchronise l'état sans re-créer les services.
  Future<void> updateFromAppProvider(dynamic appProvider) async {
    // Accepte dynamic pour éviter une dépendance circulaire au niveau du fichier.
    // En pratique le type attendu est AppProvider.
    try {
      final id = appProvider.deviceId as String?;
      final ps = appProvider.pseudo as String?;
      final webrtc = appProvider.webrtc as WebRTCService?;
      final messaging = appProvider.messaging as MessagingService?;

      bool changed = false;

      if (id != null && id != _deviceId) {
        _deviceId = id;
        changed = true;
      }
      if (ps != null && ps != _pseudo) {
        _pseudo = ps;
        changed = true;
      }
      if (webrtc != null && webrtc != _webrtc) {
        _webrtc = webrtc;
        changed = true;
      }
      if (messaging != null && messaging != _messaging) {
        _messaging = messaging;
        changed = true;
      }

      if (changed && _deviceId != null && _pseudo != null) {
        _qrCodeService = QRCodeService(_crypto, _deviceId!, _pseudo!);
        await _buildQRCodeCache();
      }

      // Rafraîchir si AppProvider est initialisé
      final initialized = appProvider.isInitialized as bool? ?? false;
      if (initialized && !_isInitialized) {
        await _refreshContacts();
        await _refreshConversations();
        _isInitialized = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('MessagingProvider.updateFromAppProvider error: $e');
    }
  }

  // ── API publique ─────────────────────────────────────────────────────────

  /// Retourne le QR code encodé de l'utilisateur courant.
  ///
  /// Synchrone grâce au cache pré-chargé en init. Retourne une chaîne vide
  /// si l'initialisation n'est pas encore terminée.
  String generateMyQRCode() => _cachedQRCode;

  /// Ajoute un ami depuis les données brutes d'un QR code scanné.
  ///
  /// Lance une [Exception] en cas d'erreur (QR invalide, déjà ami, etc.)
  Future<void> addFriendFromQR(String rawQRData) async {
    _assertInitialized();

    final qrService = _qrCodeService!;

    // 1. Parser et valider le QR code
    final qrData = qrService.parseScannedQRCode(rawQRData);

    // 2. Vérifier si le contact existe déjà
    final existing = await _database.getContact(qrData.deviceId);
    if (existing != null) {
      throw Exception('Ce contact est déjà dans votre liste');
    }

    // 3. Persister le contact
    final contact = qrData.toContact();
    await _database.saveContact(contact);

    // 4. Tenter la connexion WebRTC si disponible
    if (_webrtc != null) {
      try {
        await _webrtc!.connectToPeer(contact.deviceId);
        _messaging?.listenToContact(contact.deviceId);
      } catch (e) {
        // Connexion différée : le contact sera connecté au prochain démarrage
        debugPrint('Connexion WebRTC différée pour ${contact.deviceId}: $e');
      }
    }

    // 5. Rafraîchir la liste locale
    await _refreshContacts();
    notifyListeners();
  }

  /// Supprime un contact et sa conversation associée.
  Future<void> removeContact(String contactDeviceId) async {
    _assertInitialized();

    await _webrtc?.disconnectPeer(contactDeviceId);
    await _database.deleteContact(contactDeviceId);
    await _refreshContacts();
    await _refreshConversations();
    notifyListeners();
  }

  /// Rafraîchit manuellement les conversations (utile après un push).
  Future<void> refreshConversations() async {
    await _refreshConversations();
    notifyListeners();
  }

  // ── Internals ─────────────────────────────────────────────────────────────

  Future<void> _loadIdentity() async {
    final prefs = await SharedPreferences.getInstance();
    _deviceId = prefs.getString('device_id');
    _pseudo = prefs.getString('pseudo');

    if (_deviceId == null || _pseudo == null) {
      throw StateError(
        'Identité introuvable. Assurez-vous que AppProvider.initialize() '
            'a été appelé avant MessagingProvider.',
      );
    }

    final publicKeyPem = prefs.getString('public_key');
    final privateKeyPem = prefs.getString('private_key');

    if (publicKeyPem != null && privateKeyPem != null) {
      _crypto.loadKeyPair(publicKeyPem, privateKeyPem);
    } else {
      // Cas rare : génération de secours (ne devrait pas arriver en prod)
      await _crypto.generateKeyPair();
      debugPrint('MessagingProvider: clés générées en secours');
    }

    _qrCodeService = QRCodeService(_crypto, _deviceId!, _pseudo!);
  }

  Future<void> _buildQRCodeCache() async {
    if (_qrCodeService == null) return;
    try {
      _cachedQRCode = await _qrCodeService!.generateMyQRCodeString();
    } catch (e) {
      _cachedQRCode = '';
      debugPrint('MessagingProvider: erreur génération QR code: $e');
    }
  }

  Future<void> _refreshContacts() async {
    _contacts = await _database.getAllContacts();
  }

  Future<void> _refreshConversations() async {
    _conversations = await _database.getAllConversations();
  }

  void _assertInitialized() {
    if (!_isInitialized) {
      throw StateError(
        'MessagingProvider n\'est pas initialisé. '
            'Appelez initialize() ou attendez updateFromAppProvider().',
      );
    }
  }

  @override
  void dispose() {
    // Les services sont des singletons gérés par AppProvider : pas de dispose ici.
    super.dispose();
  }
}