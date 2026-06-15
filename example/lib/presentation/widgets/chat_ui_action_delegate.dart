import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:genui/genui.dart';

/// A custom action delegate that intercepts A2UI interface events
/// (like alert dismissal, timelines, or task toggling) and processes them locally
/// on the surface controller before they propagate to the network.
class ChatUiActionDelegate implements ActionDelegate {
  final SurfaceController controller;

  const ChatUiActionDelegate(this.controller);

  @override
  bool handleEvent(
    BuildContext context,
    UiEvent event,
    SurfaceContext genUiContext,
    Widget Function(SurfaceDefinition, Catalog, String, DataContext)
    buildWidget,
  ) {
    if (event is! UserActionEvent) return false;

    final l10n = AppLocalizations.of(context)!;

    if (event.name == 'AttachmentListWidget_onTapItemEvent') {
      final fileName =
          event.context['fileName'] as String? ?? l10n.defaultFileName;
      final messenger = ScaffoldMessenger.of(context);

      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.downloadingFile(fileName),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 1),
          backgroundColor: const Color(0xFF6366F1),
        ),
      );

      Future.delayed(const Duration(seconds: 1), () {
        messenger.clearSnackBars();
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              l10n.downloadSuccess(fileName),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
          ),
        );
      });

      return true;
    }

    if (event.name == 'AlertBannerWidget_onDismissEvent') {
      final surfaceId = genUiContext.surfaceId;
      final definition = genUiContext.definition.value;
      if (definition == null) return false;

      final componentId = event.sourceComponentId;
      final parentComponent = definition.components['root'];
      final List<Component> finalUpdatedComponents = [];

      if (parentComponent != null) {
        final currentChildren = List<String>.from(
          parentComponent.properties['children'] as List<dynamic>? ?? [],
        );
        currentChildren.remove(componentId);

        finalUpdatedComponents.add(
          Component(
            id: parentComponent.id,
            type: parentComponent.type,
            properties: {
              ...parentComponent.properties,
              'children': currentChildren,
            },
          ),
        );
      }

      controller.handleMessage(
        UpdateComponents(
          surfaceId: surfaceId,
          components: finalUpdatedComponents,
        ),
      );

      final messenger = ScaffoldMessenger.of(context);
      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            l10n.alertDismissedLocally,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          duration: const Duration(milliseconds: 700),
          behavior: SnackBarBehavior.floating,
        ),
      );

      return true;
    }

    if (event.name == 'AlertBannerWidget_onActionEvent') {
      final actionLabel =
          event.context['actionLabel'] as String? ?? l10n.defaultActionLabel;
      final messenger = ScaffoldMessenger.of(context);

      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            l10n.actionExecuted(actionLabel),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          duration: const Duration(seconds: 1),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
        ),
      );

      return true;
    }

    if (event.name == 'TimelineWidget_onTapEventEvent') {
      final surfaceId = genUiContext.surfaceId;
      final definition = genUiContext.definition.value;
      if (definition == null) return false;

      final componentId = event.sourceComponentId;
      final component = definition.components[componentId];
      if (component == null) return false;

      final eventTitle = event.context['eventTitle'] as String?;
      if (eventTitle == null) return false;

      final currentEvents =
          component.properties['events'] as List<dynamic>? ?? [];
      final updatedEvents = currentEvents.map((e) {
        if (e is Map) {
          final eMap = Map<String, dynamic>.from(e);
          final currentTitle =
              (eMap['title'] as String?) ??
              (eMap['label'] as String?) ??
              (eMap['name'] as String?);
          if (currentTitle == eventTitle) {
            final currentStatus = eMap['status'] as String? ?? 'pending';
            eMap['status'] = currentStatus == 'completed'
                ? 'pending'
                : 'completed';
          }
          return eMap;
        }
        return e;
      }).toList();

      controller.handleMessage(
        UpdateComponents(
          surfaceId: surfaceId,
          components: [
            Component(
              id: component.id,
              type: component.type,
              properties: {...component.properties, 'events': updatedEvents},
            ),
          ],
        ),
      );

      final messenger = ScaffoldMessenger.of(context);
      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            l10n.timelineStatusUpdated(eventTitle),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          duration: const Duration(milliseconds: 700),
          backgroundColor: const Color(0xFF3B82F6),
          behavior: SnackBarBehavior.floating,
        ),
      );

      return true;
    }

    if (event.name == 'TaskItemWidget_onToggleEvent') {
      final surfaceId = genUiContext.surfaceId;
      final definition = genUiContext.definition.value;
      if (definition == null) return false;

      final componentId = event.sourceComponentId;
      final component = definition.components[componentId];
      if (component == null) return false;

      final List<Component> updatedComponents = [];

      final currentIsCompleted =
          component.properties['isCompleted'] as bool? ?? false;
      final newIsCompleted = !currentIsCompleted;

      final updatedTask = Component(
        id: component.id,
        type: component.type,
        properties: {...component.properties, 'isCompleted': newIsCompleted},
      );
      updatedComponents.add(updatedTask);

      int totalTasks = 0;
      int completedTasks = 0;

      for (final comp in definition.components.values) {
        if (comp.type == 'TaskItemWidget') {
          totalTasks++;
          final isComp = (comp.id == componentId)
              ? newIsCompleted
              : (comp.properties['isCompleted'] as bool? ?? false);
          if (isComp) {
            completedTasks++;
          }
        }
      }

      for (final comp in definition.components.values) {
        if (comp.type == 'StatsWidget') {
          updatedComponents.add(
            Component(
              id: comp.id,
              type: comp.type,
              properties: {
                ...comp.properties,
                'totalTasks': totalTasks,
                'completedTasks': completedTasks,
              },
            ),
          );
        }
      }

      controller.handleMessage(
        UpdateComponents(surfaceId: surfaceId, components: updatedComponents),
      );

      return true;
    }

    if (event.name == 'CustomButton_onPressedEvent') {
      final label =
          event.context['label'] as String? ?? l10n.defaultButtonLabel;
      final messenger = ScaffoldMessenger.of(context);

      final labelLower = label.toLowerCase();
      if (labelLower.contains('pagar') || labelLower.contains('pay')) {
        messenger.clearSnackBars();
        messenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.processingSecurePayment,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            duration: const Duration(seconds: 1),
            backgroundColor: const Color(0xFF6366F1),
          ),
        );

        Future.delayed(const Duration(seconds: 1), () {
          messenger.clearSnackBars();
          messenger.showSnackBar(
            SnackBar(
              content: Text(
                l10n.paymentSuccessful,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              backgroundColor: const Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
            ),
          );
        });
        return true;
      }

      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            l10n.buttonPressed(label),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          duration: const Duration(seconds: 1),
          backgroundColor: const Color(0xFF6366F1),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return true;
    }

    return false;
  }
}
