// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'priority_pill_widget.dart';

// **************************************************************************
// GenerativeUIGenerator
// **************************************************************************

// ignore_for_file: type=lint, unused_element, unused_field, non_constant_identifier_names

/// The mapped identifier for PriorityPillWidget.
const String $PriorityPillWidgetIdentifier = "PriorityPillWidget";

/// Auto-generated CatalogItem for PriorityPillWidget.
final CatalogItem $PriorityPillWidgetCatalogItem = CatalogItem(
  name: $PriorityPillWidgetIdentifier,
  dataSchema: S.object(
    description: "Auto-generated schema for PriorityPillWidget.",
    properties: {
      "priority": S.string(description: "The priority property."),
      "label": S.string(description: "The label property."),
    },
    required: ["priority"],
  ),
  widgetBuilder: (itemContext) {
    final data = itemContext.data as Map<String, dynamic>;
    return PriorityPillWidget(
      priority: (data["priority"] as String?) ?? "",
      label: data["label"] as String?,
    );
  },
);
