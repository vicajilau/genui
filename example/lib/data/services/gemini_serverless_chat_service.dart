// ignore_for_file: prefer_initializing_formals

import 'dart:async';
import 'chat_service.dart';
import 'gemini_service.dart';

/// A [ChatService] implementation that connects directly to the Google Gemini API
/// using client-side HTTP Server-Sent Events (SSE).
class GeminiServerlessChatService implements ChatService {
  final GeminiService _geminiService;
  final String Function() _getApiKey;
  final String _systemInstruction;

  GeminiServerlessChatService({
    required GeminiService geminiService,
    required String Function() getApiKey,
    required String systemInstruction,
  }) : _geminiService = geminiService,
       _getApiKey = getApiKey,
       _systemInstruction = systemInstruction;

  @override
  Future<void> initialize() async {
    // No initialization steps needed for direct HTTP API calls
  }

  @override
  Stream<String> sendMessage({
    required String prompt,
    required List<Map<String, dynamic>> history,
  }) {
    final apiKey = _getApiKey();
    if (apiKey.isEmpty) {
      return Stream.error(StateError('Gemini API Key is not configured.'));
    }

    // Append the new prompt to the history list for the Gemini API request payload
    final fullHistory = [
      ...history,
      {
        'role': 'user',
        'parts': [
          {'text': prompt},
        ],
      },
    ];

    return _geminiService.streamGenerateContent(
      apiKey: apiKey,
      systemInstruction: _systemInstruction,
      history: fullHistory,
    );
  }

  @override
  void dispose() {
    // No resources to release
  }
}
