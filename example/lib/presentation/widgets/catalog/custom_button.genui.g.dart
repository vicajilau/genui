// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'custom_button.dart';

// **************************************************************************
// GenerativeUIGenerator
// **************************************************************************

// ignore_for_file: type=lint, unused_element, unused_field, non_constant_identifier_names

/// The mapped identifier for CustomButton.
const String $CustomButtonIdentifier = "CustomButton";

/// Event name constants for CustomButton.
abstract class CustomButtonEvents {
  static const String onPressed = 'CustomButton_onPressedEvent';
}

/// Auto-generated CatalogItem for CustomButton.
final CatalogItem $CustomButtonCatalogItem = CatalogItem(
  name: $CustomButtonIdentifier,
  dataSchema: S.object(
    description: "Auto-generated schema for CustomButton.",
    properties: {
      "label": S.string(description: "The label property."),
      "color": S.string(
        description: "The color property in hex format (e.g., #FF6366F1).",
      ),
    },
    required: ["label"],
  ),
  widgetBuilder: (itemContext) {
    final data = itemContext.data as Map<String, dynamic>;
    return CustomButton(
      label: (data["label"] as String?) ?? "",
      color: (() {
        final val = data["color"];
        if (val is! String) return null;
        var hex = val.replaceAll("#", "").trim();
        if (hex.startsWith("0x")) hex = hex.substring(2);
        if (hex.length == 6) hex = "FF$hex";
        if (hex.length == 8) {
          final intVal = int.tryParse(hex, radix: 16);
          if (intVal != null) return Color(intVal);
        }
        return null;
      })(),
      onPressed: () {
        itemContext.dispatchEvent(
          UserActionEvent(
            name: CustomButtonEvents.onPressed,
            sourceComponentId: itemContext.id,
            context: {...data},
          ),
        );
      },
    );
  },
);
