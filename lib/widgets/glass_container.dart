import 'dart:ui';

import 'package:flutter/material.dart';

/// Applies a subtle blur and frosted effect to its child.
class GlassContainer extends StatelessWidget {
  const GlassContainer({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.surface.withOpacity(0.65),
                Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.35),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
              width: 1.2,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
