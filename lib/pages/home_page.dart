import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/journal_service.dart';
import '../widgets/entry_card.dart';
import '../widgets/glass_container.dart';

/// Displays the list of saved journal entries.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<JournalService>(
      builder: (context, journal, _) {
        final entries = journal.entries;
        if (entries.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: GlassContainer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.auto_stories_rounded,
                      size: 56, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(
                    'İlk yansımanızı ekleyin',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Günlük girişi ekleyerek duygularınızı MindMirror ile keşfedin.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            return EntryCard(
              entry: entry,
              onDelete: () => journal.removeEntry(entry.id),
            );
          },
        );
      },
    );
  }
}
