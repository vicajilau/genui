// ignore_for_file: prefer_initializing_formals

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:genui/genui.dart';
import '../../data/models/chat_timeline_item.dart';
import '../../data/services/chat_service.dart';
import '../../data/services/connection_settings_service.dart';
import '../../data/services/gemini_serverless_chat_service.dart';
import '../../data/services/gemini_service.dart';
import '../../data/services/local_gemma_chat_service.dart';
import '../../data/services/serverpod_chat_service.dart';
import '../../genui_registry.g.dart';
import 'chat_localization.dart';

/// A controller managing the state and events of the Gemini AI chat,
/// including prompt sending, response streaming, A2UI action interception,
/// and surface controller linking.
class GeminiChatController extends ChangeNotifier {
  final ConnectionSettingsService _settingsService;
  final GeminiService _geminiService;
  late ChatService _chatService;
  String? _lastPrompt;

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
    required ConnectionSettingsService settingsService,
    required GeminiService geminiService,
  }) : _settingsService = settingsService,
       _geminiService = geminiService {
    _initChatService();
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
    _seedInitialMessage();
  }

  void _initChatService() {
    final mode = _settingsService.activeChatMode;
    switch (mode) {
      case ChatMode.serverless:
        _chatService = GeminiServerlessChatService(
          geminiService: _geminiService,
          getApiKey: () => _settingsService.apiKey,
          systemInstruction: _buildSystemInstruction(),
        );
        break;
      case ChatMode.local:
        _chatService = LocalGemmaChatService(
          modelPath: _settingsService.localModelPath,
          temperature: _settingsService.localTemperature,
        );
        break;
      case ChatMode.serverpod:
        _chatService = ServerpodChatService(
          serverUrl: _settingsService.serverpodUrl,
        );
        break;
    }
    // Asynchronous initialization
    _chatService.initialize();
  }

  void reloadSettings() {
    _chatService.dispose();
    _initChatService();
    notifyListeners();
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
    final promptText = promptParts.map((p) => p['text'] as String).join('\n');
    _lastPrompt = promptText;

    _isFirstChunkOfResponse = true;
    _isWaiting = true;
    _hasError = false;
    _lastErrorMessage = null;
    notifyListeners();

    await _streamResponse(promptText);
  }

  Future<void> _streamResponse(String promptText) async {
    try {
      final responseStream = _chatService.sendMessage(
        prompt: promptText,
        history: _geminiHistory,
      );

      final responseBuffer = StringBuffer();
      await for (final chunk in responseStream) {
        responseBuffer.write(chunk);
        _aiTransport.addChunk(chunk);
      }

      _geminiHistory.add({
        'role': 'user',
        'parts': [
          {'text': promptText},
        ],
      });
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
    if (!_hasError || _lastPrompt == null) return;

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

    try {
      await _streamResponse(_lastPrompt!);
    } catch (e) {
      // Errors are already handled inside _streamResponse
    }
  }

  String _buildSystemInstruction() {
    final capabilities = A2UiClientCapabilities.fromCatalogs([
      globalGenUICatalog,
    ]);
    final capabilitiesJson = jsonEncode(capabilities.toJson());

    final schemasDesc = globalGenUISchemasPromptDescription;

    final String roleDescription;
    if (_settingsService.appPersona == AppPersona.customerPortal) {
      final now = DateTime.now();
      final localizer = ChatLocalization.fromLocale(
        PlatformDispatcher.instance.locale,
      );
      final systemLanguage = localizer.languageName;
      final currentMonthName = localizer.getMonthName(now);
      final currentYear = now.year;
      final formattedCurrentDate = localizer.getFormattedDate(now);

      roleDescription =
          '''
You are a customer service assistant for a client portal (app de clientes). The user is a customer of the company.
You must help the user manage their customer account, requests, and bills.

### CURRENT TEMPORAL CONTEXT
The current date is: $formattedCurrentDate (today is in the year $currentYear).
Any user requests for "la última factura" (last invoice), "factura de este mes" (this month's invoice), etc. MUST refer contextually to the current date ($currentMonthName $currentYear or recent previous months). Do NOT generate dates from years far in the past (like 2024 or 2023) unless specifically asked for archived records..

You can help them with:
1. Request or view invoices (facturas).
2. Request or view certificates (certificados).
3. Pay pending bills/invoices (pagar facturas).
4. View customer details, profile, or account status.
5. Offer quick-replies (e.g. "Ver mis facturas", "Pedir un certificado", "Pagar factura", "Ver mi perfil").

To fulfill these customer requests, you must map their concepts to the available UI components below:
- To show one or more downloadable files (invoices, certificates, receipts, documents), use `single_attachment_widget` (SingleAttachmentWidget) or `attachment_list_widget` (AttachmentListWidget). Use professional names like "Factura_Junio_2026.pdf" or "Certificado_Retenciones_2025.pdf", correct file sizes, and set downloable attachments.
- To allow the user to pay a pending invoice, display the pending invoice details and use `custom_button` (CustomButton) with a label like "Pagar factura" and specify a callback event (like "onPressed").
- To show billing history, consumption charts, or monthly costs, use `metric_chart_widget` (MetricChartWidget) or `stats_widget` (StatsWidget).
- To show a welcome message, notice, alert or alert banner, use `alert_banner_widget` (AlertBannerWidget).
- To show payment history or logs over time, use `timeline_widget` (TimelineWidget).
- To show the user's profile details, use `user_card_widget` (UserCardWidget).
- To offer quick navigation/queries, use `quick_replies_widget` (QuickRepliesWidget) with actions like "Ver facturas", "Pedir certificado", "Pagar factura pendiente", "Ver perfil".

You must respond in the system's language ($systemLanguage) or match the language the user speaks. If the user writes in Spanish, respond in Spanish. If they write in English, respond in English. Speak politely, like a professional customer service assistant.
''';
    } else {
      roleDescription = '''
You are a GenUI assistant that helps users manage their task board and team.
''';
    }

    return '''
$roleDescription
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
   When the user interacts with a widget (e.g. toggling a task, pressing a button, or checking a box), you will receive a `UserActionEvent` inside the chat history as a JSON string under the "action" payload.
   For example:
   {"action": {"name": "TaskItemWidget_onToggleEvent", "context": {"task_id": "task_1_id", "title": "Design GenUI", "isCompleted": true, "priority": "high"}}}
   Or:
   {"action": {"name": "CustomButton_onPressedEvent", "context": {"label": "Pagar factura"}}}
   
   When you receive such an event, you MUST respond by updating the UI layout. If it was a checkbox toggle, you should update the target task's "isCompleted" property. If it was a payment button click, acknowledge the payment process and update the stats or UI to show the new state.

Always follow these rules strictly.
''';
  }

  void _seedInitialMessage() {
    _chatHistory.clear();
    if (_settingsService.appPersona == AppPersona.customerPortal) {
      final localizer = ChatLocalization.fromLocale(
        PlatformDispatcher.instance.locale,
      );
      _chatHistory.add(
        ChatTimelineItem(isUser: false, text: localizer.getGreeting()),
      );
    }
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
    _lastPrompt = null;

    _conversationEventSub?.cancel();
    _incomingMessagesSub?.cancel();
    _aiConversation.dispose();
    _aiTransport.dispose();
    _aiController.dispose();

    _chatService.dispose();
    _initChatService();

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
    _seedInitialMessage();
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
    _chatService.dispose();
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
