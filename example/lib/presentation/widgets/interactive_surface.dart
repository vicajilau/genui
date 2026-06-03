import 'dart:async';
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';

/// A helper widget that encapsulates all the boilerplate code required to run
/// and manage an interactive GenUI Surface.
///
/// It handles creating and disposing the [SurfaceController], subscribing to
/// [UserActionEvent]s, and sending [CreateSurface] / [UpdateComponents] updates
/// declaratively.
class InteractiveSurface extends StatefulWidget {
  final List<Component> components;
  final Catalog catalog;
  final String surfaceId;
  final String catalogId;
  final ValueChanged<String> onEvent;

  const InteractiveSurface({
    super.key,
    required this.components,
    required this.catalog,
    required this.onEvent,
    this.surfaceId = 'interactive_surface',
    this.catalogId = 'inline_catalog',
  });

  @override
  State<InteractiveSurface> createState() => _InteractiveSurfaceState();
}

class _InteractiveSurfaceState extends State<InteractiveSurface> {
  late final SurfaceController _controller;
  StreamSubscription? _eventSubscription;

  @override
  void initState() {
    super.initState();
    _controller = SurfaceController(catalogs: [widget.catalog]);

    // Initialize the surface in the controller
    _controller.handleMessage(
      CreateSurface(
        surfaceId: widget.surfaceId,
        catalogId: widget.catalogId,
        sendDataModel: false,
      ),
    );

    // Populate with the initial components
    _controller.handleMessage(
      UpdateComponents(
        surfaceId: widget.surfaceId,
        components: widget.components,
      ),
    );

    // Listen for UI interaction events
    _eventSubscription = _controller.onSubmit.listen((ChatMessage message) {
      for (final part in message.parts.uiInteractionParts) {
        widget.onEvent(part.interaction);
      }
    });
  }

  @override
  void didUpdateWidget(covariant InteractiveSurface oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Whenever components are updated declaratively by the parent, send an UpdateComponents message
    if (widget.components != oldWidget.components ||
        widget.surfaceId != oldWidget.surfaceId) {
      _controller.handleMessage(
        UpdateComponents(
          surfaceId: widget.surfaceId,
          components: widget.components,
        ),
      );
    }
  }

  @override
  void dispose() {
    _eventSubscription?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Surface(surfaceContext: _controller.contextFor(widget.surfaceId));
  }
}
