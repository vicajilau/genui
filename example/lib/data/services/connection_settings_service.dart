import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/encryption_service.dart';

/// Available connection modes for the GenUI Playground.
enum ChatMode { serverless, local, serverpod }

/// Available application personas for the GenUI Playground.
enum AppPersona { taskBoard, customerPortal }

/// A service responsible for persisting and retrieving user configurations
/// (chat mode, server URLs, model paths, and securely encrypted API keys).
class ConnectionSettingsService {
  static const String _keyChatMode = 'genui_chat_mode';
  static const String _geminiApiKeyKey = 'gemini_api_key';
  static const String _keyServerpodUrl = 'genui_serverpod_url';
  static const String _keyLocalModelPath = 'genui_local_model_path';
  static const String _keyLocalTemperature = 'genui_local_temp';
  static const String _keyAppPersona = 'genui_app_persona';

  final SharedPreferences _prefs;

  ConnectionSettingsService(this._prefs);

  /// Retrieves the active chat execution mode. Defaults to [ChatMode.serverless].
  ChatMode get chatMode {
    final modeStr = _prefs.getString(_keyChatMode) ?? 'serverless';
    return ChatMode.values.firstWhere(
      (m) => m.name == modeStr,
      orElse: () => ChatMode.serverless,
    );
  }

  /// Sets the active chat execution mode.
  Future<void> setChatMode(ChatMode mode) async {
    await _prefs.setString(_keyChatMode, mode.name);
  }

  /// Retrieves the active app persona. Defaults to [AppPersona.taskBoard].
  AppPersona get appPersona {
    final personaStr = _prefs.getString(_keyAppPersona) ?? 'taskBoard';
    return AppPersona.values.firstWhere(
      (p) => p.name == personaStr,
      orElse: () => AppPersona.taskBoard,
    );
  }

  /// Sets the active app persona.
  Future<void> setAppPersona(AppPersona persona) async {
    await _prefs.setString(_keyAppPersona, persona.name);
  }

  /// Decrypts and retrieves the stored Gemini API key, or returns an empty string.
  String get apiKey {
    final encryptedKey = _prefs.getString(_geminiApiKeyKey);
    if (encryptedKey == null || encryptedKey.isEmpty) {
      return '';
    }
    try {
      return EncryptionService.decrypt(encryptedKey);
    } catch (_) {
      return '';
    }
  }

  /// Encrypts and saves the Gemini API key.
  Future<void> setApiKey(String key) async {
    final trimmedKey = key.trim();
    if (trimmedKey.isEmpty) return;
    final encryptedKey = EncryptionService.encrypt(trimmedKey);
    await _prefs.setString(_geminiApiKeyKey, encryptedKey);
  }

  /// Deletes the securely stored API key from preferences.
  Future<void> deleteApiKey() async {
    await _prefs.remove(_geminiApiKeyKey);
  }

  /// Retrieves the Serverpod endpoint URL. Defaults to 'http://localhost:8080'.
  String get serverpodUrl =>
      _prefs.getString(_keyServerpodUrl) ?? 'http://localhost:8080';

  /// Sets the Serverpod endpoint URL.
  Future<void> setServerpodUrl(String url) async {
    await _prefs.setString(_keyServerpodUrl, url);
  }

  /// Retrieves the local model file path. Defaults to 'gemma-2b-it.bin'.
  String get localModelPath =>
      _prefs.getString(_keyLocalModelPath) ?? 'gemma-2b-it.bin';

  /// Sets the local model file path.
  Future<void> setLocalModelPath(String path) async {
    await _prefs.setString(_keyLocalModelPath, path);
  }

  /// Retrieves the temperature parameter for local inference. Defaults to 0.7.
  double get localTemperature => _prefs.getDouble(_keyLocalTemperature) ?? 0.7;

  /// Sets the temperature parameter for local inference.
  Future<void> setLocalTemperature(double temp) async {
    await _prefs.setDouble(_keyLocalTemperature, temp);
  }

  /// Validates if the string format matches a valid Gemini API key.
  bool isValidApiKey(String key) {
    if (key.trim().isEmpty) return false;
    final regex = RegExp(r'^(AIza[a-zA-Z0-9_-]{31,}|AQ\.[a-zA-Z0-9_-]{31,})$');
    return regex.hasMatch(key.trim());
  }

  /// Checks if a mode has been explicitly configured/saved by the user.
  bool isModeConfigured(ChatMode mode) {
    switch (mode) {
      case ChatMode.serverless:
        return _prefs.containsKey(_geminiApiKeyKey) &&
            apiKey.isNotEmpty &&
            isValidApiKey(apiKey);
      case ChatMode.local:
        return _prefs.containsKey(_keyLocalModelPath) &&
            localModelPath.trim().isNotEmpty;
      case ChatMode.serverpod:
        return _prefs.containsKey(_keyServerpodUrl) &&
            serverpodUrl.trim().isNotEmpty;
    }
  }

  /// Whether at least one execution mode has been configured.
  bool get hasAnyValidConfig {
    return isModeConfigured(ChatMode.serverless) ||
        isModeConfigured(ChatMode.local) ||
        isModeConfigured(ChatMode.serverpod);
  }

  /// List of modes that have been validly configured.
  List<ChatMode> get configuredModes {
    return ChatMode.values.where((m) => isModeConfigured(m)).toList();
  }

  /// The active execution mode, falling back to the first configured mode if the selected one is invalid.
  ChatMode get activeChatMode {
    final mode = chatMode;
    if (isModeConfigured(mode)) {
      return mode;
    }
    final configured = configuredModes;
    if (configured.isNotEmpty) {
      return configured.first;
    }
    return mode;
  }
}
