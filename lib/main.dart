import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/ai_service.dart';
import 'services/auth_service.dart';
import 'services/journal_service.dart';
import 'services/settings_service.dart';
import 'theme/app_theme.dart';
import 'widgets/animated_app_bar.dart';
import 'widgets/gradient_background.dart';
import 'pages/ai_insights_page.dart';
import 'pages/home_page.dart';
import 'pages/new_entry_page.dart';
import 'pages/onboarding_page.dart';
import 'pages/settings_page.dart';
import 'pages/stats_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MindMirrorApp());
}

/// Root widget responsible for bootstrapping providers and theming.
class MindMirrorApp extends StatelessWidget {
  const MindMirrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()..loadUser()),
        ChangeNotifierProvider(create: (_) => SettingsService()..loadPreferences()),
        ChangeNotifierProxyProvider<SettingsService, JournalService>(
          create: (_) => JournalService()..loadEntries(),
          update: (_, settings, journal) =>
              (journal ?? JournalService())..updateSettings(settings)..loadEntries(),
        ),
        Provider(create: (_) => AiService()),
      ],
      child: Consumer<SettingsService>(
        builder: (context, settings, _) {
          final themeData = AppTheme.buildTheme(settings);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MindMirror',
            theme: themeData.lightTheme,
            darkTheme: themeData.darkTheme,
            themeMode: settings.themeMode,
            home: const _MindMirrorNavigator(),
          );
        },
      ),
    );
  }
}

/// Navigator widget controlling onboarding flow and the main shell.
class _MindMirrorNavigator extends StatelessWidget {
  const _MindMirrorNavigator();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    if (!auth.isAuthenticated) {
      return const OnboardingPage();
    }
    return const _MindMirrorShell();
  }
}

/// Main shell with bottom navigation and animated switching.
class _MindMirrorShell extends StatefulWidget {
  const _MindMirrorShell();

  @override
  State<_MindMirrorShell> createState() => _MindMirrorShellState();
}

class _MindMirrorShellState extends State<_MindMirrorShell> with TickerProviderStateMixin {
  int _index = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = <_ShellPageConfig>[
      _ShellPageConfig(
        title: 'Günlük',
        subtitle: 'Ruh hâlinizi keşfedin',
        icon: Icons.auto_stories_rounded,
        builder: () => const HomePage(),
      ),
      _ShellPageConfig(
        title: 'Yeni Girdi',
        subtitle: 'Kendinize zaman ayırın',
        icon: Icons.edit_note_rounded,
        builder: () => const NewEntryPage(),
      ),
      _ShellPageConfig(
        title: 'İstatistik',
        subtitle: 'Haftalık ruh grafiği',
        icon: Icons.area_chart_rounded,
        builder: () => const StatsPage(),
      ),
      _ShellPageConfig(
        title: 'AI İçgörüsü',
        subtitle: 'MindMirror önerileri',
        icon: Icons.auto_awesome_rounded,
        builder: () => const AiInsightsPage(),
      ),
      _ShellPageConfig(
        title: 'Ayarlar',
        subtitle: 'Deneyimi kişiselleştirin',
        icon: Icons.settings_rounded,
        builder: () => const SettingsPage(),
      ),
    ];

    final config = pages[_index];

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: AnimatedAppBar(
            title: config.title,
            subtitle: config.subtitle,
            icon: config.icon,
          ),
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: pages.length,
          onPageChanged: (value) => setState(() => _index = value),
          itemBuilder: (_, pageIndex) => AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              child: child,
            ),
            child: KeyedSubtree(
              key: ValueKey(pageIndex),
              child: pages[pageIndex].builder(),
            ),
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          height: 70,
          animationDuration: const Duration(milliseconds: 600),
          onDestinationSelected: (value) {
            setState(() => _index = value);
            _pageController.animateToPage(
              value,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOutCubic,
            );
          },
          destinations: [
            for (final page in pages)
              NavigationDestination(
                icon: Icon(page.icon),
                label: page.title,
              ),
          ],
        ),
        extendBody: true,
      ),
    );
  }
}

/// Data structure describing each shell tab.
class _ShellPageConfig {
  const _ShellPageConfig({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.builder,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget Function() builder;
}
