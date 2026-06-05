// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'dart:convert';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

import 'package:example/presentation/widgets/catalog/alert_banner_widget.dart';
import 'package:example/presentation/widgets/catalog/attachment_list_widget.dart';
import 'package:example/presentation/widgets/catalog/custom_button.dart';
import 'package:example/presentation/widgets/catalog/metric_chart_widget.dart';
import 'package:example/presentation/widgets/catalog/priority_pill_widget.dart';
import 'package:example/presentation/widgets/catalog/stats_widget.dart';
import 'package:example/presentation/widgets/catalog/task_item_widget.dart';
import 'package:example/presentation/widgets/catalog/timeline_widget.dart';
import 'package:example/presentation/widgets/catalog/user_card_widget.dart';

/// Global list of all auto-generated Generative UI CatalogItems.
final List<CatalogItem> generatedCatalogItems = [
  $AlertBannerWidgetCatalogItem,
  $AttachmentListWidgetCatalogItem,
  $CustomButtonCatalogItem,
  $MetricChartWidgetCatalogItem,
  $PriorityPillWidgetCatalogItem,
  $StatsWidgetCatalogItem,
  $TaskItemWidgetCatalogItem,
  $TimelineWidgetCatalogItem,
  $UserCardWidgetCatalogItem,
];

/// Global catalog composed of all auto-generated catalog items combined with the official basic catalog.
final Catalog globalGenUICatalog = Catalog([
  ...BasicCatalogItems.asCatalog().items,
  ...generatedCatalogItems,
], catalogId: 'inline_catalog');

/// Exported JSON Schema map of all custom components.
Map<String, Map<String, dynamic>> get globalGenUISchemas => {
  for (final item in generatedCatalogItems)
    item.name: jsonDecode(item.dataSchema.toJson()) as Map<String, dynamic>,
};

/// JSON-encoded string of the schemas for local/in-memory use.
String get globalGenUISchemasJson => jsonEncode(globalGenUISchemas);

/// A pre-formatted prompt description listing all component schemas for LLM system instructions.
String get globalGenUISchemasPromptDescription {
  final buffer = StringBuffer();
  globalGenUISchemas.forEach((name, schema) {
    buffer.writeln('- Component: "$name"');
    buffer.writeln('  Schema: ${jsonEncode(schema)}');
  });
  return buffer.toString();
}
