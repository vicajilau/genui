// ignore_for_file: prefer_initializing_formals

import 'dart:async';
import 'dart:convert';
import 'chat_service.dart';

/// A stub [ChatService] implementation representing WebSocket streaming
/// to a Dart Serverpod backend endpoint.
class ServerpodChatService implements ChatService {
  final String _serverUrl;

  ServerpodChatService({required String serverUrl}) : _serverUrl = serverUrl;

  @override
  Future<void> initialize() async {
    // Mock WebSocket connection handshake
  }

  @override
  Stream<String> sendMessage({
    required String prompt,
    required List<Map<String, dynamic>> history,
  }) async* {
    yield 'Connecting to Serverpod backend WebSocket...\n';
    yield '• Target Host: $_serverUrl\n';
    yield '• Channel ID: genui_realtime_chat\n\n';

    await Future.delayed(const Duration(milliseconds: 600));
    yield '✓ Connection established successfully.\n';
    yield '• Sending payload and streaming response...\n\n';

    await Future.delayed(const Duration(milliseconds: 800));
    yield 'Serverpod Agent:\n';
    yield 'Greetings from Serverpod! I have processed your request on the backend. Here is the response UI:\n\n';

    final serverUiPayload = {
      'version': 'v0.9',
      'updateComponents': {
        'surfaceId': 'composed_surface',
        'components': [
          {
            'id': 'root',
            'component': 'Column',
            'children': ['server_banner'],
          },
          {
            'id': 'server_banner',
            'component': 'AlertBannerWidget',
            'type': 'success',
            'message':
                'Server Mode Active (Stub) — Serverpod backend streaming completed successfully!',
          },
        ],
      },
    };

    await Future.delayed(const Duration(milliseconds: 300));
    yield '```json\n${const JsonEncoder.withIndent('  ').convert(serverUiPayload)}\n```';
  }

  @override
  void dispose() {
    // Close WebSocket streams
  }
}
