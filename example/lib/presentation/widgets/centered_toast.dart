// Copyright 2025 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

/// A static helper class to trigger premium, centered toast notifications
/// on top of the current screen using Flutter's Overlay system.
class CenteredToast {
  /// Displays a centered, animated notification overlay.
  static void show(
    BuildContext context, {
    required String message,
    required bool isSuccess,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => _CenteredToastWidget(
        message: message,
        isSuccess: isSuccess,
        onDismiss: () {
          entry.remove();
        },
      ),
    );
    overlay.insert(entry);
  }
}

/// The internal widget that manages pop-in/pop-out scale and fade transitions.
class _CenteredToastWidget extends StatefulWidget {
  final String message;
  final bool isSuccess;
  final VoidCallback onDismiss;

  const _CenteredToastWidget({
    required this.message,
    required this.isSuccess,
    required this.onDismiss,
  });

  @override
  State<_CenteredToastWidget> createState() => _CenteredToastWidgetState();
}

class _CenteredToastWidgetState extends State<_CenteredToastWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );

    _animController.forward();

    // Start dismiss animation after 1.2 seconds
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        _animController.reverse().then((_) {
          widget.onDismiss();
        });
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _animController,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.scale(scale: _scaleAnimation.value, child: child),
          );
        },
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            margin: const EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B), // Slate 800
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF6366F1).withValues(alpha: 0.4),
                width: 1.5,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.isSuccess
                      ? Icons.check_circle_outline_rounded
                      : Icons.delete_sweep_rounded,
                  color: widget.isSuccess
                      ? const Color(0xFF34D399) // Emerald 400
                      : const Color(0xFFF87171), // Red 400
                  size: 20,
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    widget.message,
                    style: const TextStyle(
                      color: Color(0xFFF1F5F9), // Slate 100
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
