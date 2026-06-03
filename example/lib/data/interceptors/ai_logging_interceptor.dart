import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// A custom Dio network interceptor that intercepts and logs outgoing AI requests,
/// streaming AI responses, and network exceptions in a readable visual format.
class AiLoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      final cleanUri = options.uri.toString().replaceAll(
        RegExp(r'key=[^&]+'),
        'key=REDACTED',
      );

      debugPrint('\n🚀 --- AI REQUEST ---');
      debugPrint('📍 URI:   $cleanUri');
      debugPrint('🛠️ METHOD: ${options.method}');

      if (options.data != null) {
        debugPrint('📦 DATA:');
        _printPrettyJson(options.data);
      }
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━\n');
    }
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('\n✨ --- AI RESPONSE ---');
      debugPrint('✅ STATUS: ${response.statusCode}');

      final data = response.data;
      if (data is ResponseBody) {
        debugPrint('📊 DATA: [Response Stream]');
        final originalStream = data.stream;
        final buffer = BytesBuilder();

        data.stream = originalStream.transform(
          StreamTransformer<Uint8List, Uint8List>.fromHandlers(
            handleData: (chunk, sink) {
              buffer.add(chunk);
              sink.add(chunk);
            },
            handleError: (error, stackTrace, sink) {
              sink.addError(error, stackTrace);
            },
            handleDone: (sink) {
              if (kDebugMode) {
                try {
                  final text = utf8.decode(buffer.takeBytes());
                  debugPrint('\n✨ --- AI RESPONSE STREAM COMPLETED ---');

                  final lines = text.split('\n');
                  final textBuffer = StringBuffer();
                  bool hasJsonData = false;

                  for (final line in lines) {
                    if (line.startsWith('data: ')) {
                      hasJsonData = true;
                      try {
                        final dataJson = jsonDecode(line.substring(6));
                        final candidates = dataJson['candidates'] as List?;
                        if (candidates != null && candidates.isNotEmpty) {
                          final part = candidates[0]['content']?['parts']?[0];
                          if (part != null && part['text'] != null) {
                            textBuffer.write(part['text'] as String);
                          }
                        }
                      } catch (_) {
                        // ignore malformed lines
                      }
                    }
                  }

                  if (hasJsonData) {
                    debugPrint('📝 TEXT OUTPUT:');
                    debugPrint(textBuffer.toString());
                  } else {
                    debugPrint('📝 RAW RESPONSE OUTPUT:');
                    debugPrint(text);
                  }
                  debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
                } catch (e) {
                  debugPrint('⚠️ Error decoding response stream log: $e');
                }
              }
              sink.close();
            },
          ),
        );
      } else if (data != null) {
        debugPrint('📊 DATA:');
        _printPrettyJson(data);
      }
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━\n');
    }
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('\n❌ --- AI ERROR ---');
      debugPrint('🚫 STATUS:  ${err.response?.statusCode}');
      debugPrint('⚠️ MESSAGE: ${err.message}');

      if (err.response?.data != null) {
        debugPrint('📄 ERROR DATA:');
        _printPrettyJson(err.response?.data);
      }
      debugPrint('━━━━━━━━━━━━━━━━━━━━\n');
    }
    return super.onError(err, handler);
  }

  void _printPrettyJson(dynamic data) {
    try {
      if (data is FormData) {
        debugPrint(
          '   [FormData with ${data.files.length} files and ${data.fields.length} fields]',
        );
        return;
      }

      if (data is List && data.isNotEmpty && data.first is num) {
        debugPrint('   [Byte Array Output of length ${data.length}]');
        return;
      }

      dynamic jsonObject = data;
      if (data is String) {
        try {
          jsonObject = jsonDecode(data);
        } catch (_) {
          // Keep as string if not valid JSON
        }
      }

      const encoder = JsonEncoder.withIndent('  ');
      String prettyString = encoder.convert(jsonObject);

      // Truncate large base64 payloads to keep logs readable
      prettyString = prettyString.replaceAllMapped(
        RegExp(r'"data":\s*"([^"]{50})([^"]+)"'),
        (match) => '"data": "${match.group(1)}... [TRUNCATED BASE64]"',
      );

      // Truncate large thought signatures from thinking models
      prettyString = prettyString.replaceAllMapped(
        RegExp(
          r'"(thoughtSignature|thought_signature)":\s*"([^"]{50})([^"]+)"',
        ),
        (match) =>
            '"${match.group(1)}": "${match.group(2)}... [TRUNCATED SIGNATURE]"',
      );

      final lines = prettyString.split('\n');
      const maxLines = 100;

      for (int i = 0; i < lines.length && i < maxLines; i++) {
        debugPrint('   ${lines[i]}');
      }

      if (lines.length > maxLines) {
        debugPrint('   ... (TRUNCATED ${lines.length - maxLines} LINES) ...');
      }
    } catch (e) {
      debugPrint('   ${data.toString()}');
    }
  }
}
