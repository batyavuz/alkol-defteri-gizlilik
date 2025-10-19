import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/ai_service.dart';
import '../services/journal_service.dart';
import '../widgets/glass_container.dart';

/// Presents mock AI insights derived from recent entries.
class AiInsightsPage extends StatefulWidget {
  const AiInsightsPage({super.key});

  @override
  State<AiInsightsPage> createState() => _AiInsightsPageState();
}

class _AiInsightsPageState extends State<AiInsightsPage> {
  String? _insight;
  bool _loading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadInsight();
  }

  Future<void> _loadInsight() async {
    setState(() => _loading = true);
    final entries = context.read<JournalService>().recentEntries();
    final insight = await context.read<AiService>().generateInsight(entries);
    if (!mounted) return;
    setState(() {
      _insight = insight;
      _loading = false;
    });
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
              Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                      ),
                    ),
                    child: const Icon(Icons.auto_awesome_rounded, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'MindMirror AI',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 400),
                crossFadeState: _loading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                firstChild: const Center(child: CircularProgressIndicator()),
                secondChild: Text(
                  _insight ?? 'İçgörü yüklenemedi. Tekrar deneyin.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _loading ? null : _loadInsight,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Yeni içgörü oluştur'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
