import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      backgroundColor: Colors.white,
      indicatorColor: AppTheme.primary.withOpacity(0.15),
      height: 72,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.home_outlined, size: 26),
          selectedIcon:
              const Icon(Icons.home, size: 26, color: AppTheme.primary),
          label: l10n.homeTitle,
        ),
        NavigationDestination(
          icon: const Icon(Icons.games_outlined, size: 26),
          selectedIcon:
              const Icon(Icons.games, size: 26, color: AppTheme.primary),
          label: l10n.gamesTitle,
        ),
        NavigationDestination(
          icon: const Icon(Icons.task_alt_outlined, size: 26),
          selectedIcon:
              const Icon(Icons.task_alt, size: 26, color: AppTheme.primary),
          label: l10n.tasksTitle,
        ),
        NavigationDestination(
          icon: const Icon(Icons.family_restroom_outlined, size: 26),
          selectedIcon: const Icon(Icons.family_restroom,
              size: 26, color: AppTheme.primary),
          label: l10n.familyTitle,
        ),
      ],
    );
  }
}