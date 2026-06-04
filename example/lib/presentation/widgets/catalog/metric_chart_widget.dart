import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:genui_annotations/genui_annotations.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

part 'metric_chart_widget.genui.g.dart';

@generativeUI
/// A premium circular chart widget displaying a progress metric.
class MetricChartWidget extends StatelessWidget {
  final String title;
  final double value;
  final String legendLabel;
  final String? colorHex;

  const MetricChartWidget({
    super.key,
    required this.title,
    required this.value,
    this.legendLabel = 'Completed',
    this.colorHex,
  });

  @override
  Widget build(BuildContext context) {
    // Parse colorHex with standard indigo fallback
    final activeColor = (() {
      if (colorHex == null) return const Color(0xFF6366F1);
      var hex = colorHex!.replaceAll('#', '').trim();
      if (hex.startsWith('0x')) hex = hex.substring(2);
      if (hex.length == 6) hex = 'FF$hex';
      final val = int.tryParse(hex, radix: 16);
      return val != null ? Color(val) : const Color(0xFF6366F1);
    })();

    final clampValue = value.clamp(0.0, 1.0);
    final percentText = '${(clampValue * 100).toInt()}%';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0x1F1E293B), // Premium Slate translucent
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Circular progress visual
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 90,
                height: 90,
                child: CircularProgressIndicator(
                  value: clampValue,
                  strokeWidth: 8,
                  backgroundColor: Colors.white.withValues(alpha: 0.05),
                  valueColor: AlwaysStoppedAnimation<Color>(activeColor),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    percentText,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Legend / Description
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: activeColor,
                  boxShadow: [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.4),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                legendLabel,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
