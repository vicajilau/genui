import 'dart:convert';

/// A class representing a decoded GenUI UserActionEvent.
///
/// It parses the raw JSON string received from the `SurfaceController.onSubmit`
/// stream into structured fields.
class GenUiEvent {
  /// The name of the action/event (e.g. `'TaskItemWidget_onToggleEvent'`).
  final String name;

  /// The ID of the component that triggered the event.
  final String sourceComponentId;

  /// Context details associated with the event (usually the widget's properties data).
  final Map<String, dynamic> context;

  const GenUiEvent({
    required this.name,
    required this.sourceComponentId,
    required this.context,
  });

  /// Safely parses a raw event JSON string emitted from `SurfaceController.onSubmit`.
  ///
  /// Returns `null` if the string is not a valid GenUI event payload.
  static GenUiEvent? parse(String eventJson) {
    try {
      final payload = jsonDecode(eventJson) as Map<String, dynamic>;
      final action = payload['action'] as Map<String, dynamic>;
      return GenUiEvent(
        name: action['name'] as String,
        sourceComponentId: action['sourceComponentId'] as String,
        context: Map<String, dynamic>.from(action['context'] as Map),
      );
    } catch (_) {
      return null;
    }
  }
}
