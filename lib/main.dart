import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/language_screen.dart';
import 'screens/main_shell.dart';
import 'screens/memories_screen.dart';
import 'screens/wellness_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/games/memory_match_screen.dart';
import 'screens/games/word_builder_screen.dart';
import 'screens/games/picture_recognition_screen.dart';
import 'screens/games/number_sequence_screen.dart';

void main() {
  runApp(const ElderCareApp());
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
    GoRoute(
        path: '/language',
        builder: (context, state) => const LanguageScreen()),
    GoRoute(path: '/home', builder: (context, state) => const MainShell()),
    GoRoute(
        path: '/memories',
        builder: (context, state) => const MemoriesScreen()),
    GoRoute(
        path: '/wellness',
        builder: (context, state) => const WellnessScreen()),
    GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen()),
    GoRoute(
      path: '/memory-match',
      builder: (context, state) => const MemoryMatchScreen(),
    ),
    GoRoute(
      path: '/word-builder',
      builder: (context, state) => const WordBuilderScreen(),
    ),
    GoRoute(
      path: '/picture-recognition',
      builder: (context, state) => const PictureRecognitionScreen(),
    ),
    GoRoute(
      path: '/number-sequence',
      builder: (context, state) => const NumberSequenceScreen(),
    ),
  ],
);

class ElderCareApp extends StatelessWidget {
  const ElderCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CogniCare',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: _router,
    );
  }
}