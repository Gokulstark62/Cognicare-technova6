import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/brand_logo.dart';
import '../widgets/big_button.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                'Better Minds • Happier Families •\nTogether Always',
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
                label: 'Get Started',
                onPressed: () => context.go('/login'),
              ),
              const SizedBox(height: 12),
              BigButton(
                label: 'Continue with Google',
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