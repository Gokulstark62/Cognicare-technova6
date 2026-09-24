import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'l10n/locale_controller.dart';
import 'screens/health/data/medicine_store.dart';
import 'screens/health/data/hydration_store.dart';
import 'screens/health/data/routine_store.dart';
import 'screens/health/data/appointment_store.dart';
import 'screens/games/difficulty_store.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/language_screen.dart';
import 'screens/main_shell.dart';
import 'screens/memories_screen.dart';
import 'screens/wellness_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/nlp_test_screen.dart';
import 'screens/voice_command_screen.dart';
import 'screens/games/memory_match_screen.dart';
import 'screens/games/word_builder_screen.dart';
import 'screens/games/picture_recognition_screen.dart';
import 'screens/games/number_sequence_screen.dart';
import 'screens/health/medicine_screen.dart';
import 'screens/health/add_edit_medicine_screen.dart';
import 'screens/health/hydration_screen.dart';
import 'screens/health/routine_screen.dart';
import 'screens/health/add_edit_routine_screen.dart';
import 'screens/health/appointments_screen.dart';
import 'screens/health/add_edit_appointment_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocaleController.instance.load();
  await MedicineStore.instance.load();
  await HydrationStore.instance.load();
  await RoutineStore.instance.load();
  await AppointmentStore.instance.load();
  await DifficultyStore.instance.load();
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
      path: '/nlp-test',
      builder: (context, state) => const NlpTestScreen(),
    ),
    GoRoute(
      path: '/voice',
      builder: (context, state) => const VoiceCommandScreen(),
    ),
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
    GoRoute(
      path: '/medicine',
      builder: (context, state) => const MedicineScreen(),
    ),
    GoRoute(
      path: '/medicine/add',
      builder: (context, state) => const AddEditMedicineScreen(),
    ),
    GoRoute(
      path: '/medicine/edit/:id',
      builder: (context, state) =>
          AddEditMedicineScreen(medicineId: state.pathParameters['id']),
    ),
    GoRoute(
      path: '/hydration',
      builder: (context, state) => const HydrationScreen(),
    ),
    GoRoute(
      path: '/routine',
      builder: (context, state) => const RoutineScreen(),
    ),
    GoRoute(
      path: '/routine/add',
      builder: (context, state) => const AddEditRoutineScreen(),
    ),
    GoRoute(
      path: '/routine/edit/:id',
      builder: (context, state) =>
          AddEditRoutineScreen(activityId: state.pathParameters['id']),
    ),
    GoRoute(
      path: '/appointments',
      builder: (context, state) => const AppointmentsScreen(),
    ),
    GoRoute(
      path: '/appointments/add',
      builder: (context, state) => const AddEditAppointmentScreen(),
    ),
    GoRoute(
      path: '/appointments/edit/:id',
      builder: (context, state) => AddEditAppointmentScreen(
          appointmentId: state.pathParameters['id']),
    ),
  ],
);

class ElderCareApp extends StatelessWidget {
  const ElderCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = LocaleController.instance;

    return ValueListenableBuilder<Locale>(
      valueListenable: localeController.locale,
      builder: (context, locale, _) {
        return MaterialApp.router(
          title: 'CogniCare',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          routerConfig: _router,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        );
      },
    );
  }
}