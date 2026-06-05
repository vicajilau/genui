import 'dart:async';

/// An abstract service class representing a Generative UI chat provider.
abstract class ChatService {
  /// Initializes connection configs or loads local model parameters.
  Future<void> initialize();

  /// Sends a user prompt to the provider alongside context history,
  /// yielding a real-time stream of streamed string responses (text & A2UI JSON).
  Stream<String> sendMessage({
    required String prompt,
    required List<Map<String, dynamic>> history,
  });

  /// Releases resources or closes active socket streams.
  void dispose();
}
