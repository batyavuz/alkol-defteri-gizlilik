import 'dart:math';

import '../models/journal_entry.dart';
import '../models/mood.dart';

/// Mocks a meaningful AI insight derived from recent entries.
class AiService {
  static const _insights = [
    'Rutin oluşturma isteğiniz güçlü, sabah kısa nefes çalışmaları deneyin.',
    'Minnettarlık cümleleri ruh hâlinizi dengeliyor, bunu haftalık alışkanlık haline getirin.',
    'Yaratıcı ifade günlerinizde enerji yükseliyor; yazı veya çizim için alan açın.',
    'Yorgun hissettiğiniz günlerde uyku hijyenini güçlendirecek hafif esnemeler öneriyoruz.',
    'Sosyal paylaşımlarınız gülümsemenizi artırıyor, sevdiğiniz kişilerle kahve molası verin.',
  ];

  /// Generates a pseudo insight mixing entry count and dominant mood.
  Future<String> generateInsight(List<JournalEntry> entries) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (entries.isEmpty) {
      return 'Bu hafta için henüz girdi yok. Duygularınızı paylaşmak için MindMirror sizi bekliyor.';
    }

    final moodCount = <Mood, int>{for (final mood in Moods.values) mood: 0};
    for (final entry in entries) {
      final mood = entry.mood;
      moodCount[mood] = (moodCount[mood] ?? 0) + 1;
    }

    final dominant = moodCount.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
    final base = _insights[Random().nextInt(_insights.length)];

    return 'Son 7 günde \"${dominant.label}\" hissi öne çıkıyor. $base';
  }
}
