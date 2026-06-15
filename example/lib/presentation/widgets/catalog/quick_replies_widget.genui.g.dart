// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'quick_replies_widget.dart';

// **************************************************************************
// GenerativeUIGenerator
// **************************************************************************

// ignore_for_file: type=lint, unused_element, unused_field, non_constant_identifier_names

/// The mapped identifier for QuickRepliesWidget.
const String $QuickRepliesWidgetIdentifier = "QuickRepliesWidget";

/// Event name constants for QuickRepliesWidget.
abstract class QuickRepliesWidgetEvents {
  static const String onTapReply = 'QuickRepliesWidget_onTapReplyEvent';
}

/// Auto-generated CatalogItem for QuickRepliesWidget.
final CatalogItem $QuickRepliesWidgetCatalogItem = CatalogItem(
  name: $QuickRepliesWidgetIdentifier,
  dataSchema: S.object(
    description: "Auto-generated schema for QuickRepliesWidget.",
    properties: {
      "replies": S.list(description: "The replies property."),
      "title": S.string(description: "The title property."),
    },
    required: ["replies"],
  ),
  widgetBuilder: (itemContext) {
    final data = itemContext.data as Map<String, dynamic>;
    return QuickRepliesWidget(
      replies: (data["replies"] as List<dynamic>?) ?? const [],
      title: data["title"] as String?,
      onTapReply: (String reply) {
        itemContext.dispatchEvent(
          UserActionEvent(
            name: QuickRepliesWidgetEvents.onTapReply,
            sourceComponentId: itemContext.id,
            context: {
              ...data,
              ...{'reply': reply},
            },
          ),
        );
      },
    );
  },
);
