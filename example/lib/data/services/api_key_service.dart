import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/encryption_service.dart';

/// A service responsible for managing the secure persistence, retrieval,
/// and format validation of the Gemini API Key.
class ApiKeyService {
  static const String _geminiApiKeyKey = 'gemini_api_key';

  /// Loads the stored Gemini API key, decrypting it if present.
  Future<String?> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    final encryptedKey = prefs.getString(_geminiApiKeyKey);

    if (encryptedKey == null || encryptedKey.isEmpty) {
      return null;
    }

    return EncryptionService.decrypt(encryptedKey);
  }

  /// Encrypts and saves the Gemini API key.
  Future<void> saveApiKey(String apiKey) async {
    final trimmedKey = apiKey.trim();
    if (trimmedKey.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final encryptedKey = EncryptionService.encrypt(trimmedKey);
    await prefs.setString(_geminiApiKeyKey, encryptedKey);
  }

  /// Deletes the stored Gemini API key.
  Future<void> deleteApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_geminiApiKeyKey);
  }

  /// Validates if the string format matches a valid Gemini API key.
  bool isValidApiKey(String key) {
    if (key.trim().isEmpty) return false;
    final regex = RegExp(r'^(AIza[a-zA-Z0-9_-]{31,}|AQ\.[a-zA-Z0-9_-]{31,})$');
    return regex.hasMatch(key.trim());
  }
}
