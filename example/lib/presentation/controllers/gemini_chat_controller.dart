import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:genui/genui.dart';
import '../../data/models/chat_timeline_item.dart';
import '../../data/services/gemini_service.dart';
import '../../genui_registry.g.dart';

/// A controller managing the state and events of the Gemini AI chat,
/// including prompt sending, response streaming, A2UI action interception,
/// and surface controller linking.
class GeminiChatController extends ChangeNotifier {
  final GeminiService _geminiService;
  final String Function() _getApiKey;

  final List<ChatTimelineItem> _chatHistory = [];
  final List<Map<String, dynamic>> _geminiHistory = [];
  bool _isWaiting = false;
  bool _isFirstChunkOfResponse = true;
  bool _hasError = false;
  String? _lastErrorMessage;

  late SurfaceController _aiController;
  late A2uiTransportAdapter _aiTransport;
  late Conversation _aiConversation;
  StreamSubscription? _conversationEventSub;
  StreamSubscription? _incomingMessagesSub;
  int _surfaceCounter = 0;

  final StreamController<String> _errorController =
      StreamController<String>.broadcast();

  List<ChatTimelineItem> get chatHistory => _chatHistory;
  bool get isWaiting => _isWaiting;
  bool get hasError => _hasError;
  String? get lastErrorMessage => _lastErrorMessage;
  SurfaceController get aiController => _aiController;
  Stream<String> get errors => _errorController.stream;

  GeminiChatController({
    required this._geminiService,
    required this._getApiKey,
  }) {
    _aiController = SurfaceController(catalogs: [globalGenUICatalog]);
    _aiTransport = A2uiTransportAdapter(onSend: _onSendToGemini);
    final uniqueTransport = UniqueSurfaceTransport(
      _aiTransport,
      () => _surfaceCounter,
    );
    _aiConversation = Conversation(
      controller: _aiController,
      transport: uniqueTransport,
    );

    _setupConversationSub();
    _setupIncomingMessagesSub(uniqueTransport);
  }

  void _setupConversationSub() {
    _conversationEventSub = _aiConversation.events.listen((event) {
      if (event is ConversationSurfaceAdded) {
        _chatHistory.add(
          ChatTimelineItem(isUser: false, surfaceId: event.surfaceId),
        );
        notifyListeners();
      } else if (event is ConversationContentReceived) {
        if (_chatHistory.isNotEmpty &&
            !_chatHistory.last.isUser &&
            _chatHistory.last.surfaceId == null &&
            !_isFirstChunkOfResponse) {
          final lastText = _chatHistory.last.text ?? '';
          _chatHistory[_chatHistory.length - 1] = ChatTimelineItem(
            isUser: false,
            text: lastText + event.text,
          );
        } else {
          _chatHistory.add(ChatTimelineItem(isUser: false, text: event.text));
          _isFirstChunkOfResponse = false;
        }
        notifyListeners();
      } else if (event is ConversationWaiting) {
        _isWaiting = true;
        notifyListeners();
      } else if (event is ConversationError) {
        _isWaiting = false;
        _hasError = true;
        _lastErrorMessage = event.error.toString();
        _errorController.add(event.error.toString());
        notifyListeners();
      } else {
        _isWaiting = false;
        notifyListeners();
      }
    });
  }

  Future<void> sendUserPrompt(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    if (_hasError) {
      _hasError = false;
      _lastErrorMessage = null;
      // If the last item in gemini history was a user prompt that failed to get a response,
      // and the user is writing a new prompt instead of retrying, remove the failed one from history.
      if (_geminiHistory.isNotEmpty && _geminiHistory.last['role'] == 'user') {
        _geminiHistory.removeLast();
      }
    }

    _chatHistory.add(ChatTimelineItem(isUser: true, text: trimmed));
    notifyListeners();

    _aiConversation.sendRequest(ChatMessage.user(trimmed));
  }

  Future<void> _onSendToGemini(ChatMessage message) async {
    _surfaceCounter++;
    // Intercept and discard validation/runtime error reports to prevent infinite network request loops.
    for (final part in message.parts) {
      if (part.isUiInteractionPart) {
        final interaction = part.asUiInteractionPart!.interaction;
        if (interaction.contains('"error":')) {
          // Return early to discard this error message and prevent network loops
          return;
        }
      }
    }

    final apiKey = _getApiKey();
    if (apiKey.isEmpty) {
      throw StateError('Gemini API Key is not configured.');
    }

    final systemInstruction = _buildSystemInstruction();

    final promptParts = <Map<String, dynamic>>[];
    for (final part in message.parts) {
      if (part is TextPart) {
        promptParts.add({'text': part.text});
      } else if (part.isUiInteractionPart) {
        promptParts.add({'text': part.asUiInteractionPart!.interaction});
      } else {
        promptParts.add({'text': part.toString()});
      }
    }

    _geminiHistory.add({'role': 'user', 'parts': promptParts});

    _isFirstChunkOfResponse = true;
    _isWaiting = true;
    _hasError = false;
    _lastErrorMessage = null;
    notifyListeners();

    await _streamResponseFromGemini(apiKey, systemInstruction);
  }

  Future<void> _streamResponseFromGemini(
    String apiKey,
    String systemInstruction,
  ) async {
    try {
      final responseStream = _geminiService.streamGenerateContent(
        apiKey: apiKey,
        systemInstruction: systemInstruction,
        history: _geminiHistory,
      );

      final responseBuffer = StringBuffer();
      await for (final chunk in responseStream) {
        responseBuffer.write(chunk);
        _aiTransport.addChunk(chunk);
      }

      _geminiHistory.add({
        'role': 'model',
        'parts': [
          {'text': responseBuffer.toString()},
        ],
      });

      _hasError = false;
      _lastErrorMessage = null;
    } catch (e) {
      _hasError = true;
      _lastErrorMessage = e.toString();
      _errorController.add(e.toString());
      rethrow;
    } finally {
      _isWaiting = false;
      notifyListeners();
    }
  }

  Future<void> retry() async {
    if (!_hasError) return;

    final apiKey = _getApiKey();
    if (apiKey.isEmpty) {
      throw StateError('Gemini API Key is not configured.');
    }

    // Clean up last partial model message if any from chat history
    if (_chatHistory.isNotEmpty &&
        !_chatHistory.last.isUser &&
        _chatHistory.last.surfaceId == null) {
      _chatHistory.removeLast();
    }

    _isFirstChunkOfResponse = true;
    _isWaiting = true;
    _hasError = false;
    _lastErrorMessage = null;
    notifyListeners();

    final systemInstruction = _buildSystemInstruction();

    try {
      await _streamResponseFromGemini(apiKey, systemInstruction);
    } catch (e) {
      // Errors are already handled inside _streamResponseFromGemini
    }
  }

  String _buildSystemInstruction() {
    final capabilities = A2UiClientCapabilities.fromCatalogs([
      globalGenUICatalog,
    ]);
    final capabilitiesJson = jsonEncode(capabilities.toJson());

    final schemasDesc = StringBuffer();
    for (final item in globalGenUICatalog.items) {
      final schema = item.dataSchema.toJson();
      schemasDesc.writeln('- Component: "${item.name}"');
      schemasDesc.writeln('  Schema: ${jsonEncode(schema)}');
    }

    return '''
You are a GenUI assistant that helps users manage their task board and team.
You must interact with the user by generating dynamic user interfaces using the A2UI protocol.

### CRITICAL: RESPONSE FORMAT
You must respond with a mix of conversational text and A2UI JSON messages.
All A2UI JSON messages MUST be enclosed inside a markdown `json` code block:
```json
{
  "version": "v0.9",
  "updateComponents": {
    "surfaceId": "composed_surface",
    "components": [
      {
        "id": "root",
        "component": "Column",
        "children": ["red_button"]
      },
      {
        "id": "red_button",
        "component": "CustomButton",
        "label": "Click me!"
      }
    ]
  }
}
```

### CLIENT CAPABILITIES
You can only use components described in the following capabilities schema:
$capabilitiesJson

### AVAILABLE COMPONENTS AND SCHEMAS
Here is the detailed schema for each supported component. You must strictly use the properties, component names, and types defined here:
$schemasDesc

### PROTOCOL SPECIFICATION
1. Creating/Updating a surface:
   To render a UI, you must send an `updateComponents` message wrapped in a version "v0.9" envelope:
   - "version": "v0.9" (always use this version string)
   - "updateComponents": a map with the following keys:
     - "surfaceId": "composed_surface" (always use this ID)
     - "components": a JSON array (list) of component definitions.
   Every component definition must be a single JSON object with:
     - "id": a unique string ID.
     - "component": the name of the component.
     - Any component properties must be defined as sibling keys directly within the same object (do not nest under a "properties" key).

2. Component Relationships:
   - The root component must have ID "root" and component type "Column".
   - The root Column has a "children" property which is an array of IDs of the children to render (e.g. ["header_text", "user_card", "stats", ...]).

3. Handling Interaction Events:
   When the user interacts with a widget (e.g. toggling a task or pressing the sync button), you will receive a `UserActionEvent` inside the chat history as a JSON string under the "action" payload.
   For example:
   {"action": {"name": "TaskItemWidget_onToggleEvent", "context": {"task_id": "task_1_id", "title": "Design GenUI", "isCompleted": true, "priority": "high"}}}
   
   When you receive such an event, you MUST respond by updating the UI layout. If it was a checkbox toggle, you should update the target task's "isCompleted" property and adjust the completed count in the "StatsWidget". If it was the Sync Button, you can output a text message acknowledging the sync.

Always follow these rules strictly.
''';
  }

  void _setupIncomingMessagesSub(Transport transport) {
    _incomingMessagesSub?.cancel();
    _incomingMessagesSub = transport.incomingMessages.listen((message) {
      if (message is UpdateComponents) {
        if (!_aiController.registry.hasSurface(message.surfaceId)) {
          _aiController.handleMessage(
            CreateSurface(
              surfaceId: message.surfaceId,
              catalogId: 'inline_catalog',
            ),
          );
        }
      }
    });
  }

  void clearChat() {
    _chatHistory.clear();
    _geminiHistory.clear();
    _isWaiting = false;
    _isFirstChunkOfResponse = true;
    _hasError = false;
    _lastErrorMessage = null;
    _surfaceCounter = 0;

    _conversationEventSub?.cancel();
    _incomingMessagesSub?.cancel();
    _aiConversation.dispose();
    _aiTransport.dispose();
    _aiController.dispose();

    _aiController = SurfaceController(catalogs: [globalGenUICatalog]);
    _aiTransport = A2uiTransportAdapter(onSend: _onSendToGemini);
    final uniqueTransport = UniqueSurfaceTransport(
      _aiTransport,
      () => _surfaceCounter,
    );
    _aiConversation = Conversation(
      controller: _aiController,
      transport: uniqueTransport,
    );

    _setupConversationSub();
    _setupIncomingMessagesSub(uniqueTransport);
    notifyListeners();
  }

  @override
  void dispose() {
    _conversationEventSub?.cancel();
    _incomingMessagesSub?.cancel();
    _aiConversation.dispose();
    _aiTransport.dispose();
    _aiController.dispose();
    _errorController.close();
    super.dispose();
  }
}

class UniqueSurfaceTransport implements Transport {
  final Transport _delegate;
  final int Function() _getSurfaceCounter;

  UniqueSurfaceTransport(this._delegate, this._getSurfaceCounter);

  @override
  Stream<String> get incomingText => _delegate.incomingText;

  @override
  Stream<A2uiMessage> get incomingMessages {
    return _delegate.incomingMessages.map((message) {
      final suffix = '_${_getSurfaceCounter()}';

      switch (message) {
        case CreateSurface(
          :final surfaceId,
          :final catalogId,
          :final theme,
          :final sendDataModel,
        ):
          if (surfaceId == 'composed_surface') {
            return CreateSurface(
              surfaceId: '$surfaceId$suffix',
              catalogId: catalogId,
              theme: theme,
              sendDataModel: sendDataModel,
            );
          }
        case UpdateComponents(:final surfaceId, :final components):
          if (surfaceId == 'composed_surface') {
            return UpdateComponents(
              surfaceId: '$surfaceId$suffix',
              components: components,
            );
          }
        case UpdateDataModel(:final surfaceId, :final path, :final value):
          if (surfaceId == 'composed_surface') {
            return UpdateDataModel(
              surfaceId: '$surfaceId$suffix',
              path: path,
              value: value,
            );
          }
        case DeleteSurface(:final surfaceId):
          if (surfaceId == 'composed_surface') {
            return DeleteSurface(surfaceId: '$surfaceId$suffix');
          }
      }
      return message;
    });
  }

  @override
  Future<void> sendRequest(ChatMessage message) =>
      _delegate.sendRequest(message);

  @override
  void dispose() => _delegate.dispose();
}
