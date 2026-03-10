class AddFriendLink {
  final String deviceId;
  final String? pseudo;

  AddFriendLink({required this.deviceId, this.pseudo});

  String toUrl() {
    return 'https://votre-app.com/add_friend?device_id=$deviceId&pseudo=${pseudo ?? ''}';
  }

  factory AddFriendLink.fromUrl(String url) {
    final uri = Uri.parse(url);
    return AddFriendLink(
      deviceId: uri.queryParameters['device_id']!,
      pseudo: uri.queryParameters['pseudo'],
    );
  }
}
