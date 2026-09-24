import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../l10n/locale_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context).comingSoon(feature),
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

  void _showLanguagePicker(BuildContext context) {
    final controller = LocaleController.instance;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(sheetContext).chooseYourLanguage,
                  style: GoogleFonts.nunito(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _languageOption(
                  sheetContext,
                  controller,
                  'en',
                  'English',
                  'English',
                  '🇬🇧',
                ),
                _languageOption(
                  sheetContext,
                  controller,
                  'ta',
                  'Tamil',
                  'தமிழ்',
                  '🇮🇳',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _languageOption(
    BuildContext sheetContext,
    LocaleController controller,
    String code,
    String englishName,
    String nativeName,
    String flag,
  ) {
    final selected = controller.locale.value.languageCode == code;
    const color = AppTheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: selected ? color.withOpacity(0.12) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            controller.setLocale(code);
            Navigator.of(sheetContext).pop();
          },
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? color : const Color(0xFFCFD8DC),
                width: selected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: selected ? color : AppTheme.textSecondary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(flag, style: const TextStyle(fontSize: 26)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nativeName,
                        style: GoogleFonts.nunito(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        englishName,
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = LocaleController.instance;

    final items = [
      {
        'title': l10n.profile,
        'icon': Icons.person_outline,
        'trailing': l10n.userName,
        'action': 'profile',
      },
      {
        'title': l10n.language,
        'icon': Icons.language,
        'trailing': controller.isTamil ? 'தமிழ்' : 'English',
        'action': 'language',
      },
      {
        'title': l10n.notifications,
        'icon': Icons.notifications_outlined,
        'trailing': l10n.onLabel,
        'action': 'notifications',
      },
      {
        'title': l10n.textSize,
        'icon': Icons.text_fields,
        'trailing': l10n.largeLabel,
        'action': 'textsize',
      },
      {
        'title': l10n.voiceAssistant,
        'icon': Icons.mic_none,
        'trailing': l10n.offLabel,
        'action': 'voice',
      },
      {
        'title': l10n.helpSupport,
        'icon': Icons.help_outline,
        'trailing': '',
        'action': 'help',
      },
      {
        'title': l10n.aboutCogniCare,
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
        title: Text(l10n.settingsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
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
                    child: Icon(Icons.person,
                        color: AppTheme.primary, size: 36),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.userName,
                        style: GoogleFonts.nunito(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        l10n.userPhone,
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
                          _showLanguagePicker(context);
                        } else {
                          _showComingSoon(
                              context, item['title'] as String);
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
              l10n.logOut,
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