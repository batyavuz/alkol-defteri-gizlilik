import 'package:flutter/material.dart';

/// Wraps content with a dreamy lavender gradient backdrop.
class GradientBackground extends StatelessWidget {
  const GradientBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.35),
            Theme.of(context).colorScheme.secondary.withOpacity(0.35),
            Theme.of(context).colorScheme.surface.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}
