import 'package:flutter/material.dart';

/// Describes available mood presets used across the application.
class Mood {
  const Mood({required this.label, required this.emoji, required this.color});

  final String label;
  final String emoji;
  final Color color;
}

/// Static mood catalog inspired by soothing lavender palette.
class Moods {
  static const calm = Mood(label: 'Sakin', emoji: '😌', color: Color(0xFFB48CFF));
  static const joyful = Mood(label: 'Neşeli', emoji: '😊', color: Color(0xFFFFB3D0));
  static const grateful = Mood(label: 'Minnettar', emoji: '🙏', color: Color(0xFFA3E2D0));
  static const reflective = Mood(label: 'Düşünceli', emoji: '🤔', color: Color(0xFF9EC5FF));
  static const tired = Mood(label: 'Yorgun', emoji: '🥱', color: Color(0xFFE8CFFF));
  static const overwhelmed = Mood(label: 'Bunalmış', emoji: '😵‍💫', color: Color(0xFFFFCFB0));

  /// Provides ordered list for iteration.
  static const values = [calm, joyful, grateful, reflective, tired, overwhelmed];

  /// Retrieves a mood by emoji signature.
  static Mood byEmoji(String emoji) {
    return values.firstWhere((mood) => mood.emoji == emoji, orElse: () => calm);
  }
}
