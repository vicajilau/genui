import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:genui_annotations/genui_annotations.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

part 'alert_banner_widget.genui.g.dart';

@generativeUI
/// A premium alert banner displaying warnings, errors, notifications, or success states.
class AlertBannerWidget extends StatelessWidget {
  final String type;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onDismiss;

  const AlertBannerWidget({
    super.key,
    required this.type,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    // Determine colors and icons based on type
    final (baseColor, iconData) = (() {
      switch (type.toLowerCase()) {
        case 'success':
          return (const Color(0xFF10B981), Icons.check_circle_outline_rounded);
        case 'warning':
          return (const Color(0xFFF59E0B), Icons.warning_amber_rounded);
        case 'error':
          return (const Color(0xFFEF4444), Icons.error_outline_rounded);
        case 'info':
        default:
          return (const Color(0xFF3B82F6), Icons.info_outline_rounded);
      }
    })();

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0x1F1E293B), // Premium Slate translucent
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: baseColor.withValues(alpha: 0.15)),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left accent colored border bar
              Container(width: 5, color: baseColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      // Icon with type-specific color glow
                      Icon(iconData, color: baseColor, size: 20),
                      const SizedBox(width: 12),
                      // Message Text
                      Expanded(
                        child: Text(
                          message,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xE6FFFFFF),
                            height: 1.35,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Optional action button
                      if (actionLabel != null && actionLabel!.isNotEmpty) ...[
                        TextButton(
                          onPressed: onAction,
                          style: TextButton.styleFrom(
                            backgroundColor: baseColor.withValues(alpha: 0.12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            actionLabel!,
                            style: TextStyle(
                              fontSize: 12,
                              color: baseColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      // Optional close button
                      if (onDismiss != null)
                        IconButton(
                          onPressed: onDismiss,
                          icon: const Icon(Icons.close_rounded),
                          color: Colors.white38,
                          hoverColor: Colors.white10,
                          iconSize: 16,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          splashRadius: 16,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
