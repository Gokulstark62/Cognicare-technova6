import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
        route: '/memory-match',
      ),
      _GameData(
        title: 'Word Builder',
        subtitle: 'Arrange letters to form words',
        level: 'Easy',
        levelColor: AppTheme.green,
        icon: Icons.abc_rounded,
        color: AppTheme.purple,
        route: '',
      ),
      _GameData(
        title: 'Picture Recognition',
        subtitle: 'Identify objects and places',
        level: 'Very Easy',
        levelColor: AppTheme.teal,
        icon: Icons.image_outlined,
        color: AppTheme.amber,
        route: '',
      ),
      _GameData(
        title: 'Number Sequence',
        subtitle: 'Remember the sequence',
        level: 'Medium',
        levelColor: AppTheme.orange,
        icon: Icons.looks_one_outlined,
        color: AppTheme.pink,
        route: '',
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
              ...games.map((g) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _GameCard(
                      data: g,
                      onTap: () {
                        if (g.route.isNotEmpty) {
                          context.push(g.route);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${g.title} — Coming soon'),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                    ),
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
  final String route;

  _GameData({
    required this.title,
    required this.subtitle,
    required this.level,
    required this.levelColor,
    required this.icon,
    required this.color,
    required this.route,
  });
}

class _GameCard extends StatelessWidget {
  final _GameData data;
  final VoidCallback onTap;

  const _GameCard({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
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
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: data.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(data.icon, color: data.color, size: 30),
              ),
              const SizedBox(width: 16),
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