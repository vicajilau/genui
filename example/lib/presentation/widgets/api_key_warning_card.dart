import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ApiKeyWarningCard extends StatelessWidget {
  final bool Function(String) onValidate;
  final Future<void> Function(String) onSave;

  const ApiKeyWarningCard({
    super.key,
    required this.onValidate,
    required this.onSave,
  });

  Future<void> _openGeminiApiKeyUrl() async {
    final url = Uri.parse('https://aistudio.google.com/app/apikey');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B), // Slate 800
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0x336366F1)), // Indigo border
            boxShadow: const [
              BoxShadow(
                color: Color(0x26000000),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF312E81), // Deep Indigo
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.vpn_key_rounded,
                    color: Color(0xFF818CF8), // Indigo 400
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Gemini API Key Required',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'To begin chatting with the model and rendering dynamic Generative UI surfaces in real-time, please configure a Gemini API key. Your key is stored securely using device-local encryption.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white60,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                obscureText: true,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  labelText: 'Enter Gemini API Key',
                  labelStyle: const TextStyle(color: Colors.white54),
                  hintText: 'AIzaSy...',
                  hintStyle: const TextStyle(color: Colors.white30),
                  prefixIcon: const Icon(
                    Icons.lock_outline_rounded,
                    color: Colors.white30,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: const Color(0xFF0F172A), // Slate 900
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF6366F1),
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0x336366F1)),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onSubmitted: (val) {
                  final trimmed = val.trim();
                  if (onValidate(trimmed)) {
                    onSave(trimmed);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Invalid Gemini API Key format.'),
                        backgroundColor: Colors.red.shade700,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: _openGeminiApiKeyUrl,
                    icon: const Icon(Icons.open_in_new_rounded, size: 16),
                    label: const Text(
                      'GET GEMINI API KEY',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF06B6D4), // Cyan
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
