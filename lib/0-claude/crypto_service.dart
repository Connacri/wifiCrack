import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/asn1/asn1_parser.dart';
import 'package:pointycastle/asn1/primitives/asn1_integer.dart';
import 'package:pointycastle/asn1/primitives/asn1_sequence.dart';
import 'package:pointycastle/export.dart';
import 'package:cryptography/cryptography.dart' as crypto;
import 'dart:math';

/// Service de cryptographie hybride RSA-4096 + AES-256-GCM
/// - RSA pour l'échange de clés
/// - AES-GCM pour le chiffrement des messages (plus rapide)
class CryptoService {
  static final CryptoService _instance = CryptoService._internal();
  factory CryptoService() => _instance;
  CryptoService._internal();

  late AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> _keyPair;
  final _secureRandom = _getSecureRandom();

  /// Génère une nouvelle paire de clés RSA-4096
  Future<void> generateKeyPair() async {
    final keyGen = RSAKeyGenerator()
      ..init(
        ParametersWithRandom(
          RSAKeyGeneratorParameters(BigInt.from(65537), 4096, 64),
          _secureRandom,
        ),
      );

    // FIX: RSAKeyGenerator.generateKeyPair() retourne déjà
    //      AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> en pointycastle ≥ 3.
    //      Les casts explicites étaient inutiles et généraient des warnings.
    final pair = keyGen.generateKeyPair();
    _keyPair = AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(
      pair.publicKey,
      pair.privateKey,
    );
  }

  /// Charge une paire de clés depuis le stockage
  void loadKeyPair(String publicKeyPem, String privateKeyPem) {
    _keyPair = AsymmetricKeyPair(
      _parsePublicKey(publicKeyPem),
      _parsePrivateKey(privateKeyPem),
    );
  }

  /// Exporte la clé publique au format PEM
  String exportPublicKey() {
    final publicKey = _keyPair.publicKey;
    final modulus = publicKey.modulus!;
    final exponent = publicKey.exponent!;

    final topLevel = ASN1Sequence()
      ..add(ASN1Integer(modulus))
      ..add(ASN1Integer(exponent));

    final dataBase64 = base64.encode(topLevel.encode());
    return '''-----BEGIN RSA PUBLIC KEY-----
$dataBase64
-----END RSA PUBLIC KEY-----''';
  }

  /// Exporte la clé privée au format PEM
  String exportPrivateKey() {
    final privateKey = _keyPair.privateKey;
    final seq = ASN1Sequence()
      ..add(ASN1Integer(BigInt.zero))
      ..add(ASN1Integer(privateKey.modulus!))
      ..add(ASN1Integer(privateKey.exponent!))
      ..add(ASN1Integer(privateKey.privateExponent!))
      ..add(ASN1Integer(privateKey.p!))
      ..add(ASN1Integer(privateKey.q!))
      ..add(ASN1Integer(privateKey.privateExponent! % (privateKey.p! - BigInt.one)))
      ..add(ASN1Integer(privateKey.privateExponent! % (privateKey.q! - BigInt.one)))
      ..add(ASN1Integer(privateKey.q!.modInverse(privateKey.p!)));

    final dataBase64 = base64.encode(seq.encode());
    return '''-----BEGIN RSA PRIVATE KEY-----
$dataBase64
-----END RSA PRIVATE KEY-----''';
  }

  /// Chiffre un message avec AES-256-GCM et la clé AES est chiffrée avec RSA
  Future<Map<String, dynamic>> encryptMessage(
      String plaintext,
      String recipientPublicKeyPem,
      ) async {
    final aesKey = crypto.SecretKey(
      List<int>.generate(32, (_) => _secureRandom.nextUint8()),
    );

    final algorithm = crypto.AesGcm.with256bits();
    final nonce = List<int>.generate(12, (_) => _secureRandom.nextUint8());

    final secretBox = await algorithm.encrypt(
      utf8.encode(plaintext),
      secretKey: aesKey,
      nonce: nonce,
    );

    final recipientPublicKey = _parsePublicKey(recipientPublicKeyPem);
    final encryptor = OAEPEncoding(RSAEngine())
      ..init(true, PublicKeyParameter<RSAPublicKey>(recipientPublicKey));

    final encryptedAesKey = _processInBlocks(
      encryptor,
      Uint8List.fromList(await aesKey.extractBytes()),
    );

    return {
      'ciphertext': base64.encode(secretBox.cipherText),
      'nonce': base64.encode(nonce),
      'mac': base64.encode(secretBox.mac.bytes),
      'encryptedKey': base64.encode(encryptedAesKey),
    };
  }

  /// Déchiffre un message
  Future<String> decryptMessage(Map<String, dynamic> encryptedData) async {
    try {
      final decryptor = OAEPEncoding(RSAEngine())
        ..init(false, PrivateKeyParameter<RSAPrivateKey>(_keyPair.privateKey));

      final encryptedAesKeyBytes =
      base64.decode(encryptedData['encryptedKey'] as String);
      final aesKeyBytes = _processInBlocks(decryptor, encryptedAesKeyBytes);
      final aesKey = crypto.SecretKey(aesKeyBytes);

      final algorithm = crypto.AesGcm.with256bits();
      final nonce = base64.decode(encryptedData['nonce'] as String);
      final ciphertext = base64.decode(encryptedData['ciphertext'] as String);
      final mac =
      crypto.Mac(base64.decode(encryptedData['mac'] as String));

      final secretBox = crypto.SecretBox(ciphertext, nonce: nonce, mac: mac);
      final plaintext = await algorithm.decrypt(secretBox, secretKey: aesKey);

      return utf8.decode(plaintext);
    } catch (e) {
      throw Exception('Échec du déchiffrement: $e');
    }
  }

  // === Méthodes utilitaires ===

  static SecureRandom _getSecureRandom() {
    final secureRandom = FortunaRandom();
    final random = Random.secure();
    final seeds = List<int>.generate(32, (_) => random.nextInt(256));
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));
    return secureRandom;
  }

  RSAPublicKey _parsePublicKey(String pem) {
    final rows = pem
        .split('\n')
        .where((row) => !row.contains('BEGIN') && !row.contains('END'))
        .join('');
    final keyBytes = base64.decode(rows);
    final asn1Parser = ASN1Parser(keyBytes);
    final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;

    // FIX: pointycastle ≥ 3 — la propriété est `integer` (BigInt?) et non
    //      `valueAsBigInteger`. Les `elements` de ASN1Sequence sont nullable
    //      → opérateur `!` requis pour l'accès indexé.
    final elements = topLevelSeq.elements!;
    final modulus = (elements[0] as ASN1Integer).integer!;
    final exponent = (elements[1] as ASN1Integer).integer!;

    return RSAPublicKey(modulus, exponent);
  }

  RSAPrivateKey _parsePrivateKey(String pem) {
    final rows = pem
        .split('\n')
        .where((row) => !row.contains('BEGIN') && !row.contains('END'))
        .join('');
    final keyBytes = base64.decode(rows);
    final asn1Parser = ASN1Parser(keyBytes);
    final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;

    // FIX: même correction que _parsePublicKey — `integer!` + `elements!`
    final elements = topLevelSeq.elements!;
    final modulus = (elements[1] as ASN1Integer).integer!;
    // elements[2] = publicExponent (non utilisé dans RSAPrivateKey ici)
    final privateExponent = (elements[3] as ASN1Integer).integer!;
    final p = (elements[4] as ASN1Integer).integer!;
    final q = (elements[5] as ASN1Integer).integer!;

    return RSAPrivateKey(modulus, privateExponent, p, q);
  }

  Uint8List _processInBlocks(AsymmetricBlockCipher engine, Uint8List input) {
    final numBlocks = input.length ~/ engine.inputBlockSize +
        ((input.length % engine.inputBlockSize != 0) ? 1 : 0);

    final output = Uint8List(numBlocks * engine.outputBlockSize);

    var inputOffset = 0;
    var outputOffset = 0;
    while (inputOffset < input.length) {
      final chunkSize =
      (inputOffset + engine.inputBlockSize <= input.length)
          ? engine.inputBlockSize
          : input.length - inputOffset;

      outputOffset += engine.processBlock(
        input,
        inputOffset,
        chunkSize,
        output,
        outputOffset,
      );

      inputOffset += chunkSize;
    }

    return output.sublist(0, outputOffset);
  }
}