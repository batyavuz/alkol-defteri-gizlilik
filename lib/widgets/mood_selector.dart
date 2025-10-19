import 'package:flutter/material.dart';

import '../models/mood.dart';
import 'glass_container.dart';

/// Allows the user to select a mood by tapping an emoji chip.
class MoodSelector extends StatelessWidget {
  const MoodSelector({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final Mood selected;
  final ValueChanged<Mood> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final mood in Moods.values)
          GestureDetector(
            onTap: () => onChanged(mood),
            child: AnimatedScale(
              scale: selected == mood ? 1.05 : 1,
              duration: const Duration(milliseconds: 250),
              child: GlassContainer(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: selected == mood
                        ? mood.color.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(mood.emoji, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 8),
                      Text(
                        mood.label,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: selected == mood ? FontWeight.w600 : FontWeight.w400,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
