import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:genui/genui.dart';
import 'package:genui_annotations/genui_annotations.dart';

import '../../genui_registry.g.dart';
import 'component_catalog/component_catalog_panel.dart';
import 'component_catalog/component_json_inspector_panel.dart';
import 'component_catalog/component_properties_panel.dart';
import 'interactive_surface.dart';
import 'catalog/custom_button.dart';
import 'catalog/stats_widget.dart';
import 'catalog/task_item_widget.dart';
import 'catalog/user_card_widget.dart';

/// A widget that presents the interactive Component Catalog, permitting developers
/// to select components, edit properties, inspect payloads, and view live renders.
class ComponentCatalogView extends StatefulWidget {
  const ComponentCatalogView({super.key});

  @override
  State<ComponentCatalogView> createState() => _ComponentCatalogViewState();
}

/// The active state of [ComponentCatalogView] that manages selection states,
/// property configurations for all catalog items, and UI events.
class _ComponentCatalogViewState extends State<ComponentCatalogView> {
  bool _isCatalogExpanded = true;

  // Component Catalog States
  String _selectedComponent = $CustomButtonIdentifier;

  // CustomButton properties
  String _btnLabel = 'Hello world';
  String _btnColor = '#6366F1';

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

        final sidebar = ComponentCatalogPanel(
          isWide: isWide,
          isExpanded: _isCatalogExpanded,
          onToggleExpanded: () {
            setState(() {
              _isCatalogExpanded = !_isCatalogExpanded;
            });
          },
          selectedComponent: _selectedComponent,
          onComponentSelected: (component) {
            setState(() {
              _selectedComponent = component;
            });
          },
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
                      Expanded(
                        child: ComponentPropertiesPanel(
                          selectedComponent: _selectedComponent,
                          btnLabel: _btnLabel,
                          onBtnLabelChanged: (val) =>
                              setState(() => _btnLabel = val),
                          btnColor: _btnColor,
                          onBtnColorChanged: (val) =>
                              setState(() => _btnColor = val),
                          taskTitle: _taskTitle,
                          onTaskTitleChanged: (val) =>
                              setState(() => _taskTitle = val),
                          taskCompleted: _taskCompleted,
                          onTaskCompletedChanged: (val) =>
                              setState(() => _taskCompleted = val),
                          taskPriority: _taskPriority,
                          onTaskPriorityChanged: (val) =>
                              setState(() => _taskPriority = val),
                          statsTotal: _statsTotal,
                          onStatsTotalChanged: (val) => setState(() {
                            _statsTotal = val;
                            if (_statsCompleted > _statsTotal) {
                              _statsCompleted = _statsTotal;
                            }
                          }),
                          statsCompleted: _statsCompleted,
                          onStatsCompletedChanged: (val) =>
                              setState(() => _statsCompleted = val),
                          userName: _userName,
                          onUserNameChanged: (val) =>
                              setState(() => _userName = val),
                          userRole: _userRole,
                          onUserRoleChanged: (val) =>
                              setState(() => _userRole = val),
                          userActive: _userActive,
                          onUserActiveChanged: (val) =>
                              setState(() => _userActive = val),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: ComponentJsonInspectorPanel(
                          jsonStr: _getSelectedComponentJson(),
                          onCopy: () {
                            Clipboard.setData(
                              ClipboardData(text: _getSelectedComponentJson()),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'A2UI JSON payload copied to clipboard!',
                                ),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                else ...[
                  ComponentPropertiesPanel(
                    selectedComponent: _selectedComponent,
                    btnLabel: _btnLabel,
                    onBtnLabelChanged: (val) => setState(() => _btnLabel = val),
                    btnColor: _btnColor,
                    onBtnColorChanged: (val) => setState(() => _btnColor = val),
                    taskTitle: _taskTitle,
                    onTaskTitleChanged: (val) =>
                        setState(() => _taskTitle = val),
                    taskCompleted: _taskCompleted,
                    onTaskCompletedChanged: (val) =>
                        setState(() => _taskCompleted = val),
                    taskPriority: _taskPriority,
                    onTaskPriorityChanged: (val) =>
                        setState(() => _taskPriority = val),
                    statsTotal: _statsTotal,
                    onStatsTotalChanged: (val) => setState(() {
                      _statsTotal = val;
                      if (_statsCompleted > _statsTotal) {
                        _statsCompleted = _statsTotal;
                      }
                    }),
                    statsCompleted: _statsCompleted,
                    onStatsCompletedChanged: (val) =>
                        setState(() => _statsCompleted = val),
                    userName: _userName,
                    onUserNameChanged: (val) => setState(() => _userName = val),
                    userRole: _userRole,
                    onUserRoleChanged: (val) => setState(() => _userRole = val),
                    userActive: _userActive,
                    onUserActiveChanged: (val) =>
                        setState(() => _userActive = val),
                  ),
                  const SizedBox(height: 24),
                  ComponentJsonInspectorPanel(
                    jsonStr: _getSelectedComponentJson(),
                    onCopy: () {
                      Clipboard.setData(
                        ClipboardData(text: _getSelectedComponentJson()),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'A2UI JSON payload copied to clipboard!',
                          ),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
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

  String _getComponentDisplayName(String component) {
    return switch (component) {
      $CustomButtonIdentifier => 'CustomButton',
      $TaskItemWidgetIdentifier => 'TaskItemWidget',
      $StatsWidgetIdentifier => 'StatsWidget',
      $UserCardWidgetIdentifier => 'UserCardWidget',
      _ => component,
    };
  }
}
