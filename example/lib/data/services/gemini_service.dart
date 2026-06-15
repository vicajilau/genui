import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../interceptors/ai_logging_interceptor.dart';

/// A service that handles streaming API calls to the Gemini API (using dio and Server-Sent Events).
class GeminiService {
  late final Dio _dio;

  GeminiService() {
    _dio = Dio();
    _dio.interceptors.add(AiLoggingInterceptor());
  }

  /// Streams generative content from the Gemini API using Server-Sent Events (SSE).
  Stream<String> streamGenerateContent({
    required String apiKey,
    required String systemInstruction,
    required List<Map<String, dynamic>> history,
  }) async* {
    final requestBody = {
      'contents': history,
      'systemInstruction': {
        'parts': [
          {'text': systemInstruction},
        ],
      },
      'generationConfig': {'maxOutputTokens': 2048, 'temperature': 0.7},
      'safetySettings': [
        {'category': 'HARM_CATEGORY_HARASSMENT', 'threshold': 'BLOCK_NONE'},
        {'category': 'HARM_CATEGORY_HATE_SPEECH', 'threshold': 'BLOCK_NONE'},
        {
          'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
          'threshold': 'BLOCK_NONE',
        },
        {
          'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
          'threshold': 'BLOCK_NONE',
        },
      ],
    };

    try {
      final response = await _dio.post<ResponseBody>(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:streamGenerateContent?alt=sse',
        data: requestBody,
        options: Options(
          responseType: ResponseType.stream,
          headers: {
            'Content-Type': 'application/json',
            'x-goog-api-key': apiKey,
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Gemini API returned status code ${response.statusCode}',
        );
      }

      final stream = response.data!.stream
          .cast<List<int>>()
          .transform(utf8.decoder)
          .transform(const LineSplitter());

      await for (final line in stream) {
        if (line.startsWith('data: ')) {
          final dataJson = jsonDecode(line.substring(6));
          final candidates = dataJson['candidates'] as List?;
          if (candidates != null && candidates.isNotEmpty) {
            final candidate = candidates[0];
            final finishReason = candidate['finishReason'];
            if (finishReason != null && finishReason != 'STOP') {
              // ignore: avoid_print
              print(
                '⚠️ --- [GeminiService] Stream ended with finishReason: $finishReason ---',
              );
            }
            final part = candidate['content']?['parts']?[0];
            if (part != null && part['text'] != null) {
              yield part['text'] as String;
            }
          }
        }
      }
    } on DioException catch (e) {
      throw Exception('Dio network error: ${e.message}');
    }
  }
}
