import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'centered_toast.dart';

/// A dialog widget that allows users to securely add, view, validate,
/// or delete their Gemini API key.
class SettingsDialog extends StatefulWidget {
  final String initialApiKey;
  final bool Function(String) onValidate;
  final Future<void> Function(String) onSave;
  final Future<void> Function() onDelete;
  final bool isChatVisible;

  const SettingsDialog({
    super.key,
    required this.initialApiKey,
    required this.onValidate,
    required this.onSave,
    required this.onDelete,
    required this.isChatVisible,
  });

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

/// The active state of [SettingsDialog] that manages visibility toggle,
/// clipboard integration, and custom notification systems.
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

  Future<void> _handlePaste(void Function(void Function()) setDialogState) async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim() ?? '';
    if (text.isNotEmpty) {
      setDialogState(() {
        _controller.text = text;
        _controller.selection = TextSelection.collapsed(
          offset: _controller.text.length,
        );
      });
    } else {
      if (mounted) {
        _showWarning(context, 'No text found in clipboard');
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
                    : Icons.delete_sweep_rounded,
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
          margin: const EdgeInsets.only(
            bottom: 90,
            left: 24,
            right: 24,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
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
      CenteredToast.show(
        context,
        message: message,
        isSuccess: isSuccess,
      );
    }
  }

  void _showWarning(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent, size: 18),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
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
                      size: 20,
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
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  TextButton.icon(
                    onPressed: () => _handlePaste(setDialogState),
                    icon: const Icon(Icons.paste_rounded, size: 16),
                    label: const Text('PASTE KEY'),
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      foregroundColor: const Color(0xFF6366F1), // Indigo
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _openGeminiApiKeyUrl,
                    icon: const Icon(Icons.open_in_new, size: 16),
                    label: const Text('GET GEMINI API KEY'),
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      foregroundColor: Colors.teal,
                    ),
                  ),
                ],
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
                        final message = key.isEmpty
                            ? 'API Key cleared successfully!'
                            : 'API Key saved successfully!';
                        Navigator.pop(context);
                        _showFeedback(context, message, key.isNotEmpty);
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
