/// Represents an item in the chat timeline, which can be either
/// user message text, AI conversational text, or an embedded dynamic UI surface.
class ChatTimelineItem {
  final bool isUser;
  final String? text;
  final String? surfaceId;

  ChatTimelineItem({required this.isUser, this.text, this.surfaceId});
}
