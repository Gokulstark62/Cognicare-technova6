import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global controller for the app's locale.
/// Persists the choice to disk via shared_preferences.
class LocaleController {
  LocaleController._();
  static final LocaleController instance = LocaleController._();

  static const String _key = 'app_locale';

  /// Current locale. Default is English.
  final ValueNotifier<Locale> locale =
      ValueNotifier<Locale>(const Locale('en'));

  /// Load the saved locale from disk. Call this once at app startup.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key) ?? 'en';
    locale.value = Locale(code);
  }

  /// Change the locale and save to disk.
  Future<void> setLocale(String languageCode) async {
    locale.value = Locale(languageCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, languageCode);
  }

  bool get isEnglish => locale.value.languageCode == 'en';
  bool get isTamil => locale.value.languageCode == 'ta';
}