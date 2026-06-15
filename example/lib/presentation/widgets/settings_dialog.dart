import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/services/connection_settings_service.dart';
import '../../l10n/app_localizations.dart';
import '../../main.dart';
import 'centered_toast.dart';

/// A dialog widget that allows users to configure and persist chat connection
/// settings (Serverless Gemini API, Local Gemma execution, or Serverpod backend).
class SettingsDialog extends StatefulWidget {
  final ConnectionSettingsService settingsService;
  final Future<void> Function() onSave;
  final bool isChatVisible;

  const SettingsDialog({
    super.key,
    required this.settingsService,
    required this.onSave,
    required this.isChatVisible,
  });

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late ChatMode _activeChatMode;
  ChatMode? _expandedConfigMode;
  late AppPersona _appPersona;
  String? _selectedLocaleCode;
  late final TextEditingController _apiKeyController;
  late final TextEditingController _serverpodUrlController;
  late final TextEditingController _localModelController;
  late double _localTemperature;

  bool _isApiVisible = false;

  // Connection testing states (Serverless)
  bool _isTestingServerless = false;
  bool? _serverlessTestResult;
  String? _serverlessTestMessage;

  // Connection testing states (Local)
  bool _isTestingLocal = false;
  bool? _localTestResult;
  String? _localTestMessage;

  // Connection testing states (Serverpod)
  bool _isTestingServerpod = false;
  bool? _serverpodTestResult;
  String? _serverpodTestMessage;

  AppLocalizations get l10n => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    _activeChatMode = widget.settingsService.chatMode;
    _expandedConfigMode = _activeChatMode;
    _appPersona = widget.settingsService.appPersona;
    _selectedLocaleCode = widget.settingsService.localeCode;
    _apiKeyController = TextEditingController(
      text: widget.settingsService.apiKey,
    );
    _serverpodUrlController = TextEditingController(
      text: widget.settingsService.serverpodUrl,
    );
    _localModelController = TextEditingController(
      text: widget.settingsService.localModelPath,
    );
    _localTemperature = widget.settingsService.localTemperature;
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _serverpodUrlController.dispose();
    _localModelController.dispose();
    super.dispose();
  }

  Future<void> _openGeminiApiKeyUrl() async {
    final url = Uri.parse('https://aistudio.google.com/app/apikey');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _handlePaste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim() ?? '';
    if (text.isNotEmpty) {
      setState(() {
        _apiKeyController.text = text;
      });
    } else {
      if (mounted) {
        _showWarning(context, l10n.noTextInClipboard);
      }
    }
  }

  void _showFeedback(BuildContext context, String message, bool isSuccess) {
    if (widget.isChatVisible) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                isSuccess
                    ? Icons.check_circle_outline_rounded
                    : Icons.settings_backup_restore_rounded,
                color: isSuccess
                    ? const Color(0xFF34D399) // Emerald 400
                    : const Color(0xFFF87171), // Red 400
                size: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Color(0xFFF1F5F9), // Slate 100
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF1E293B), // Slate 800
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 90, left: 24, right: 24),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: const Color(0xFF6366F1).withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          duration: const Duration(seconds: 1),
        ),
      );
    } else {
      CenteredToast.show(context, message: message, isSuccess: isSuccess);
    }
  }

  void _showWarning(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.orangeAccent,
              size: 18,
            ),
            const SizedBox(width: 10),
            Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1E293B),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _testConnection(ChatMode mode) async {
    setState(() {
      switch (mode) {
        case ChatMode.serverless:
          _isTestingServerless = true;
          _serverlessTestResult = null;
          _serverlessTestMessage = null;
          break;
        case ChatMode.local:
          _isTestingLocal = true;
          _localTestResult = null;
          _localTestMessage = null;
          break;
        case ChatMode.serverpod:
          _isTestingServerpod = true;
          _serverpodTestResult = null;
          _serverpodTestMessage = null;
          break;
      }
    });

    await Future.delayed(const Duration(milliseconds: 1000));

    bool success = false;
    String message = '';

    switch (mode) {
      case ChatMode.serverless:
        final key = _apiKeyController.text.trim();
        if (key.isEmpty) {
          success = false;
          message = l10n.apiKeyCannotBeEmpty;
        } else if (!widget.settingsService.isValidApiKey(key)) {
          success = false;
          message = l10n.invalidApiKeyFormatMessage;
        } else {
          success = true;
          message = l10n.apiKeyFormatIsValid;
        }
        break;
      case ChatMode.local:
        final path = _localModelController.text.trim();
        if (path.isEmpty) {
          success = false;
          message = l10n.modelPathCannotBeEmpty;
        } else {
          success = true;
          message = l10n.modelPathIsValid;
        }
        break;
      case ChatMode.serverpod:
        final url = _serverpodUrlController.text.trim();
        if (url.isEmpty) {
          success = false;
          message = l10n.serverUrlCannotBeEmpty;
        } else {
          success = true;
          message = l10n.serverpodHostReachable;
        }
        break;
    }

    if (mounted) {
      setState(() {
        switch (mode) {
          case ChatMode.serverless:
            _isTestingServerless = false;
            _serverlessTestResult = success;
            _serverlessTestMessage = message;
            break;
          case ChatMode.local:
            _isTestingLocal = false;
            _localTestResult = success;
            _localTestMessage = message;
            break;
          case ChatMode.serverpod:
            _isTestingServerpod = false;
            _serverpodTestResult = success;
            _serverpodTestMessage = message;
            break;
        }
      });
    }
  }

  bool _isFormValid() {
    switch (_activeChatMode) {
      case ChatMode.serverless:
        final key = _apiKeyController.text.trim();
        return widget.settingsService.isValidApiKey(key);
      case ChatMode.local:
        return _localModelController.text.trim().isNotEmpty;
      case ChatMode.serverpod:
        return _serverpodUrlController.text.trim().isNotEmpty;
    }
  }

  @override
  Widget build(BuildContext context) {
    final key = _apiKeyController.text.trim();
    final isApiKeyValid =
        key.isEmpty || widget.settingsService.isValidApiKey(key);

    return AlertDialog(
      title: Text(l10n.settingsTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.activeChatModeLabel,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            // Segmented active execution mode selector
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF090D16),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  _buildActiveModeTab(
                    ChatMode.serverless,
                    'Serverless',
                    Icons.cloud_queue,
                  ),
                  _buildActiveModeTab(
                    ChatMode.local,
                    'Local',
                    Icons.phonelink_setup,
                  ),
                  _buildActiveModeTab(
                    ChatMode.serverpod,
                    'Serverpod',
                    Icons.dns,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.white10),
            const SizedBox(height: 12),
            Text(
              l10n.appPersonaLabel,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            // Segmented active app persona selector
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF090D16),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  _buildPersonaTab(
                    AppPersona.taskBoard,
                    l10n.taskBoardPersona,
                    Icons.assignment_turned_in_rounded,
                  ),
                  _buildPersonaTab(
                    AppPersona.customerPortal,
                    l10n.customerAppPersona,
                    Icons.account_balance_wallet_rounded,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.white10),
            const SizedBox(height: 12),
            Text(
              l10n.backendsSection,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            // Vertical collapsible accordion cards
            _buildAccordionCard(ChatMode.serverless, isApiKeyValid),
            _buildAccordionCard(ChatMode.local, isApiKeyValid),
            _buildAccordionCard(ChatMode.serverpod, isApiKeyValid),
            const SizedBox(height: 20),
            const Divider(color: Colors.white10),
            const SizedBox(height: 12),
            Text(
              l10n.selectAppLanguage,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            // Language selector dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF090D16),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String?>(
                  value: _selectedLocaleCode,
                  dropdownColor: const Color(0xFF0F172A),
                  isExpanded: true,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  items: [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text(l10n.systemLanguage),
                    ),
                    DropdownMenuItem<String?>(
                      value: 'en',
                      child: Text(l10n.englishLanguage),
                    ),
                    DropdownMenuItem<String?>(
                      value: 'es',
                      child: Text(l10n.spanishLanguage),
                    ),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _selectedLocaleCode = val;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _isFormValid()
              ? () async {
                  // Retrieve target locale synchronously before async operations
                  final currentLocale = Localizations.localeOf(context);
                  final targetLocale = _selectedLocaleCode == null
                      ? currentLocale
                      : Locale(_selectedLocaleCode!);
                  AppLocalizations targetL10n;
                  try {
                    targetL10n = lookupAppLocalizations(targetLocale);
                  } catch (_) {
                    targetL10n = l10n;
                  }

                  await widget.settingsService.setChatMode(_activeChatMode);
                  await widget.settingsService.setAppPersona(_appPersona);
                  await widget.settingsService.setLocaleCode(
                    _selectedLocaleCode,
                  );

                  // Update the global locale notifier reactively
                  appLocaleNotifier.value = _selectedLocaleCode == null
                      ? null
                      : Locale(_selectedLocaleCode!);

                  if (_activeChatMode == ChatMode.serverless ||
                      _apiKeyController.text.trim().isNotEmpty) {
                    if (_apiKeyController.text.trim().isEmpty) {
                      await widget.settingsService.deleteApiKey();
                    } else {
                      await widget.settingsService.setApiKey(
                        _apiKeyController.text,
                      );
                    }
                  }
                  await widget.settingsService.setServerpodUrl(
                    _serverpodUrlController.text,
                  );
                  await widget.settingsService.setLocalModelPath(
                    _localModelController.text,
                  );
                  await widget.settingsService.setLocalTemperature(
                    _localTemperature,
                  );

                  await widget.onSave();
                  if (context.mounted) {
                    Navigator.pop(context);
                    _showFeedback(
                      context,
                      targetL10n.settingsSavedSuccess,
                      true,
                    );
                  }
                }
              : null,
          child: Text(l10n.save),
        ),
      ],
    );
  }

  Widget _buildActiveModeTab(ChatMode mode, String label, IconData icon) {
    final isActive = _activeChatMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeChatMode = mode),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF1E293B) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isActive
                ? Border.all(color: const Color(0x336366F1))
                : Border.all(color: Colors.transparent),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 14,
                color: isActive ? const Color(0xFF818CF8) : Colors.white60,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? const Color(0xFF818CF8) : Colors.white60,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonaTab(AppPersona persona, String label, IconData icon) {
    final isActive = _appPersona == persona;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _appPersona = persona),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF1E293B) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isActive
                ? Border.all(color: const Color(0x336366F1))
                : Border.all(color: Colors.transparent),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 14,
                color: isActive ? const Color(0xFF818CF8) : Colors.white60,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? const Color(0xFF818CF8) : Colors.white60,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccordionCard(ChatMode mode, bool isApiKeyValid) {
    final isExpanded = _expandedConfigMode == mode;
    final isActive = _activeChatMode == mode;

    IconData modeIcon;
    String modeTitle;
    String modeSubtitle;
    Color themeColor;

    switch (mode) {
      case ChatMode.serverless:
        modeIcon = Icons.cloud_queue;
        modeTitle = l10n.serverlessGeminiLabel;
        modeSubtitle = l10n.serverlessGeminiSubtitle;
        themeColor = const Color(0xFF6366F1);
        break;
      case ChatMode.local:
        modeIcon = Icons.phonelink_setup;
        modeTitle = l10n.localGemmaLabel;
        modeSubtitle = l10n.localGemmaSubtitle;
        themeColor = const Color(0xFF10B981);
        break;
      case ChatMode.serverpod:
        modeIcon = Icons.dns;
        modeTitle = l10n.serverpodRemoteLabel;
        modeSubtitle = l10n.serverpodRemoteSubtitle;
        themeColor = const Color(0xFF3B82F6);
        break;
    }

    // Check configuration status of this specific mode
    bool isConfigured;
    switch (mode) {
      case ChatMode.serverless:
        final key = _apiKeyController.text.trim();
        isConfigured = widget.settingsService.isValidApiKey(key);
        break;
      case ChatMode.local:
        isConfigured = _localModelController.text.trim().isNotEmpty;
        break;
      case ChatMode.serverpod:
        isConfigured = _serverpodUrlController.text.trim().isNotEmpty;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpanded
              ? themeColor.withValues(alpha: 0.5)
              : Colors.white10,
          width: isExpanded ? 1.5 : 1.0,
        ),
        boxShadow: isExpanded
            ? [
                BoxShadow(
                  color: themeColor.withValues(alpha: 0.1),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header (Tappable)
          InkWell(
            onTap: () {
              setState(() {
                _expandedConfigMode = isExpanded ? null : mode;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 14.0,
              ),
              child: Row(
                children: [
                  Icon(modeIcon, color: themeColor, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            Text(
                              modeTitle,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            if (isActive)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: themeColor.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: themeColor.withValues(alpha: 0.4),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  l10n.activeBadgeLabel,
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: themeColor,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          modeSubtitle,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Configuration status indicator
                  Icon(
                    isConfigured
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: isConfigured
                        ? const Color(0xFF34D399)
                        : Colors.white24,
                    size: 16,
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: Colors.white30,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
          // Expanded Content Panel
          if (isExpanded)
            Container(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.white10)),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildPanelContent(mode, isApiKeyValid),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.white10, height: 1),
                  const SizedBox(height: 12),
                  _buildInlineTestPanel(mode),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPanelContent(ChatMode mode, bool isApiKeyValid) {
    switch (mode) {
      case ChatMode.serverless:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _apiKeyController,
              obscureText: !_isApiVisible,
              decoration: InputDecoration(
                labelText: l10n.geminiApiKeyLabel,
                hintText: 'AIzaSy...',
                errorText: !isApiKeyValid ? l10n.invalidApiKeyFormat : null,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isApiVisible ? Icons.visibility : Icons.visibility_off,
                    size: 20,
                  ),
                  onPressed: () =>
                      setState(() => _isApiVisible = !_isApiVisible),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 8,
              runSpacing: 4,
              children: [
                TextButton.icon(
                  onPressed: _handlePaste,
                  icon: const Icon(Icons.paste_rounded, size: 16),
                  label: Text(l10n.pasteKeyButton),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: const Color(0xFF6366F1),
                  ),
                ),
                TextButton.icon(
                  onPressed: _openGeminiApiKeyUrl,
                  icon: const Icon(Icons.open_in_new, size: 16),
                  label: Text(l10n.getApiKeyButton),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: Colors.teal,
                  ),
                ),
              ],
            ),
          ],
        );
      case ChatMode.local:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _localModelController,
              decoration: InputDecoration(
                labelText: l10n.modelFilePathLabel,
                hintText: 'gemma-2b-it.bin',
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.temperatureLabel,
                  style: const TextStyle(fontSize: 13, color: Colors.white70),
                ),
                Text(
                  _localTemperature.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF818CF8),
                  ),
                ),
              ],
            ),
            Slider(
              value: _localTemperature,
              min: 0.1,
              max: 1.0,
              divisions: 9,
              activeColor: const Color(0xFF6366F1),
              inactiveColor: Colors.white10,
              onChanged: (val) => setState(() => _localTemperature = val),
            ),
          ],
        );
      case ChatMode.serverpod:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _serverpodUrlController,
              decoration: InputDecoration(
                labelText: l10n.serverHostUrlLabel,
                hintText: 'http://localhost:8080',
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ],
        );
    }
  }

  Widget _buildInlineTestPanel(ChatMode mode) {
    bool isTesting;
    bool? testResult;
    String? testMessage;

    switch (mode) {
      case ChatMode.serverless:
        isTesting = _isTestingServerless;
        testResult = _serverlessTestResult;
        testMessage = _serverlessTestMessage;
        break;
      case ChatMode.local:
        isTesting = _isTestingLocal;
        testResult = _localTestResult;
        testMessage = _localTestMessage;
        break;
      case ChatMode.serverpod:
        isTesting = _isTestingServerpod;
        testResult = _serverpodTestResult;
        testMessage = _serverpodTestMessage;
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isTesting ? null : () => _testConnection(mode),
                icon: const Icon(Icons.bolt_rounded, size: 16),
                label: Text(l10n.testConnectionButton),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF818CF8),
                  side: const BorderSide(color: Color(0x336366F1)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (isTesting) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.testingConnectionProgress,
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
        ] else if (testResult != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: testResult
                  ? const Color(0x1F10B981)
                  : const Color(0x1FEF4444),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: testResult
                    ? const Color(0x3310B981)
                    : const Color(0x33EF4444),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  testResult
                      ? Icons.check_circle_outline_rounded
                      : Icons.error_outline_rounded,
                  color: testResult
                      ? const Color(0xFF34D399)
                      : const Color(0xFFF87171),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    testMessage ?? '',
                    style: TextStyle(
                      fontSize: 11,
                      color: testResult
                          ? const Color(0xFFE2E8F0)
                          : const Color(0xFFF87171),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
