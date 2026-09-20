import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

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
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      backgroundColor: Colors.white,
      indicatorColor: AppTheme.primary.withOpacity(0.15),
      height: 72,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined, size: 26),
          selectedIcon: Icon(Icons.home, size: 26, color: AppTheme.primary),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.games_outlined, size: 26),
          selectedIcon: Icon(Icons.games, size: 26, color: AppTheme.primary),
          label: 'Games',
        ),
        NavigationDestination(
          icon: Icon(Icons.task_alt_outlined, size: 26),
          selectedIcon:
              Icon(Icons.task_alt, size: 26, color: AppTheme.primary),
          label: 'Tasks',
        ),
        NavigationDestination(
          icon: Icon(Icons.family_restroom_outlined, size: 26),
          selectedIcon:
              Icon(Icons.family_restroom, size: 26, color: AppTheme.primary),
          label: 'Family',
        ),
      ],
    );
  }
}