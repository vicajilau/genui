// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'attachment_list_widget.dart';

// **************************************************************************
// GenerativeUIGenerator
// **************************************************************************

// ignore_for_file: type=lint, unused_element, unused_field, non_constant_identifier_names

/// The mapped identifier for AttachmentListWidget.
const String $AttachmentListWidgetIdentifier = "AttachmentListWidget";

/// Event name constants for AttachmentListWidget.
abstract class AttachmentListWidgetEvents {
  static const String onTapItem = 'AttachmentListWidget_onTapItemEvent';
}

/// Auto-generated CatalogItem for AttachmentListWidget.
final CatalogItem $AttachmentListWidgetCatalogItem = CatalogItem(
  name: $AttachmentListWidgetIdentifier,
  dataSchema: S.object(
    description: "Auto-generated schema for AttachmentListWidget.",
    properties: {
      "items": S.list(description: "The items property."),
      "title": S.string(description: "The title property."),
    },
    required: ["items"],
  ),
  widgetBuilder: (itemContext) {
    final data = itemContext.data as Map<String, dynamic>;
    return AttachmentListWidget(
      items: (data["items"] as List<dynamic>?) ?? const [],
      title: (data["title"] as String?) ?? 'Attachments',
      onTapItem: (String fileName) {
        itemContext.dispatchEvent(
          UserActionEvent(
            name: AttachmentListWidgetEvents.onTapItem,
            sourceComponentId: itemContext.id,
            context: {
              ...data,
              ...{'fileName': fileName},
            },
          ),
        );
      },
    );
  },
);
