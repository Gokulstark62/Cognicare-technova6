import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$feature — Coming in a later phase',
          style: GoogleFonts.nunito(fontSize: 15),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'title': 'Profile',
        'icon': Icons.person_outline,
        'trailing': 'Ramesh',
        'action': 'profile',
      },
      {
        'title': 'Language',
        'icon': Icons.language,
        'trailing': 'English',
        'action': 'language',
      },
      {
        'title': 'Notifications',
        'icon': Icons.notifications_outlined,
        'trailing': 'On',
        'action': 'notifications',
      },
      {
        'title': 'Text Size',
        'icon': Icons.text_fields,
        'trailing': 'Large',
        'action': 'textsize',
      },
      {
        'title': 'Voice Assistant',
        'icon': Icons.mic_none,
        'trailing': 'Off',
        'action': 'voice',
      },
      {
        'title': 'Help & Support',
        'icon': Icons.help_outline,
        'trailing': '',
        'action': 'help',
      },
      {
        'title': 'About CogniCare',
        'icon': Icons.info_outline,
        'trailing': 'v1.0.0',
        'action': 'about',
      },
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Profile card
          Container(
            padding: const EdgeInsets.all(20),
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
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.primary, width: 2),
                  ),
                  child: const Center(
                    child:
                        Icon(Icons.person, color: AppTheme.primary, size: 36),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ramesh Kumar',
                        style: GoogleFonts.nunito(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        '+91 98765 43210',
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
          ),
          const SizedBox(height: 20),

          // Settings list
          Container(
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
              children: List.generate(items.length, (i) {
                final item = items[i];
                return Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      leading: Icon(item['icon'] as IconData,
                          color: AppTheme.primary, size: 26),
                      title: Text(
                        item['title'] as String,
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if ((item['trailing'] as String).isNotEmpty)
                            Text(
                              item['trailing'] as String,
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          const SizedBox(width: 6),
                          const Icon(Icons.chevron_right,
                              color: AppTheme.textSecondary),
                        ],
                      ),
                      onTap: () {
                        if (item['action'] == 'language') {
                          context.push('/language');
                        } else {
                          _showComingSoon(context, item['title'] as String);
                        }
                      },
                    ),
                    if (i < items.length - 1)
                      const Divider(height: 1, indent: 60),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 20),

          // Logout
          TextButton(
            onPressed: () => context.go('/login'),
            style: TextButton.styleFrom(
              minimumSize: const Size(double.infinity, 54),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: Color(0xFFCFD8DC)),
              ),
            ),
            child: Text(
              'Logout',
              style: GoogleFonts.nunito(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.redAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}