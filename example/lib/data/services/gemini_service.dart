import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../interceptors/ai_logging_interceptor.dart';

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
            final part = candidates[0]['content']?['parts']?[0];
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
