import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

/// A widget panel that renders the property editor controls (text fields, sliders,
/// toggles, and dropdowns) for modifying the active catalog component's properties.
class ComponentPropertiesPanel extends StatelessWidget {
  const ComponentPropertiesPanel({
    super.key,
    required this.selectedComponent,
    required this.btnLabel,
    required this.onBtnLabelChanged,
    required this.btnColor,
    required this.onBtnColorChanged,
    required this.taskTitle,
    required this.onTaskTitleChanged,
    required this.taskCompleted,
    required this.onTaskCompletedChanged,
    required this.taskPriority,
    required this.onTaskPriorityChanged,
    required this.statsTotal,
    required this.onStatsTotalChanged,
    required this.statsCompleted,
    required this.onStatsCompletedChanged,
    required this.userName,
    required this.onUserNameChanged,
    required this.userRole,
    required this.onUserRoleChanged,
    required this.userActive,
    required this.onUserActiveChanged,
    required this.metricTitle,
    required this.onMetricTitleChanged,
    required this.metricValue,
    required this.onMetricValueChanged,
    required this.metricLegend,
    required this.onMetricLegendChanged,
    required this.metricColor,
    required this.onMetricColorChanged,
    required this.pillPriority,
    required this.onPillPriorityChanged,
    required this.pillLabel,
    required this.onPillLabelChanged,
    required this.attachmentTitle,
    required this.onAttachmentTitleChanged,
    required this.attachmentItemsJson,
    required this.onAttachmentItemsJsonChanged,
    required this.timelineTitle,
    required this.onTimelineTitleChanged,
    required this.timelineEventsJson,
    required this.onTimelineEventsJsonChanged,
    required this.alertType,
    required this.onAlertTypeChanged,
    required this.alertMessage,
    required this.onAlertMessageChanged,
    required this.alertActionLabel,
    required this.onAlertActionLabelChanged,
  });

  final String selectedComponent;
  final String btnLabel;
  final ValueChanged<String> onBtnLabelChanged;
  final String btnColor;
  final ValueChanged<String> onBtnColorChanged;
  final String taskTitle;
  final ValueChanged<String> onTaskTitleChanged;
  final bool taskCompleted;
  final ValueChanged<bool> onTaskCompletedChanged;
  final String taskPriority;
  final ValueChanged<String> onTaskPriorityChanged;
  final int statsTotal;
  final ValueChanged<int> onStatsTotalChanged;
  final int statsCompleted;
  final ValueChanged<int> onStatsCompletedChanged;
  final String userName;
  final ValueChanged<String> onUserNameChanged;
  final String userRole;
  final ValueChanged<String> onUserRoleChanged;
  final bool userActive;
  final ValueChanged<bool> onUserActiveChanged;
  final String metricTitle;
  final ValueChanged<String> onMetricTitleChanged;
  final double metricValue;
  final ValueChanged<double> onMetricValueChanged;
  final String metricLegend;
  final ValueChanged<String> onMetricLegendChanged;
  final String metricColor;
  final ValueChanged<String> onMetricColorChanged;
  final String pillPriority;
  final ValueChanged<String> onPillPriorityChanged;
  final String pillLabel;
  final ValueChanged<String> onPillLabelChanged;
  final String attachmentTitle;
  final ValueChanged<String> onAttachmentTitleChanged;
  final String attachmentItemsJson;
  final ValueChanged<String> onAttachmentItemsJsonChanged;
  final String timelineTitle;
  final ValueChanged<String> onTimelineTitleChanged;
  final String timelineEventsJson;
  final ValueChanged<String> onTimelineEventsJsonChanged;
  final String alertType;
  final ValueChanged<String> onAlertTypeChanged;
  final String alertMessage;
  final ValueChanged<String> onAlertMessageChanged;
  final String alertActionLabel;
  final ValueChanged<String> onAlertActionLabelChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0x1F1E293B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.white10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.tune_rounded, color: Color(0xFF818CF8), size: 18),
                SizedBox(width: 8),
                Text(
                  'PROPERTIES',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white38,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._buildComponentEditorControls(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildComponentEditorControls(BuildContext context) {
    switch (selectedComponent) {
      case 'CustomButton':
        return [
          _buildTextField(
            label: 'Label',
            value: btnLabel,
            onChanged: onBtnLabelChanged,
          ),
          const SizedBox(height: 16),
          _buildColorField(
            context: context,
            label: 'Color',
            value: btnColor,
            onChanged: onBtnColorChanged,
          ),
        ];

      case 'TaskItemWidget':
        return [
          _buildTextField(
            label: 'Title',
            value: taskTitle,
            onChanged: onTaskTitleChanged,
          ),
          const SizedBox(height: 16),
          _buildSwitchField(
            label: 'Completed',
            value: taskCompleted,
            onChanged: onTaskCompletedChanged,
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            label: 'Priority',
            value: taskPriority,
            items: const ['high', 'medium', 'low'],
            onChanged: (value) {
              if (value != null) {
                onTaskPriorityChanged(value);
              }
            },
          ),
        ];

      case 'StatsWidget':
        return [
          _buildSliderField(
            label: 'Total Tasks',
            value: statsTotal.toDouble(),
            min: 0,
            max: 20,
            divisions: 20,
            onChanged: (val) => onStatsTotalChanged(val.toInt()),
          ),
          const SizedBox(height: 16),
          _buildSliderField(
            label: 'Completed Tasks',
            value: statsCompleted.toDouble(),
            min: 0,
            max: statsTotal > 0 ? statsTotal.toDouble() : 1,
            divisions: statsTotal > 0 ? statsTotal : 1,
            onChanged: (val) => onStatsCompletedChanged(val.toInt()),
          ),
        ];

      case 'UserCardWidget':
        return [
          _buildTextField(
            label: 'Name',
            value: userName,
            onChanged: onUserNameChanged,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Role',
            value: userRole,
            onChanged: onUserRoleChanged,
          ),
          const SizedBox(height: 16),
          _buildSwitchField(
            label: 'Active',
            value: userActive,
            onChanged: onUserActiveChanged,
          ),
        ];

      case 'MetricChartWidget':
        return [
          _buildTextField(
            label: 'Title',
            value: metricTitle,
            onChanged: onMetricTitleChanged,
          ),
          const SizedBox(height: 16),
          _buildSliderField(
            label: 'Value',
            value: metricValue,
            min: 0.0,
            max: 1.0,
            divisions: 100,
            onChanged: onMetricValueChanged,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Legend Label',
            value: metricLegend,
            onChanged: onMetricLegendChanged,
          ),
          const SizedBox(height: 16),
          _buildColorField(
            context: context,
            label: 'Chart Color',
            value: metricColor,
            onChanged: onMetricColorChanged,
          ),
        ];

      case 'PriorityPillWidget':
        return [
          _buildDropdownField(
            label: 'Priority',
            value: pillPriority,
            items: const ['high', 'medium', 'low'],
            onChanged: (value) {
              if (value != null) {
                onPillPriorityChanged(value);
              }
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Label (Optional)',
            value: pillLabel,
            onChanged: onPillLabelChanged,
          ),
        ];

      case 'AttachmentListWidget':
        return [
          _buildTextField(
            label: 'Title',
            value: attachmentTitle,
            onChanged: onAttachmentTitleChanged,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Items JSON',
            value: attachmentItemsJson,
            onChanged: onAttachmentItemsJsonChanged,
            maxLines: 5,
          ),
        ];

      case 'TimelineWidget':
        return [
          _buildTextField(
            label: 'Title',
            value: timelineTitle,
            onChanged: onTimelineTitleChanged,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Events JSON',
            value: timelineEventsJson,
            onChanged: onTimelineEventsJsonChanged,
            maxLines: 6,
          ),
        ];

      case 'AlertBannerWidget':
        return [
          _buildDropdownField(
            label: 'Type',
            value: alertType,
            items: const ['success', 'info', 'warning', 'error'],
            onChanged: (value) {
              if (value != null) {
                onAlertTypeChanged(value);
              }
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Message',
            value: alertMessage,
            onChanged: onAlertMessageChanged,
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Action Label (Optional)',
            value: alertActionLabel,
            onChanged: onAlertActionLabelChanged,
          ),
        ];

      default:
        return [
          const Text(
            'No properties to edit',
            style: TextStyle(color: Colors.white70),
          ),
        ];
    }
  }

  Widget _buildTextField({
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
    int maxLines = 1,
  }) {
    return _CatalogTextField(
      label: label,
      value: value,
      onChanged: onChanged,
      maxLines: maxLines,
    );
  }

  Color _parseColor(String colorStr) {
    var hex = colorStr.replaceAll("#", "").trim();
    if (hex.startsWith("0x")) hex = hex.substring(2);
    if (hex.length == 6) hex = "FF$hex";
    if (hex.length == 8) {
      final intVal = int.tryParse(hex, radix: 16);
      if (intVal != null) return Color(intVal);
    }
    return const Color(0xFF6366F1);
  }

  Widget _buildColorField({
    required BuildContext context,
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    final currentColor = _parseColor(value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: () async {
            final Color newColor = await showColorPickerDialog(
              context,
              currentColor,
              title: Text(
                'Select Button Color',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              width: 40,
              height: 40,
              spacing: 8,
              runSpacing: 8,
              borderRadius: 8,
              wheelDiameter: 200,
              enableOpacity: false,
              showColorCode: true,
              colorCodeHasColor: true,
              showColorName: true,
              pickersEnabled: const <ColorPickerType, bool>{
                ColorPickerType.both: false,
                ColorPickerType.primary: true,
                ColorPickerType.accent: true,
                ColorPickerType.bw: false,
                ColorPickerType.custom: false,
                ColorPickerType.wheel: true,
              },
            );

            final hexStr =
                '#${newColor.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';
            onChanged(hexStr);
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0x33000000),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: currentColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: currentColor.withOpacity(0.4),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    value.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'monospace',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Icon(
                  Icons.color_lens_rounded,
                  color: Color(0xFF818CF8),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0x33000000),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: const Color(0xFF0F172A),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              onChanged: onChanged,
              items: items.map<DropdownMenuItem<String>>((String val) {
                return DropdownMenuItem<String>(value: val, child: Text(val));
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchField({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeTrackColor: const Color(0xFF6366F1),
        ),
      ],
    );
  }

  Widget _buildSliderField({
    required String label,
    required double value,
    required double min,
    required double max,
    int? divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              max <= 1.0
                  ? '${(value * 100).toInt()}%'
                  : value.toInt().toString(),
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF818CF8),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          activeColor: const Color(0xFF6366F1),
          inactiveColor: Colors.white12,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _CatalogTextField extends StatefulWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final int maxLines;

  const _CatalogTextField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.maxLines = 1,
  });

  @override
  State<_CatalogTextField> createState() => _CatalogTextFieldState();
}

class _CatalogTextFieldState extends State<_CatalogTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(_CatalogTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      final oldSelection = _controller.selection;
      _controller.text = widget.value;
      try {
        _controller.selection = oldSelection.copyWith(
          baseOffset: oldSelection.baseOffset.clamp(0, widget.value.length),
          extentOffset: oldSelection.extentOffset.clamp(0, widget.value.length),
        );
      } catch (_) {
        _controller.selection = TextSelection.collapsed(
          offset: widget.value.length,
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          maxLines: widget.maxLines,
          controller: _controller,
          onChanged: widget.onChanged,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            filled: true,
            fillColor: const Color(0x33000000),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.white12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF6366F1)),
            ),
          ),
        ),
      ],
    );
  }
}
