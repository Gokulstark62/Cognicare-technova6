import 'package:flutter_tts/flutter_tts.dart';

/// Wraps flutter_tts for app voice feedback.
/// Phase 5.5 — supports English and Tamil.
class TtsService {
  TtsService._();
  static final TtsService instance = TtsService._();

  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;
  String _language = 'en-US';

  Future<void> init() async {
    if (_initialized) return;
    await _tts.setLanguage(_language);
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    _initialized = true;
  }

  /// Set the TTS language: 'en-US' or 'ta-IN'.
  Future<void> setLanguage(String code) async {
    _language = code;
    await _tts.setLanguage(code);
  }

  Future<void> speak(String text) async {
    await init();
    await _tts.setLanguage(_language);
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}
