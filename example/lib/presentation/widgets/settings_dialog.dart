import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// A dialog widget that allows users to securely add, view, validate,
/// or delete their Gemini API key.
class SettingsDialog extends StatefulWidget {
  final String initialApiKey;
  final bool Function(String) onValidate;
  final Future<void> Function(String) onSave;
  final Future<void> Function() onDelete;

  const SettingsDialog({
    super.key,
    required this.initialApiKey,
    required this.onValidate,
    required this.onSave,
    required this.onDelete,
  });

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

/// The active state of [SettingsDialog] that manages visibility toggle
/// and text input lifecycle.
class _SettingsDialogState extends State<SettingsDialog> {
  late final TextEditingController _controller;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialApiKey);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openGeminiApiKeyUrl() async {
    final url = Uri.parse('https://aistudio.google.com/app/apikey');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setDialogState) {
        final key = _controller.text.trim();
        final isValid = widget.onValidate(key);

        return AlertDialog(
          title: const Text('Gemini API Settings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Configure your Gemini Developer API Key to enable the generative chat loop. The key will be stored securely using encryption.',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                obscureText: !_isVisible,
                decoration: InputDecoration(
                  labelText: 'Gemini API Key',
                  hintText: 'AIzaSy...',
                  errorText: key.isNotEmpty && !isValid
                      ? 'Invalid Gemini API Key format'
                      : null,
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setDialogState(() {
                        _isVisible = !_isVisible;
                      });
                    },
                  ),
                ),
                onChanged: (_) => setDialogState(() {}),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: _openGeminiApiKeyUrl,
                  icon: const Icon(Icons.open_in_new, size: 16),
                  label: const Text('GET GEMINI API KEY'),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: Colors.teal,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: key.isEmpty || isValid
                  ? () async {
                      if (key.isEmpty) {
                        await widget.onDelete();
                      } else {
                        await widget.onSave(key);
                      }
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              key.isEmpty
                                  ? 'API Key cleared successfully!'
                                  : 'API Key saved successfully!',
                            ),
                            backgroundColor: Colors.teal,
                          ),
                        );
                      }
                    }
                  : null,
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
