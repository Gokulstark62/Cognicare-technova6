import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class WellnessScreen extends StatelessWidget {
  const WellnessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = [
      {
        'title': 'Deep Breathing',
        'subtitle': '5 minutes • Calm your mind',
        'icon': Icons.air,
        'color': AppTheme.primary,
      },
      {
        'title': 'Gentle Stretching',
        'subtitle': '10 minutes • Loosen up',
        'icon': Icons.self_improvement,
        'color': AppTheme.green,
      },
      {
        'title': 'Meditation',
        'subtitle': '15 minutes • Inner peace',
        'icon': Icons.spa_outlined,
        'color': AppTheme.purple,
      },
      {
        'title': 'Sleep Sounds',
        'subtitle': 'Relaxing music',
        'icon': Icons.nightlight_outlined,
        'color': AppTheme.textSecondary,
      },
      {
        'title': 'Mood Check',
        'subtitle': 'How are you feeling today?',
        'icon': Icons.sentiment_satisfied_alt,
        'color': AppTheme.amber,
      },
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        title: const Text('Wellness & Relax'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: activities.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, i) {
          final a = activities[i];
          final color = a['color'] as Color;
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
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
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(a['icon'] as IconData, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        a['title'] as String,
                        style: GoogleFonts.nunito(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        a['subtitle'] as String,
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right,
                    color: AppTheme.textSecondary),
              ],
            ),
          );
        },
      ),
    );
  }
}