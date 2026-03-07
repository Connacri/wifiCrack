import '../../domain/entities/wifi_network.dart';

class WiFiNetworkModel extends WiFiNetwork {
  WiFiNetworkModel({
    required super.ssid,
    required super.calculatedKey,
    required super.signalStrength,
    super.frequency,
    super.isSecure = true,
    required super.lastSeen,
    super.lastConnectionAttempt,
    super.lastConnectionSuccess,
  });

  Map<String, dynamic> toJson() {
    return {
      'ssid': ssid,
      'calculatedKey': calculatedKey,
      'signalStrength': signalStrength,
      'frequency': frequency,
      'isSecure': isSecure,
      'lastSeen': lastSeen.toIso8601String(),
      'lastConnectionAttempt': lastConnectionAttempt?.toIso8601String(),
      'lastConnectionSuccess': lastConnectionSuccess,
    };
  }

  factory WiFiNetworkModel.fromJson(Map<String, dynamic> json) {
    return WiFiNetworkModel(
      ssid: json['ssid'] as String,
      calculatedKey: json['calculatedKey'] as String,
      signalStrength: (json['signalStrength'] as num).toInt(),
      frequency: json['frequency'] as String?,
      isSecure: json['isSecure'] as bool? ?? true,
      lastSeen: DateTime.parse(json['lastSeen'] as String),
      lastConnectionAttempt: json['lastConnectionAttempt'] != null 
          ? DateTime.parse(json['lastConnectionAttempt'] as String) 
          : null,
      lastConnectionSuccess: json['lastConnectionSuccess'] as bool?,
    );
  }

  static WiFiNetworkModel fromEntity(WiFiNetwork entity) {
    return WiFiNetworkModel(
      ssid: entity.ssid,
      calculatedKey: entity.calculatedKey,
      signalStrength: entity.signalStrength,
      frequency: entity.frequency,
      isSecure: entity.isSecure,
      lastSeen: entity.lastSeen,
      lastConnectionAttempt: entity.lastConnectionAttempt,
      lastConnectionSuccess: entity.lastConnectionSuccess,
    );
  }
}

