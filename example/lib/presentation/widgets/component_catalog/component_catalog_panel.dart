import 'package:flutter/material.dart';

/// A widget panel that acts as the navigation sidebar/collapsible list containing
/// the selectable list of A2UI components in the Component Catalog.
class ComponentCatalogPanel extends StatelessWidget {
  const ComponentCatalogPanel({
    super.key,
    required this.isWide,
    required this.isExpanded,
    required this.onToggleExpanded,
    required this.selectedComponent,
    required this.onComponentSelected,
  });

  final bool isWide;
  final bool isExpanded;
  final VoidCallback onToggleExpanded;
  final String selectedComponent;
  final ValueChanged<String> onComponentSelected;

  @override
  Widget build(BuildContext context) {
    final panelHeight = isWide ? double.infinity : (isExpanded ? 260.0 : 56.0);
    final panelWidth = isWide ? (isExpanded ? 280.0 : 56.0) : double.infinity;
    final showText = isExpanded || !isWide;
    final headerPadding = isExpanded
        ? const EdgeInsets.fromLTRB(12, 14, 8, 12)
        : (isWide
              ? const EdgeInsets.symmetric(vertical: 14)
              : const EdgeInsets.fromLTRB(12, 10, 8, 10));

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      width: panelWidth,
      height: panelHeight,
      decoration: BoxDecoration(
        color: const Color(0x0DFFFFFF),
        border: Border(
          right: isWide
              ? const BorderSide(color: Colors.white10)
              : BorderSide.none,
          bottom: isWide
              ? BorderSide.none
              : const BorderSide(color: Colors.white10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: onToggleExpanded,
            child: Padding(
              padding: headerPadding,
              child: () {
                final headerWidget = Row(
                  mainAxisAlignment: showText
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.widgets_rounded,
                      size: 18,
                      color: Color(0xFF818CF8),
                    ),
                    if (showText) ...[
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'COMPONENTS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white38,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      Text(
                        isExpanded ? 'Hide' : 'Show',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white54,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        isWide
                            ? (isExpanded
                                  ? Icons.chevron_left_rounded
                                  : Icons.chevron_right_rounded)
                            : (isExpanded
                                  ? Icons.expand_less_rounded
                                  : Icons.expand_more_rounded),
                        color: Colors.white54,
                      ),
                    ],
                  ],
                );

                if (isWide) {
                  return Align(
                    alignment: showText
                        ? Alignment.centerLeft
                        : Alignment.center,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      child: SizedBox(
                        width: showText ? 256 : 18,
                        child: headerWidget,
                      ),
                    ),
                  );
                } else {
                  return headerWidget;
                }
              }(),
            ),
          ),
          if (isExpanded || isWide)
            Expanded(
              child: ListView(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: showText ? 12 : 6,
                ),
                children: [
                  _buildSidebarItem(
                    context,
                    selectedComponent,
                    onComponentSelected,
                    'Custom Button',
                    Icons.smart_button_rounded,
                    'CustomButton',
                    showText,
                  ),
                  _buildSidebarItem(
                    context,
                    selectedComponent,
                    onComponentSelected,
                    'Task Item',
                    Icons.task_alt_rounded,
                    'TaskItemWidget',
                    showText,
                  ),
                  _buildSidebarItem(
                    context,
                    selectedComponent,
                    onComponentSelected,
                    'Stats Summary',
                    Icons.bar_chart_rounded,
                    'StatsWidget',
                    showText,
                  ),
                  _buildSidebarItem(
                    context,
                    selectedComponent,
                    onComponentSelected,
                    'User Card',
                    Icons.person_outline_rounded,
                    'UserCardWidget',
                    showText,
                  ),
                  _buildSidebarItem(
                    context,
                    selectedComponent,
                    onComponentSelected,
                    'Metric Chart',
                    Icons.donut_large_rounded,
                    'MetricChartWidget',
                    showText,
                  ),
                  _buildSidebarItem(
                    context,
                    selectedComponent,
                    onComponentSelected,
                    'Priority Pill',
                    Icons.label_important_outline_rounded,
                    'PriorityPillWidget',
                    showText,
                  ),
                  _buildSidebarItem(
                    context,
                    selectedComponent,
                    onComponentSelected,
                    'Attachment List',
                    Icons.attachment_rounded,
                    'AttachmentListWidget',
                    showText,
                  ),
                  _buildSidebarItem(
                    context,
                    selectedComponent,
                    onComponentSelected,
                    'Timeline Log',
                    Icons.timeline_rounded,
                    'TimelineWidget',
                    showText,
                  ),
                  _buildSidebarItem(
                    context,
                    selectedComponent,
                    onComponentSelected,
                    'Alert Banner',
                    Icons.warning_amber_rounded,
                    'AlertBannerWidget',
                    showText,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(
    BuildContext context,
    String currentSelection,
    ValueChanged<String> onSelected,
    String label,
    IconData icon,
    String componentName,
    bool showText,
  ) {
    final isSelected = currentSelection == componentName;

    if (!showText) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Tooltip(
          message: label,
          preferBelow: false,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onSelected(componentName),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isSelected
                      ? const Color(0x1A6366F1)
                      : Colors.transparent,
                ),
                child: Icon(
                  icon,
                  color: isSelected ? const Color(0xFF818CF8) : Colors.white60,
                ),
              ),
            ),
          ),
        ),
      );
    }

    final itemTile = ListTile(
      onTap: () => onSelected(componentName),
      selected: isSelected,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      selectedTileColor: const Color(0x1A6366F1),
      leading: Icon(
        icon,
        color: isSelected ? const Color(0xFF818CF8) : Colors.white60,
      ),
      title: Text(
        label,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.fade,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
        ),
      ),
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: isWide
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                child: SizedBox(width: 256, child: itemTile),
              )
            : itemTile,
      ),
    );
  }
}
