/// Représente un lien d'ajout d'ami encodé dans un QR Code pour Mistral2laude
class AddFriendLink {
  final String deviceId;
  final String? pseudo;

  AddFriendLink({required this.deviceId, this.pseudo});

  /// Encode en URL pour le QR Code
  String toUrl() {
    final uri = Uri(
      scheme: 'https',
      host: 'mistral2laude-p2p.app',
      path: '/add',
      queryParameters: {
        'id': deviceId,
        if (pseudo != null && pseudo!.isNotEmpty) 'p': pseudo!,
      },
    );
    return uri.toString();
  }

  /// Decode depuis une URL scannée
  factory AddFriendLink.fromUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) throw const FormatException('URL malformée');

    final deviceId = uri.queryParameters['id'];
    if (deviceId == null || deviceId.isEmpty) {
      throw const FormatException('ID manquant dans le QR Code');
    }

    return AddFriendLink(
      deviceId: deviceId,
      pseudo: uri.queryParameters['p'],
    );
  }

  static bool isValidUrl(String url) {
    try {
      AddFriendLink.fromUrl(url);
      return true;
    } catch (_) {
      return false;
    }
  }
}
