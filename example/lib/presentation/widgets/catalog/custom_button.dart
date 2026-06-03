import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:genui_annotations/genui_annotations.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

part 'custom_button.genui.g.dart';

@generativeUI
class CustomButton extends StatelessWidget {
  final String label;
  final String? color;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.label,
    this.color,
    required this.onPressed,
  });

  Color? _parseColor(String? input) {
    if (input == null) return null;
    switch (input.toLowerCase().trim()) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'indigo':
        return const Color(0xFF6366F1);
      case 'purple':
        return const Color(0xFF8B5CF6);
      case 'amber':
        return const Color(0xFFF59E0B);
      case 'orange':
        return Colors.orange;
      case 'teal':
        return Colors.teal;
      case 'pink':
        return Colors.pink;
      case 'grey':
      case 'gray':
        return Colors.grey;
    }
    // Attempt hex parsing
    var hex = input.replaceAll('#', '').trim();
    if (hex.startsWith('0x')) hex = hex.substring(2);
    if (hex.length == 6) hex = 'FF$hex';
    if (hex.length == 8) {
      final val = int.tryParse(hex, radix: 16);
      if (val != null) return Color(val);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final parsedColor = _parseColor(color);
    final backgroundColor =
        parsedColor ??
        const Color(0xFF6366F1); // Indigo as default premium theme
    final foregroundColor =
        ThemeData.estimateBrightnessForColor(backgroundColor) ==
            Brightness.light
        ? Colors.black87
        : Colors.white;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}
