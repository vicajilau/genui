import 'dart:convert';
import 'package:crypto/crypto.dart';

/// A simple utility service for encrypting and decrypting sensitive data,
/// such as API keys, using device-keyed XOR obfuscation and Base64 encoding.
class EncryptionService {
  static const String _salt = 'GenUiPlaygroundSalt2026';

  /// Generates an encryption key based on a consistent device/app identifier.
  static String _generateKey() {
    const deviceId = 'genui_playground_device';
    var bytes = utf8.encode(deviceId + _salt);
    var digest = sha256.convert(bytes);
    return digest.toString().substring(0, 32);
  }

  /// Encrypts plain text using XOR with the generated key.
  static String encrypt(String plainText) {
    if (plainText.isEmpty) return '';

    final key = _generateKey();
    final keyBytes = utf8.encode(key);
    final textBytes = utf8.encode(plainText);

    final encrypted = <int>[];
    for (int i = 0; i < textBytes.length; i++) {
      encrypted.add(textBytes[i] ^ keyBytes[i % keyBytes.length]);
    }

    return base64.encode(encrypted);
  }

  /// Decrypts encrypted text using XOR with the generated key.
  static String decrypt(String encryptedText) {
    if (encryptedText.isEmpty) return '';

    try {
      final key = _generateKey();
      final keyBytes = utf8.encode(key);
      final encryptedBytes = base64.decode(encryptedText);

      final decrypted = <int>[];
      for (int i = 0; i < encryptedBytes.length; i++) {
        decrypted.add(encryptedBytes[i] ^ keyBytes[i % keyBytes.length]);
      }

      return utf8.decode(decrypted);
    } catch (e) {
      return '';
    }
  }

  /// Checks if the provided text is valid base64 (encrypted format).
  static bool isEncrypted(String text) {
    try {
      base64.decode(text);
      return true;
    } catch (e) {
      return false;
    }
  }
}
