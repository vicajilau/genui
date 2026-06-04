// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'alert_banner_widget.dart';

// **************************************************************************
// GenerativeUIGenerator
// **************************************************************************

// ignore_for_file: type=lint, unused_element, unused_field, non_constant_identifier_names

/// The mapped identifier for AlertBannerWidget.
const String $AlertBannerWidgetIdentifier = "AlertBannerWidget";

/// Event name constants for AlertBannerWidget.
abstract class AlertBannerWidgetEvents {
  static const String onAction = 'AlertBannerWidget_onActionEvent';
  static const String onDismiss = 'AlertBannerWidget_onDismissEvent';
}

/// Auto-generated CatalogItem for AlertBannerWidget.
final CatalogItem $AlertBannerWidgetCatalogItem = CatalogItem(
  name: $AlertBannerWidgetIdentifier,
  dataSchema: S.object(
    description: "Auto-generated schema for AlertBannerWidget.",
    properties: {
      "type": S.string(description: "The type property."),
      "message": S.string(description: "The message property."),
      "actionLabel": S.string(description: "The actionLabel property."),
    },
    required: ["type", "message"],
  ),
  widgetBuilder: (itemContext) {
    final data = itemContext.data as Map<String, dynamic>;
    return AlertBannerWidget(
      type: (data["type"] as String?) ?? "",
      message: (data["message"] as String?) ?? "",
      actionLabel: data["actionLabel"] as String?,
      onAction: () {
        itemContext.dispatchEvent(
          UserActionEvent(
            name: AlertBannerWidgetEvents.onAction,
            sourceComponentId: itemContext.id,
            context: {...data},
          ),
        );
      },
      onDismiss: () {
        itemContext.dispatchEvent(
          UserActionEvent(
            name: AlertBannerWidgetEvents.onDismiss,
            sourceComponentId: itemContext.id,
            context: {...data},
          ),
        );
      },
    );
  },
);
