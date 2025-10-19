import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/journal_entry.dart';
import '../models/mood.dart';
import 'settings_service.dart';

/// Manages persistence and business logic for journal entries.
class JournalService extends ChangeNotifier {
  static const _storageKey = 'mindmirror_entries';

  final List<JournalEntry> _entries = [];
  SettingsService? _settings;

  List<JournalEntry> get entries => List.unmodifiable(_entries);

  void updateSettings(SettingsService settings) {
    _settings = settings;
  }

  /// Loads persisted entries and keeps them sorted by date.
  Future<void> loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_storageKey) ?? [];
    _entries
      ..clear()
      ..addAll(stored.map(JournalEntry.fromJson))
      ..sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  /// Persists current state to preferences.
  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final payload = _entries.map((entry) => entry.toJson()).toList();
    await prefs.setStringList(_storageKey, payload);
    if (_settings?.backupEnabled == true) {
      // Bulut senkronizasyonu için ayırtılmış yer.
    }
  }

  /// Adds a new entry to the in-memory collection and persists changes.
  Future<void> addEntry(JournalEntry entry) async {
    _entries.insert(0, entry);
    await _save();
    notifyListeners();
  }

  /// Deletes an entry identified by [id].
  Future<void> removeEntry(String id) async {
    _entries.removeWhere((entry) => entry.id == id);
    await _save();
    notifyListeners();
  }

  /// Returns entries created within the last seven days.
  List<JournalEntry> recentEntries() {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    return _entries.where((entry) => entry.date.isAfter(weekAgo)).toList();
  }

  /// Aggregates mood counts by day to feed the stats chart.
  Map<String, Map<Mood, int>> weeklyMoodBreakdown() {
    final format = DateFormat('E', 'tr_TR');
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 6));
    final filtered = _entries.where((entry) => entry.date.isAfter(weekAgo));

    final result = <String, Map<Mood, int>>{};
    for (var i = 0; i < 7; i++) {
      final day = now.subtract(Duration(days: 6 - i));
      final label = format.format(day);
      result[label] = {for (final mood in Moods.values) mood: 0};
    }

    for (final entry in filtered) {
      final label = format.format(entry.date);
      result.putIfAbsent(label, () => {for (final mood in Moods.values) mood: 0});
      result[label]![entry.mood] = (result[label]![entry.mood] ?? 0) + 1;
    }
    return result;
  }
}
