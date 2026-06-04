import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:genui_annotations/genui_annotations.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

part 'timeline_widget.genui.g.dart';

@generativeUI
/// A premium vertical timeline widget representing log events, milestones, or actions.
class TimelineWidget extends StatelessWidget {
  final String title;
  final List<dynamic> events;
  final void Function(String eventTitle)? onTapEvent;

  const TimelineWidget({
    super.key,
    required this.events,
    this.title = 'Activity Timeline',
    this.onTapEvent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0x1F1E293B),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 18),
          if (events.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                'No events logged.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.4),
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final item = events[index];
                final mapItem = item is Map ? item : <String, dynamic>{};
                final eventTitle =
                    (mapItem['title'] as String?) ??
                    (mapItem['label'] as String?) ??
                    (mapItem['name'] as String?) ??
                    'Event';
                final description = mapItem['description'] as String?;
                final timestamp = mapItem['timestamp'] as String?;
                final status = (mapItem['status'] as String?) ?? 'pending';

                final isLast = index == events.length - 1;

                // Color configuration based on status
                final (nodeColor, iconData, isGlow) = (() {
                  switch (status.toLowerCase()) {
                    case 'completed':
                      return (
                        const Color(0xFF10B981),
                        Icons.check_circle_rounded,
                        false,
                      );
                    case 'active':
                      return (
                        const Color(0xFF3B82F6),
                        Icons.radio_button_checked_rounded,
                        true,
                      );
                    case 'pending':
                    default:
                      return (Colors.white24, Icons.circle_outlined, false);
                  }
                })();

                return InkWell(
                  onTap: onTapEvent != null
                      ? () => onTapEvent!(eventTitle)
                      : null,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 4.0,
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Vertical timeline line + node indicator
                          Column(
                            children: [
                              // Node circle
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  if (isGlow)
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: nodeColor.withValues(alpha: 0.2),
                                      ),
                                    ),
                                  Icon(
                                    iconData,
                                    color: nodeColor,
                                    size: isGlow ? 18 : 16,
                                  ),
                                ],
                              ),
                              // Connecting line
                              if (!isLast)
                                Expanded(
                                  child: Container(
                                    width: 2,
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    color: Colors.white10,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 14),
                          // Content details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        eventTitle,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              status.toLowerCase() == 'pending'
                                              ? Colors.white54
                                              : Colors.white,
                                        ),
                                      ),
                                    ),
                                    if (timestamp != null &&
                                        timestamp.isNotEmpty)
                                      Text(
                                        timestamp,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.white.withValues(
                                            alpha: 0.35,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                if (description != null &&
                                    description.isNotEmpty) ...[
                                  const SizedBox(height: 3),
                                  Text(
                                    description,
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: status.toLowerCase() == 'pending'
                                          ? Colors.white30
                                          : Colors.white54,
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 14),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
