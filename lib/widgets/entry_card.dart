import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/journal_entry.dart';
import 'glass_container.dart';

/// Displays a journal entry summary with subtle animation.
class EntryCard extends StatelessWidget {
  const EntryCard({required this.entry, required this.onDelete, super.key});

  final JournalEntry entry;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat.yMMMEd('tr_TR').format(entry.date);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.8, end: 1),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutBack,
        builder: (context, value, child) => Transform.scale(scale: value, child: child),
        child: GlassContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    entry.mood.emoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dateLabel,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                              ),
                        ),
                        Text(
                          entry.mood.label,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.65),
                              ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded),
                    onPressed: onDelete,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                entry.summary,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
