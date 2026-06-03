// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

import 'package:example/presentation/widgets/catalog/custom_button.dart';
import 'package:example/presentation/widgets/catalog/stats_widget.dart';
import 'package:example/presentation/widgets/catalog/task_item_widget.dart';
import 'package:example/presentation/widgets/catalog/user_card_widget.dart';

/// Global list of all auto-generated Generative UI CatalogItems.
final List<CatalogItem> generatedCatalogItems = [
  $CustomButtonCatalogItem,
  $StatsWidgetCatalogItem,
  $TaskItemWidgetCatalogItem,
  $UserCardWidgetCatalogItem,
];

/// Global catalog composed of all auto-generated catalog items combined with the official basic catalog.
final Catalog globalGenUICatalog = Catalog([
  ...BasicCatalogItems.asCatalog().items,
  ...generatedCatalogItems,
], catalogId: 'inline_catalog');
