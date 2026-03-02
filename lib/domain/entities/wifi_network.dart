class WiFiNetwork {
  final String ssid;
  final String calculatedKey;
  final int signalStrength;
  final String? frequency;
  final bool isSecure;
  final DateTime lastSeen;
  final DateTime? lastConnectionAttempt;
  final bool? lastConnectionSuccess;

  WiFiNetwork({
    required this.ssid,
    required this.calculatedKey,
    required this.signalStrength,
    this.frequency,
    this.isSecure = true,
    required this.lastSeen,
    this.lastConnectionAttempt,
    this.lastConnectionSuccess,
  });

  int get signalPercentage {
    if (signalStrength >= -30) return 100;
    if (signalStrength <= -100) return 0;
    return ((signalStrength + 100) * 10 / 7).round();
  }

  WiFiNetwork copyWith({
    String? ssid,
    String? calculatedKey,
    int? signalStrength,
    String? frequency,
    bool? isSecure,
    DateTime? lastSeen,
    DateTime? lastConnectionAttempt,
    bool? lastConnectionSuccess,
  }) {
    return WiFiNetwork(
      ssid: ssid ?? this.ssid,
      calculatedKey: calculatedKey ?? this.calculatedKey,
      signalStrength: signalStrength ?? this.signalStrength,
      frequency: frequency ?? this.frequency,
      isSecure: isSecure ?? this.isSecure,
      lastSeen: lastSeen ?? this.lastSeen,
      lastConnectionAttempt: lastConnectionAttempt ?? this.lastConnectionAttempt,
      lastConnectionSuccess: lastConnectionSuccess ?? this.lastConnectionSuccess,
    );
  }
}
