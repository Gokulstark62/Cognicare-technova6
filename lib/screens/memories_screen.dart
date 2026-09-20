import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class MemoriesScreen extends StatelessWidget {
  const MemoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final memories = [
      {'title': 'Diwali 2024', 'date': 'Nov 2024', 'icon': Icons.celebration_outlined},
      {'title': 'Family Trip', 'date': 'Aug 2024', 'icon': Icons.landscape_outlined},
      {'title': 'Birthday Party', 'date': 'Jun 2024', 'icon': Icons.cake_outlined},
      {'title': 'Anniversary', 'date': 'Mar 2024', 'icon': Icons.favorite_outline},
      {'title': 'Pongal Festival', 'date': 'Jan 2024', 'icon': Icons.wb_sunny_outlined},
      {'title': 'Beach Vacation', 'date': 'Dec 2023', 'icon': Icons.beach_access_outlined},
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        title: const Text('My Family Memories'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.pink.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.photo_library_outlined,
                      color: AppTheme.pink, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Cherish your favourite moments',
                      style: GoogleFonts.nunito(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: memories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.95,
              ),
              itemBuilder: (context, i) {
                final m = memories[i];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.pink.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(m['icon'] as IconData,
                            color: AppTheme.pink, size: 32),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        m['title'] as String,
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        m['date'] as String,
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}