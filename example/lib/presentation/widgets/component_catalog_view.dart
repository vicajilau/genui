import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:genui/genui.dart';
import 'package:genui_annotations/genui_annotations.dart';

import '../../genui_registry.g.dart';
import 'interactive_surface.dart';
import 'catalog/custom_button.dart';
import 'catalog/stats_widget.dart';
import 'catalog/task_item_widget.dart';
import 'catalog/user_card_widget.dart';

class ComponentCatalogView extends StatefulWidget {
  const ComponentCatalogView({super.key});

  @override
  State<ComponentCatalogView> createState() => _ComponentCatalogViewState();
}

class _ComponentCatalogViewState extends State<ComponentCatalogView> {
  // Component Catalog States
  String _selectedComponent = $CustomButtonIdentifier;

  // CustomButton properties
  String _btnLabel = 'Hello world';
  String _btnColor = 'red';

  // TaskItemWidget properties
  String _taskTitle = 'Design Generative UI Architecture';
  bool _taskCompleted = false;
  String _taskPriority = 'high';

  // StatsWidget properties
  int _statsTotal = 5;
  int _statsCompleted = 2;

  // UserCardWidget properties
  String _userName = 'Ada Lovelace';
  String _userRole = 'Lead Architect';
  bool _userActive = true;

  // Catalog Event Handler
  void _handleCatalogWidgetEvent(String eventJson) {
    final event = GenUiEvent.parse(eventJson);
    if (event == null) return;

    if (event.name == CustomButtonEvents.onPressed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'CustomButton clicked! Label: "${event.context['label']}"',
          ),
          duration: const Duration(seconds: 1),
        ),
      );
    } else if (event.name == TaskItemWidgetEvents.onToggle) {
      setState(() {
        _taskCompleted = !_taskCompleted;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'TaskItemWidget checkbox toggled! Title: "${event.context['title']}"',
          ),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  Map<String, dynamic> _getSelectedComponentProperties() {
    switch (_selectedComponent) {
      case $CustomButtonIdentifier:
        return {
          'label': _btnLabel,
          'color': (_btnColor.trim().isEmpty || _btnColor == 'default')
              ? null
              : _btnColor.trim(),
        };
      case $TaskItemWidgetIdentifier:
        return {
          'title': _taskTitle,
          'isCompleted': _taskCompleted,
          'priority': _taskPriority,
          'task_id': 'preview_task_id',
        };
      case $StatsWidgetIdentifier:
        return {'totalTasks': _statsTotal, 'completedTasks': _statsCompleted};
      case $UserCardWidgetIdentifier:
        return {'name': _userName, 'role': _userRole, 'isActive': _userActive};
      default:
        return {};
    }
  }

  String _getSelectedComponentJson() {
    final props = _getSelectedComponentProperties();
    final encoder = const JsonEncoder.withIndent('  ');
    final message = {
      'version': 'v0.9',
      'updateComponents': {
        'surfaceId': 'composed_surface',
        'components': [
          {
            'id': 'root',
            'component': 'Column',
            'children': ['hello_widget'],
          },
          {'id': 'hello_widget', 'component': _selectedComponent, ...props},
        ],
      },
    };
    return encoder.convert(message);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;

        final sidebar = Container(
          width: isWide ? 280 : double.infinity,
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
          child: ListView(
            shrinkWrap: !isWide,
            physics: isWide
                ? const ClampingScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 12, bottom: 12),
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
              _buildSidebarItem(
                $CustomButtonIdentifier,
                Icons.smart_button_rounded,
                'Custom Button',
              ),
              _buildSidebarItem(
                $TaskItemWidgetIdentifier,
                Icons.task_alt_rounded,
                'Task Item',
              ),
              _buildSidebarItem(
                $StatsWidgetIdentifier,
                Icons.bar_chart_rounded,
                'Stats Summary',
              ),
              _buildSidebarItem(
                $UserCardWidgetIdentifier,
                Icons.person_outline_rounded,
                'User Card',
              ),
            ],
          ),
        );

        final previewAndControls = Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _getComponentDisplayName(_selectedComponent),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x336366F1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0x666366F1)),
                      ),
                      child: const Text(
                        'A2UI Component',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF818CF8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'PREVIEW',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white38,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: const Color(0x1F1E293B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Center(
                    child: InteractiveSurface(
                      key: ValueKey(
                        '${_selectedComponent}_${_getSelectedComponentProperties().toString()}',
                      ),
                      components: [
                        Component(
                          id: 'root',
                          type: 'Column',
                          properties: const {
                            'children': ['preview_target'],
                          },
                        ),
                        Component(
                          id: 'preview_target',
                          type: _selectedComponent,
                          properties: _getSelectedComponentProperties(),
                        ),
                      ],
                      catalog: globalGenUICatalog,
                      onEvent: _handleCatalogWidgetEvent,
                      surfaceId: 'preview_surface',
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildPropertiesPanel()),
                      const SizedBox(width: 24),
                      Expanded(child: _buildJsonInspectorPanel()),
                    ],
                  )
                else ...[
                  _buildPropertiesPanel(),
                  const SizedBox(height: 24),
                  _buildJsonInspectorPanel(),
                ],
              ],
            ),
          ),
        );

        return isWide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [sidebar, previewAndControls],
              )
            : Column(children: [sidebar, previewAndControls]);
      },
    );
  }

  Widget _buildSidebarItem(String componentName, IconData icon, String label) {
    final isSelected = _selectedComponent == componentName;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        onTap: () {
          setState(() {
            _selectedComponent = componentName;
          });
        },
        selected: isSelected,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        selectedTileColor: const Color(0x1A6366F1),
        leading: Icon(
          icon,
          color: isSelected ? const Color(0xFF818CF8) : Colors.white60,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  String _getComponentDisplayName(String component) {
    return switch (component) {
      $CustomButtonIdentifier => 'CustomButton',
      $TaskItemWidgetIdentifier => 'TaskItemWidget',
      $StatsWidgetIdentifier => 'StatsWidget',
      $UserCardWidgetIdentifier => 'UserCardWidget',
      _ => component,
    };
  }

  Widget _buildPropertiesPanel() {
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
            ..._buildComponentEditorControls(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildComponentEditorControls() {
    switch (_selectedComponent) {
      case $CustomButtonIdentifier:
        return [
          _buildTextField(
            label: 'Label',
            value: _btnLabel,
            onChanged: (val) => setState(() => _btnLabel = val),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Color (name or hex, e.g. indigo, #4F46E5)',
            value: _btnColor,
            onChanged: (val) => setState(() => _btnColor = val),
          ),
        ];

      case $TaskItemWidgetIdentifier:
        return [
          _buildTextField(
            label: 'Title',
            value: _taskTitle,
            onChanged: (val) => setState(() => _taskTitle = val),
          ),
          const SizedBox(height: 16),
          _buildSwitchField(
            label: 'Completed',
            value: _taskCompleted,
            onChanged: (val) => setState(() => _taskCompleted = val),
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            label: 'Priority',
            value: _taskPriority,
            items: ['high', 'medium', 'low'],
            onChanged: (val) => setState(() => _taskPriority = val ?? 'low'),
          ),
        ];

      case $StatsWidgetIdentifier:
        return [
          _buildSliderField(
            label: 'Total Tasks',
            value: _statsTotal.toDouble(),
            min: 0,
            max: 20,
            divisions: 20,
            onChanged: (val) => setState(() {
              _statsTotal = val.toInt();
              if (_statsCompleted > _statsTotal) {
                _statsCompleted = _statsTotal;
              }
            }),
          ),
          const SizedBox(height: 16),
          _buildSliderField(
            label: 'Completed Tasks',
            value: _statsCompleted.toDouble(),
            min: 0,
            max: _statsTotal > 0 ? _statsTotal.toDouble() : 1,
            divisions: _statsTotal > 0 ? _statsTotal : 1,
            onChanged: (val) => setState(() => _statsCompleted = val.toInt()),
          ),
        ];

      case $UserCardWidgetIdentifier:
        return [
          _buildTextField(
            label: 'Name',
            value: _userName,
            onChanged: (val) => setState(() => _userName = val),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Role',
            value: _userRole,
            onChanged: (val) => setState(() => _userRole = val),
          ),
          const SizedBox(height: 16),
          _buildSwitchField(
            label: 'Active',
            value: _userActive,
            onChanged: (val) => setState(() => _userActive = val),
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
        TextField(
          controller: TextEditingController.fromValue(
            TextEditingValue(
              text: value,
              selection: TextSelection.collapsed(offset: value.length),
            ),
          ),
          onChanged: onChanged,
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
              value.toInt().toString(),
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

  Widget _buildJsonInspectorPanel() {
    final jsonStr = _getSelectedComponentJson();
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.code_rounded,
                      color: Color(0xFF06B6D4),
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'A2UI PAYLOAD',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white38,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(
                    Icons.copy_rounded,
                    color: Colors.white70,
                    size: 16,
                  ),
                  tooltip: 'Copy JSON payload',
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: jsonStr));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('A2UI JSON payload copied to clipboard!'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF090D16),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                jsonStr,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Color(0xFFA5F3FC),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
