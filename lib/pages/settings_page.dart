import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../services/settings_service.dart';
import '../widgets/glass_container.dart';

/// Allows the user to adjust theme, typography and backup settings.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      children: [
        GlassContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Tema', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Consumer<SettingsService>(
                builder: (context, settings, _) => SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(value: ThemeMode.light, label: Text('Aydınlık'), icon: Icon(Icons.wb_sunny_outlined)),
                    ButtonSegment(value: ThemeMode.system, label: Text('Sistem'), icon: Icon(Icons.auto_mode_rounded)),
                    ButtonSegment(value: ThemeMode.dark, label: Text('Gece'), icon: Icon(Icons.nightlight_round)),
                  ],
                  selected: {settings.themeMode},
                  onSelectionChanged: (value) {
                    settings.updateTheme(value.first);
                  },
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
              Text('Yazı Boyutu', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Consumer<SettingsService>(
                builder: (context, settings, _) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Slider(
                      value: settings.fontScale,
                      min: 0.9,
                      max: 1.4,
                      divisions: 5,
                      label: settings.fontScale.toStringAsFixed(1),
                      onChanged: (value) {
                        settings.updateFontScale(value);
                      },
                    ),
                    Text(
                      'Metinler ${settings.fontScale.toStringAsFixed(1)}x ölçekleniyor.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        GlassContainer(
          child: Consumer<SettingsService>(
            builder: (context, settings, _) => SwitchListTile.adaptive(
              title: const Text('Verilerimi yedekle (Mock)'),
              subtitle: const Text('Yakında Firebase/Firestore entegrasyonu ile aktif olacak.'),
              value: settings.backupEnabled,
              onChanged: (value) {
                settings.updateBackup(value);
              },
            ),
          ),
        ),
        const SizedBox(height: 24),
        GlassContainer(
          child: Consumer<AuthService>(
            builder: (context, auth, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hesabım', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text('Merhaba ${auth.username}', style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: auth.logout,
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Çıkış yap'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
