// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'product_card_widget.dart';

// **************************************************************************
// GenerativeUIGenerator
// **************************************************************************

// ignore_for_file: type=lint, unused_element, unused_field, non_constant_identifier_names

/// The mapped identifier for ProductCardWidget.
const String $ProductCardWidgetIdentifier = "ProductCardWidget";

/// Event name constants for ProductCardWidget.
abstract class ProductCardWidgetEvents {
  static const String onTapProduct = 'ProductCardWidget_onTapProductEvent';
  static const String onBuy = 'ProductCardWidget_onBuyEvent';
}

/// Auto-generated CatalogItem for ProductCardWidget.
final CatalogItem $ProductCardWidgetCatalogItem = CatalogItem(
  name: $ProductCardWidgetIdentifier,
  dataSchema: S.object(
    description: "Auto-generated schema for ProductCardWidget.",
    properties: {
      "title": S.string(description: "The title property."),
      "price": S.string(description: "The price property."),
      "imageUrl": S.string(description: "The imageUrl property."),
      "description": S.string(description: "The description property."),
      "rating": S.string(description: "The rating property."),
    },
    required: ["title", "price"],
  ),
  widgetBuilder: (itemContext) {
    final data = itemContext.data as Map<String, dynamic>;
    return ProductCardWidget(
      title: (data["title"] as String?) ?? "",
      price: (data["price"] as String?) ?? "",
      imageUrl: data["imageUrl"] as String?,
      description: data["description"] as String?,
      rating: (data["rating"] as num?)?.toDouble(),
      onTapProduct: () {
        itemContext.dispatchEvent(
          UserActionEvent(
            name: ProductCardWidgetEvents.onTapProduct,
            sourceComponentId: itemContext.id,
            context: {...data},
          ),
        );
      },
      onBuy: () {
        itemContext.dispatchEvent(
          UserActionEvent(
            name: ProductCardWidgetEvents.onBuy,
            sourceComponentId: itemContext.id,
            context: {...data},
          ),
        );
      },
    );
  },
);
