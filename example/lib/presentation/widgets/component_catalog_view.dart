import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:genui_annotations/genui_annotations.dart';

import '../../genui_registry.g.dart';
import '../../l10n/app_localizations.dart';
import 'component_catalog/component_catalog_panel.dart';
import 'component_catalog/component_json_inspector_panel.dart';
import 'component_catalog/component_properties_panel.dart';
import 'interactive_surface.dart';
import 'catalog/custom_button.dart';
import 'catalog/stats_widget.dart';
import 'catalog/task_item_widget.dart';
import 'catalog/user_card_widget.dart';
import 'catalog/metric_chart_widget.dart';
import 'catalog/priority_pill_widget.dart';
import 'catalog/attachment_list_widget.dart';
import 'catalog/timeline_widget.dart';
import 'catalog/alert_banner_widget.dart';
import 'catalog/single_attachment_widget.dart';
import 'catalog/quick_replies_widget.dart';
import 'catalog/product_card_widget.dart';

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

  // Class-level localization getter
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  Locale? _currentLocale;

  // CustomButton properties
  String _btnLabel = '';
  String _btnColor = '#6366F1';

  // TaskItemWidget properties
  String _taskTitle = '';
  bool _taskCompleted = false;
  String _taskPriority = 'high';

  // StatsWidget properties
  int _statsTotal = 5;
  int _statsCompleted = 2;

  // UserCardWidget properties
  String _userName = '';
  String _userRole = '';
  bool _userActive = true;

  // MetricChartWidget properties
  String _metricTitle = '';
  double _metricValue = 0.85;
  String _metricLegend = '';
  String _metricColor = '#6366F1';

  // PriorityPillWidget properties
  String _pillPriority = 'high';
  String _pillLabel = '';

  // AttachmentListWidget properties
  String _attachmentTitle = '';
  String _attachmentItemsJson = '';

  // TimelineWidget properties
  String _timelineTitle = '';
  String _timelineEventsJson = '';

  // AlertBannerWidget properties
  String _alertType = 'warning';
  String _alertMessage = '';
  String _alertActionLabel = '';

  // SingleAttachmentWidget properties
  String _singleAttachmentName = '';
  String _singleAttachmentType = 'pdf';
  String _singleAttachmentSize = '';
  String _singleAttachmentStatus = 'ready';

  // QuickRepliesWidget properties
  String _quickRepliesTitle = '';
  String _quickRepliesJson = '';

  // ProductCardWidget properties
  String _productTitle = '';
  String _productPrice = '\$299.99';
  String _productImageUrl =
      'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500';
  String _productDescription = '';
  double _productRating = 4.8;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newLocale = Localizations.localeOf(context);
    if (_currentLocale != newLocale) {
      _currentLocale = newLocale;
      _initializeLocalizedDefaults();
    }
  }

  void _initializeLocalizedDefaults() {
    _btnLabel = l10n.btnLabelDefault;
    _taskTitle = l10n.taskTitleDefault;
    _userName = l10n.userNameDefault;
    _userRole = l10n.userRoleDefault;
    _metricTitle = l10n.metricTitleDefault;
    _metricLegend = l10n.metricLegendDefault;
    _pillLabel = l10n.pillLabelDefault;
    _attachmentTitle = l10n.attachmentTitleDefault;

    const encoder = JsonEncoder.withIndent('  ');

    _attachmentItemsJson = encoder.convert([
      {'name': l10n.projectProposalPdfName, 'type': 'pdf', 'size': '2.4 MB'},
      {'name': l10n.designMockupPngName, 'type': 'image', 'size': '1.8 MB'},
    ]);

    _timelineTitle = l10n.timelineTitleDefault;
    _timelineEventsJson = encoder.convert([
      {
        'title': l10n.projectInitiatedTitle,
        'description': l10n.projectInitiatedDesc,
        'timestamp': l10n.monday,
        'status': 'completed',
      },
      {
        'title': l10n.designMockupsTitle,
        'description': l10n.designMockupsDesc,
        'timestamp': l10n.tuesday,
        'status': 'active',
      },
      {
        'title': l10n.apiIntegrationTitle,
        'description': l10n.apiIntegrationDesc,
        'timestamp': l10n.thursday,
        'status': 'pending',
      },
    ]);

    _alertMessage = l10n.alertMessageDefault;
    _alertActionLabel = l10n.alertActionLabelDefault;
    _singleAttachmentName = l10n.singleAttachmentNameDefault;
    _singleAttachmentSize = l10n.singleAttachmentSizeDefault;

    _quickRepliesTitle = l10n.quickRepliesTitleDefault;
    _quickRepliesJson = encoder.convert([
      l10n.quickReplyViewPricing,
      l10n.quickReplyContactHuman,
      l10n.quickReplyRequestCustom,
    ]);

    _productTitle = l10n.productTitleDefault;
    _productDescription = l10n.productDescriptionDefault;
  }

  // Catalog Event Handler
  void _handleCatalogWidgetEvent(String eventJson) {
    final event = GenUiEvent.parse(eventJson);
    if (event == null) return;

    if (event.name == CustomButtonEvents.onPressed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.catalogCustomButtonClicked(
              event.context['label']?.toString() ?? '',
            ),
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
            l10n.catalogTaskItemToggled(
              event.context['title']?.toString() ?? '',
            ),
          ),
          duration: const Duration(seconds: 1),
        ),
      );
    } else if (event.name == TimelineWidgetEvents.onTapEvent) {
      final eventTitle = event.context['eventTitle']?.toString() ?? 'Event';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.catalogTimelineEventTapped(eventTitle)),
          duration: const Duration(seconds: 1),
        ),
      );
    } else if (event.name == AttachmentListWidgetEvents.onTapItem) {
      final fileName = event.context['fileName']?.toString() ?? 'File';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.catalogAttachmentItemClicked(fileName)),
          duration: const Duration(seconds: 1),
        ),
      );
    } else if (event.name == AlertBannerWidgetEvents.onAction) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.catalogAlertActionClicked(
              event.context['actionLabel']?.toString() ?? '',
            ),
          ),
          duration: const Duration(seconds: 1),
          backgroundColor: const Color(0xFF6366F1),
        ),
      );
    } else if (event.name == AlertBannerWidgetEvents.onDismiss) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.catalogAlertBannerDismissed),
          duration: const Duration(seconds: 1),
        ),
      );
    } else if (event.name == SingleAttachmentWidgetEvents.onTap) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.catalogSingleAttachmentTapped(
              event.context['name']?.toString() ?? '',
            ),
          ),
          duration: const Duration(seconds: 1),
        ),
      );
    } else if (event.name == SingleAttachmentWidgetEvents.onAction) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.catalogSingleAttachmentActionClicked(
              event.context['status']?.toString() ?? '',
            ),
          ),
          duration: const Duration(seconds: 1),
        ),
      );
    } else if (event.name == QuickRepliesWidgetEvents.onTapReply) {
      final reply = event.context['reply']?.toString() ?? '';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.catalogQuickReplySelected(reply)),
          duration: const Duration(seconds: 1),
        ),
      );
    } else if (event.name == ProductCardWidgetEvents.onTapProduct) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.catalogProductTapped(event.context['title']?.toString() ?? ''),
          ),
          duration: const Duration(seconds: 1),
        ),
      );
    } else if (event.name == ProductCardWidgetEvents.onBuy) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.catalogProductBought(event.context['price']?.toString() ?? ''),
          ),
          duration: const Duration(seconds: 1),
          backgroundColor: const Color(0xFF10B981),
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
      case $MetricChartWidgetIdentifier:
        return {
          'title': _metricTitle,
          'value': _metricValue,
          'legendLabel': _metricLegend,
          'colorHex': _metricColor.trim(),
        };
      case $PriorityPillWidgetIdentifier:
        return {
          'priority': _pillPriority,
          'label': _pillLabel.trim().isEmpty ? null : _pillLabel.trim(),
        };
      case $AttachmentListWidgetIdentifier:
        final List<dynamic> decodedItems = (() {
          try {
            final parsed = jsonDecode(_attachmentItemsJson);
            if (parsed is List) return parsed;
          } catch (_) {}
          return const [];
        })();
        return {'title': _attachmentTitle, 'items': decodedItems};
      case $TimelineWidgetIdentifier:
        final List<dynamic> decodedEvents = (() {
          try {
            final parsed = jsonDecode(_timelineEventsJson);
            if (parsed is List) return parsed;
          } catch (_) {}
          return const [];
        })();
        return {'title': _timelineTitle, 'events': decodedEvents};
      case $AlertBannerWidgetIdentifier:
        return {
          'type': _alertType,
          'message': _alertMessage,
          'actionLabel': _alertActionLabel.trim().isEmpty
              ? null
              : _alertActionLabel.trim(),
        };
      case $SingleAttachmentWidgetIdentifier:
        return {
          'name': _singleAttachmentName,
          'type': _singleAttachmentType,
          'size': _singleAttachmentSize.trim().isEmpty
              ? null
              : _singleAttachmentSize.trim(),
          'status': _singleAttachmentStatus,
        };
      case $QuickRepliesWidgetIdentifier:
        final List<dynamic> decodedReplies = (() {
          try {
            final parsed = jsonDecode(_quickRepliesJson);
            if (parsed is List) return parsed;
          } catch (_) {}
          return const [];
        })();
        return {
          'title': _quickRepliesTitle.trim().isEmpty
              ? null
              : _quickRepliesTitle.trim(),
          'replies': decodedReplies,
        };
      case $ProductCardWidgetIdentifier:
        return {
          'title': _productTitle,
          'price': _productPrice,
          'imageUrl': _productImageUrl.trim().isEmpty
              ? null
              : _productImageUrl.trim(),
          'description': _productDescription.trim().isEmpty
              ? null
              : _productDescription.trim(),
          'rating': _productRating,
        };
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
                      child: Text(
                        l10n.catalogA2uiComponentBadge,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF818CF8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.catalogPreviewHeader,
                  style: const TextStyle(
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
                          metricTitle: _metricTitle,
                          onMetricTitleChanged: (val) =>
                              setState(() => _metricTitle = val),
                          metricValue: _metricValue,
                          onMetricValueChanged: (val) =>
                              setState(() => _metricValue = val),
                          metricLegend: _metricLegend,
                          onMetricLegendChanged: (val) =>
                              setState(() => _metricLegend = val),
                          metricColor: _metricColor,
                          onMetricColorChanged: (val) =>
                              setState(() => _metricColor = val),
                          pillPriority: _pillPriority,
                          onPillPriorityChanged: (val) =>
                              setState(() => _pillPriority = val),
                          pillLabel: _pillLabel,
                          onPillLabelChanged: (val) =>
                              setState(() => _pillLabel = val),
                          attachmentTitle: _attachmentTitle,
                          onAttachmentTitleChanged: (val) =>
                              setState(() => _attachmentTitle = val),
                          attachmentItemsJson: _attachmentItemsJson,
                          onAttachmentItemsJsonChanged: (val) =>
                              setState(() => _attachmentItemsJson = val),
                          timelineTitle: _timelineTitle,
                          onTimelineTitleChanged: (val) =>
                              setState(() => _timelineTitle = val),
                          timelineEventsJson: _timelineEventsJson,
                          onTimelineEventsJsonChanged: (val) =>
                              setState(() => _timelineEventsJson = val),
                          alertType: _alertType,
                          onAlertTypeChanged: (val) =>
                              setState(() => _alertType = val),
                          alertMessage: _alertMessage,
                          onAlertMessageChanged: (val) =>
                              setState(() => _alertMessage = val),
                          alertActionLabel: _alertActionLabel,
                          onAlertActionLabelChanged: (val) =>
                              setState(() => _alertActionLabel = val),
                          singleAttachmentName: _singleAttachmentName,
                          onSingleAttachmentNameChanged: (val) =>
                              setState(() => _singleAttachmentName = val),
                          singleAttachmentType: _singleAttachmentType,
                          onSingleAttachmentTypeChanged: (val) =>
                              setState(() => _singleAttachmentType = val),
                          singleAttachmentSize: _singleAttachmentSize,
                          onSingleAttachmentSizeChanged: (val) =>
                              setState(() => _singleAttachmentSize = val),
                          singleAttachmentStatus: _singleAttachmentStatus,
                          onSingleAttachmentStatusChanged: (val) =>
                              setState(() => _singleAttachmentStatus = val),
                          quickRepliesTitle: _quickRepliesTitle,
                          onQuickRepliesTitleChanged: (val) =>
                              setState(() => _quickRepliesTitle = val),
                          quickRepliesJson: _quickRepliesJson,
                          onQuickRepliesJsonChanged: (val) =>
                              setState(() => _quickRepliesJson = val),
                          productTitle: _productTitle,
                          onProductTitleChanged: (val) =>
                              setState(() => _productTitle = val),
                          productPrice: _productPrice,
                          onProductPriceChanged: (val) =>
                              setState(() => _productPrice = val),
                          productImageUrl: _productImageUrl,
                          onProductImageUrlChanged: (val) =>
                              setState(() => _productImageUrl = val),
                          productDescription: _productDescription,
                          onProductDescriptionChanged: (val) =>
                              setState(() => _productDescription = val),
                          productRating: _productRating,
                          onProductRatingChanged: (val) =>
                              setState(() => _productRating = val),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: ComponentJsonInspectorPanel(
                          payloadJson: _getSelectedComponentJson(),
                          schemaJson: const JsonEncoder.withIndent('  ')
                              .convert(
                                globalGenUISchemas[_selectedComponent] ??
                                    {'error': 'No schema available'},
                              ),
                          globalSchemasJson: const JsonEncoder.withIndent(
                            '  ',
                          ).convert(globalGenUISchemas),
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
                    metricTitle: _metricTitle,
                    onMetricTitleChanged: (val) =>
                        setState(() => _metricTitle = val),
                    metricValue: _metricValue,
                    onMetricValueChanged: (val) =>
                        setState(() => _metricValue = val),
                    metricLegend: _metricLegend,
                    onMetricLegendChanged: (val) =>
                        setState(() => _metricLegend = val),
                    metricColor: _metricColor,
                    onMetricColorChanged: (val) =>
                        setState(() => _metricColor = val),
                    pillPriority: _pillPriority,
                    onPillPriorityChanged: (val) =>
                        setState(() => _pillPriority = val),
                    pillLabel: _pillLabel,
                    onPillLabelChanged: (val) =>
                        setState(() => _pillLabel = val),
                    attachmentTitle: _attachmentTitle,
                    onAttachmentTitleChanged: (val) =>
                        setState(() => _attachmentTitle = val),
                    attachmentItemsJson: _attachmentItemsJson,
                    onAttachmentItemsJsonChanged: (val) =>
                        setState(() => _attachmentItemsJson = val),
                    timelineTitle: _timelineTitle,
                    onTimelineTitleChanged: (val) =>
                        setState(() => _timelineTitle = val),
                    timelineEventsJson: _timelineEventsJson,
                    onTimelineEventsJsonChanged: (val) =>
                        setState(() => _timelineEventsJson = val),
                    alertType: _alertType,
                    onAlertTypeChanged: (val) =>
                        setState(() => _alertType = val),
                    alertMessage: _alertMessage,
                    onAlertMessageChanged: (val) =>
                        setState(() => _alertMessage = val),
                    alertActionLabel: _alertActionLabel,
                    onAlertActionLabelChanged: (val) =>
                        setState(() => _alertActionLabel = val),
                    singleAttachmentName: _singleAttachmentName,
                    onSingleAttachmentNameChanged: (val) =>
                        setState(() => _singleAttachmentName = val),
                    singleAttachmentType: _singleAttachmentType,
                    onSingleAttachmentTypeChanged: (val) =>
                        setState(() => _singleAttachmentType = val),
                    singleAttachmentSize: _singleAttachmentSize,
                    onSingleAttachmentSizeChanged: (val) =>
                        setState(() => _singleAttachmentSize = val),
                    singleAttachmentStatus: _singleAttachmentStatus,
                    onSingleAttachmentStatusChanged: (val) =>
                        setState(() => _singleAttachmentStatus = val),
                    quickRepliesTitle: _quickRepliesTitle,
                    onQuickRepliesTitleChanged: (val) =>
                        setState(() => _quickRepliesTitle = val),
                    quickRepliesJson: _quickRepliesJson,
                    onQuickRepliesJsonChanged: (val) =>
                        setState(() => _quickRepliesJson = val),
                    productTitle: _productTitle,
                    onProductTitleChanged: (val) =>
                        setState(() => _productTitle = val),
                    productPrice: _productPrice,
                    onProductPriceChanged: (val) =>
                        setState(() => _productPrice = val),
                    productImageUrl: _productImageUrl,
                    onProductImageUrlChanged: (val) =>
                        setState(() => _productImageUrl = val),
                    productDescription: _productDescription,
                    onProductDescriptionChanged: (val) =>
                        setState(() => _productDescription = val),
                    productRating: _productRating,
                    onProductRatingChanged: (val) =>
                        setState(() => _productRating = val),
                  ),
                  const SizedBox(height: 24),
                  ComponentJsonInspectorPanel(
                    payloadJson: _getSelectedComponentJson(),
                    schemaJson: const JsonEncoder.withIndent('  ').convert(
                      globalGenUISchemas[_selectedComponent] ??
                          {'error': 'No schema available'},
                    ),
                    globalSchemasJson: const JsonEncoder.withIndent(
                      '  ',
                    ).convert(globalGenUISchemas),
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
      $CustomButtonIdentifier => l10n.componentCustomButton,
      $TaskItemWidgetIdentifier => l10n.componentTaskItem,
      $StatsWidgetIdentifier => l10n.componentStatsSummary,
      $UserCardWidgetIdentifier => l10n.componentUserCard,
      $MetricChartWidgetIdentifier => l10n.componentMetricChart,
      $PriorityPillWidgetIdentifier => l10n.componentPriorityPill,
      $AttachmentListWidgetIdentifier => l10n.componentAttachmentList,
      $TimelineWidgetIdentifier => l10n.componentTimelineLog,
      $AlertBannerWidgetIdentifier => l10n.componentAlertBanner,
      $SingleAttachmentWidgetIdentifier => l10n.componentSingleAttachment,
      $QuickRepliesWidgetIdentifier => l10n.componentQuickReplies,
      $ProductCardWidgetIdentifier => l10n.componentProductCard,
      _ => component,
    };
  }
}
