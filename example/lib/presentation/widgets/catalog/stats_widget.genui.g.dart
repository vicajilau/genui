// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'stats_widget.dart';

// **************************************************************************
// GenerativeUIGenerator
// **************************************************************************

// ignore_for_file: type=lint, unused_element, unused_field, non_constant_identifier_names

/// The mapped identifier for StatsWidget.
const String $StatsWidgetIdentifier = "StatsWidget";

/// Auto-generated CatalogItem for StatsWidget.
final CatalogItem $StatsWidgetCatalogItem = CatalogItem(
  name: $StatsWidgetIdentifier,
  dataSchema: S.object(
    description: "Auto-generated schema for StatsWidget.",
    properties: {
      "totalTasks": S.integer(description: "The totalTasks property."),
      "completedTasks": S.integer(description: "The completedTasks property."),
    },
    required: ["totalTasks", "completedTasks"],
  ),
  widgetBuilder: (itemContext) {
    final data = itemContext.data as Map<String, dynamic>;
    return StatsWidget(
      totalTasks: (data["totalTasks"] as int?) ?? 0,
      completedTasks: (data["completedTasks"] as int?) ?? 0,
    );
  },
);
