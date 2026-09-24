import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';
import 'home_screen.dart';
import 'games_screen.dart';
import 'tasks_screen.dart';
import 'family_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  void _switchTab(int newIndex) {
    setState(() => _index = newIndex);
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(onNavigateToTab: _switchTab),
      const GamesScreen(),
      const TasksScreen(),
      const FamilyScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: screens),
      // ⭐ Voice FAB — sits above the bottom nav
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/voice'),
        backgroundColor: AppTheme.primary,
        elevation: 6,
        icon: const Icon(Icons.mic, color: Colors.white, size: 26),
        label: Text(
          'Speak',
          style: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNav(currentIndex: _index, onTap: _switchTab),
    );
  }
}
