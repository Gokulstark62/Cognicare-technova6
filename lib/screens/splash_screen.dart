import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../widgets/brand_logo.dart';
import '../widgets/big_button.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              const Spacer(),
              const BrandLogo(size: 70),
              const SizedBox(height: 16),
              Text(
                l10n.taglineLong,
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                height: 220,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(
                  child: Icon(
                    Icons.family_restroom,
                    size: 120,
                    color: AppTheme.primary,
                  ),
                ),
              ),
              const Spacer(),
              BigButton(
                label: l10n.getStarted,
                onPressed: () => context.go('/login'),
              ),
              const SizedBox(height: 12),
              BigButton(
                label: l10n.continueWithGoogle,
                icon: Icons.g_mobiledata,
                outlined: true,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}