import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Wraps speech_to_text with a simple API.
/// Phase 5.2 — captures speech and returns the transcript.
class VoiceService {
  VoiceService._();
  static final VoiceService instance = VoiceService._();

  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _initialized = false;
  bool _isListening = false;

  bool get isListening => _isListening;
  bool get isAvailable => _speech.isAvailable;

  /// Initialize speech recognition. Returns true if successful.
  Future<bool> init() async {
    if (_initialized) return true;
    try {
      final available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            _isListening = false;
          }
        },
        onError: (error) {
          _isListening = false;
        },
      );
      _initialized = available;
      return available;
    } catch (e) {
      _initialized = false;
      return false;
    }
  }

  /// Start listening. [onResult] is called with the transcript so far.
  Future<void> startListening({
    required void Function(String text, bool isFinal) onResult,
    String localeId = 'en_US',
  }) async {
    if (!_initialized) {
      final ok = await init();
      if (!ok) {
        onResult('', true);
        return;
      }
    }
    if (_isListening) return;

    _isListening = true;
    await _speech.listen(
      localeId: localeId,
      onResult: (result) {
        onResult(result.recognizedWords, result.finalResult);
        if (result.finalResult) {
          _isListening = false;
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 5),
      partialResults: true,
      cancelOnError: true,
    );
  }

  /// Stop listening.
  Future<void> stop() async {
    await _speech.stop();
    _isListening = false;
  }

  /// Cancel listening.
  Future<void> cancel() async {
    await _speech.cancel();
    _isListening = false;
  }

  /// Check what locales are supported.
  Future<List<stt.LocaleName>> locales() async {
    return await _speech.locales();
  }
}
