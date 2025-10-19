import 'dart:convert';

import 'mood.dart';

/// Represents a single journal entry with supporting metadata.
class JournalEntry {
  JournalEntry({
    required this.id,
    required this.date,
    required this.content,
    required this.moodEmoji,
  });

  final String id;
  final DateTime date;
  final String content;
  final String moodEmoji;

  /// Convenience getter returning the first line as summary.
  String get summary {
    final sanitized = content.trim();
    if (sanitized.isEmpty) {
      return 'Boş girdi';
    }
    return sanitized.split('\n').first;
  }

  /// Returns the resolved [Mood] model from the emoji.
  Mood get mood => Moods.byEmoji(moodEmoji);

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date.toIso8601String(),
        'content': content,
        'moodEmoji': moodEmoji,
      };

  static JournalEntry fromMap(Map<String, dynamic> map) => JournalEntry(
        id: map['id'] as String,
        date: DateTime.parse(map['date'] as String),
        content: map['content'] as String,
        moodEmoji: map['moodEmoji'] as String,
      );

  /// Serializes to JSON string for persistence convenience.
  String toJson() => jsonEncode(toMap());

  /// Deserializes from JSON string to [JournalEntry].
  static JournalEntry fromJson(String source) =>
      JournalEntry.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
