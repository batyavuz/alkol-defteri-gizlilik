import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/journal_entry.dart';
import '../models/mood.dart';
import '../services/journal_service.dart';
import '../widgets/glass_container.dart';
import '../widgets/mood_selector.dart';

/// Form allowing the user to create a new journal entry.
class NewEntryPage extends StatefulWidget {
  const NewEntryPage({super.key});

  @override
  State<NewEntryPage> createState() => _NewEntryPageState();
}

class _NewEntryPageState extends State<NewEntryPage> {
  final _controller = TextEditingController();
  Mood _selectedMood = Moods.calm;
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveEntry() async {
    final content = _controller.text.trim();
    if (content.isEmpty) return;
    setState(() => _saving = true);
    final entry = JournalEntry(
      id: const Uuid().v4(),
      date: DateTime.now(),
      content: content,
      moodEmoji: _selectedMood.emoji,
    );
    await context.read<JournalService>().addEntry(entry);
    if (!mounted) return;
    setState(() => _saving = false);
    _controller.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Girdi kaydedildi.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      children: [
        GlassContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bugün nasılsınız?',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                minLines: 6,
                maxLines: 12,
                decoration: const InputDecoration(
                  hintText: 'Duygularınızı ve düşüncelerinizi burada paylaşın...\nGününüzü neler güzelleştirdi?',
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  filled: true,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        GlassContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ruh hâlinizi seçin',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              MoodSelector(
                selected: _selectedMood,
                onChanged: (mood) => setState(() => _selectedMood = mood),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
            onPressed: _saving ? null : _saveEntry,
            icon: _saving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check_rounded),
            label: const Text('Kaydet'),
          ),
        ),
      ],
    );
  }
}
