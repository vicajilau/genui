// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'single_attachment_widget.dart';

// **************************************************************************
// GenerativeUIGenerator
// **************************************************************************

// ignore_for_file: type=lint, unused_element, unused_field, non_constant_identifier_names

/// The mapped identifier for SingleAttachmentWidget.
const String $SingleAttachmentWidgetIdentifier = "SingleAttachmentWidget";

/// Event name constants for SingleAttachmentWidget.
abstract class SingleAttachmentWidgetEvents {
  static const String onTap = 'SingleAttachmentWidget_onTapEvent';
  static const String onAction = 'SingleAttachmentWidget_onActionEvent';
}

/// Auto-generated CatalogItem for SingleAttachmentWidget.
final CatalogItem $SingleAttachmentWidgetCatalogItem = CatalogItem(
  name: $SingleAttachmentWidgetIdentifier,
  dataSchema: S.object(
    description: "Auto-generated schema for SingleAttachmentWidget.",
    properties: {
      "name": S.string(description: "The name property."),
      "type": S.string(description: "The type property."),
      "size": S.string(description: "The size property."),
      "status": S.string(description: "The status property."),
    },
    required: ["name"],
  ),
  widgetBuilder: (itemContext) {
    final data = itemContext.data as Map<String, dynamic>;
    return SingleAttachmentWidget(
      name: (data["name"] as String?) ?? "",
      type: (data["type"] as String?) ?? 'file',
      size: data["size"] as String?,
      status: (data["status"] as String?) ?? 'ready',
      onTap: () {
        itemContext.dispatchEvent(
          UserActionEvent(
            name: SingleAttachmentWidgetEvents.onTap,
            sourceComponentId: itemContext.id,
            context: {...data},
          ),
        );
      },
      onAction: () {
        itemContext.dispatchEvent(
          UserActionEvent(
            name: SingleAttachmentWidgetEvents.onAction,
            sourceComponentId: itemContext.id,
            context: {...data},
          ),
        );
      },
    );
  },
);
