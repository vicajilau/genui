// ignore_for_file: prefer_initializing_formals

import 'dart:async';
import 'dart:convert';
import 'chat_service.dart';

/// A stub [ChatService] implementation representing local on-device inference
/// using Gemma weights.
class LocalGemmaChatService implements ChatService {
  final String _modelPath;
  final double _temperature;

  LocalGemmaChatService({
    required String modelPath,
    required double temperature,
  }) : _modelPath = modelPath,
       _temperature = temperature;

  @override
  Future<void> initialize() async {
    // No-op for the local stub initialization
  }

  @override
  Stream<String> sendMessage({
    required String prompt,
    required List<Map<String, dynamic>> history,
  }) async* {
    yield 'Initializing local Gemma inference pipeline...\n';
    yield '• Model weight path: $_modelPath\n';
    yield '• Inference temperature: $_temperature\n\n';

    await Future.delayed(const Duration(milliseconds: 600));
    yield '✓ Model loaded into GPU memory (mock).\n';
    yield '• Processing context tokens...\n\n';

    await Future.delayed(const Duration(milliseconds: 800));
    yield 'Gemma response:\n';
    yield 'I have processed your request locally. Here is an offline status alert rendered on your catalog surface:\n\n';

    final localUiPayload = {
      'version': 'v0.9',
      'updateComponents': {
        'surfaceId': 'composed_surface',
        'components': [
          {
            'id': 'root',
            'component': 'Column',
            'children': ['local_banner'],
          },
          {
            'id': 'local_banner',
            'component': 'AlertBannerWidget',
            'type': 'info',
            'message':
                'Local Mode Active (Stub) — Gemma 2B weights simulation completed successfully!',
          },
        ],
      },
    };

    await Future.delayed(const Duration(milliseconds: 300));
    yield '```json\n${const JsonEncoder.withIndent('  ').convert(localUiPayload)}\n```';
  }

  @override
  void dispose() {
    // Release resources
  }
}
