import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final games = [
      _GameData(
        title: 'Memory Match',
        subtitle: 'Find matching pairs',
        level: 'Easy',
        levelColor: AppTheme.green,
        icon: Icons.grid_view_rounded,
        color: AppTheme.primary,
      ),
      _GameData(
        title: 'Word Builder',
        subtitle: 'Arrange letters to form words',
        level: 'Easy',
        levelColor: AppTheme.green,
        icon: Icons.abc_rounded,
        color: AppTheme.purple,
      ),
      _GameData(
        title: 'Picture Recognition',
        subtitle: 'Identify objects and places',
        level: 'Very Easy',
        levelColor: AppTheme.teal,
        icon: Icons.image_outlined,
        color: AppTheme.amber,
      ),
      _GameData(
        title: 'Number Sequence',
        subtitle: 'Remember the sequence',
        level: 'Medium',
        levelColor: AppTheme.orange,
        icon: Icons.looks_one_outlined,
        color: AppTheme.pink,
      ),
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.psychology_outlined,
                        color: AppTheme.primary, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Brain Games',
                          style: GoogleFonts.nunito(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Text(
                          'Exercise your mind. Have fun and keep your brain active!',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Game cards
              ...games.map((g) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _GameCard(data: g),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class _GameData {
  final String title;
  final String subtitle;
  final String level;
  final Color levelColor;
  final IconData icon;
  final Color color;

  _GameData({
    required this.title,
    required this.subtitle,
    required this.level,
    required this.levelColor,
    required this.icon,
    required this.color,
  });
}

class _GameCard extends StatelessWidget {
  final _GameData data;
  const _GameCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          // TODO: Phase 2 — navigate to actual game
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: data.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(data.icon, color: data.color, size: 30),
              ),
              const SizedBox(width: 16),

              // Title + subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data.subtitle,
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Difficulty badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: data.levelColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  data.level,
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: data.levelColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}