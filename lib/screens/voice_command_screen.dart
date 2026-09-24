import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import '../services/voice_service.dart';
import '../services/voice_command_parser.dart';
import '../services/tts_service.dart';
import '../services/status_service.dart';
import 'health/data/hydration_store.dart';

class VoiceCommandScreen extends StatefulWidget {
  const VoiceCommandScreen({super.key});

  @override
  State<VoiceCommandScreen> createState() => _VoiceCommandScreenState();
}

class _VoiceCommandScreenState extends State<VoiceCommandScreen>
    with SingleTickerProviderStateMixin {
  final _voice = VoiceService.instance;
  final _tts = TtsService.instance;
  final _status = StatusService.instance;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  String _transcript = '';
  String? _recognizedAction;
  bool _isListening = false;
  String? _errorMessage;

  String _langCode = 'en';
  bool get _isTamil => _langCode == 'ta';

  Timer? _autoTimer;
  int _autoSecondsLeft = 2;

  final List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.9, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _autoTimer?.cancel();
    _voice.cancel();
    _tts.stop();
    super.dispose();
  }

  void _toggleLanguage() {
    _cancelAutoExecute();
    _voice.cancel();
    setState(() {
      _langCode = _isTamil ? 'en' : 'ta';
      _transcript = '';
      _recognizedAction = null;
      _errorMessage = null;
    });
  }

  void _cancelAutoExecute() {
    _autoTimer?.cancel();
    _autoTimer = null;
    if (mounted) setState(() => _autoSecondsLeft = 2);
  }

  void _addToHistory(String text) {
    if (text.trim().isEmpty) return;
    _history.insert(0, text);
    if (_history.length > 5) _history.removeLast();
  }

  void _startAutoExecute(String actionKey) {
    _autoTimer?.cancel();
    _autoSecondsLeft = 2;

    _tts.speak(VoiceCommandParser.describeAction(actionKey, isTamil: _isTamil));

    _autoTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _autoSecondsLeft--);
      if (_autoSecondsLeft <= 0) {
        timer.cancel();
        await _executeAction(actionKey);
      }
    });
  }

  Future<void> _startListening() async {
    _cancelAutoExecute();
    setState(() {
      _errorMessage = null;
      _transcript = '';
      _recognizedAction = null;
    });

    await _tts.setLanguage(_isTamil ? 'ta-IN' : 'en-US');

    final ok = await _voice.init();
    if (!ok) {
      setState(() {
        _errorMessage = _isTamil
            ? 'மைக்ரோஃபோன் கிடைக்கவில்லை.'
            : 'Microphone not available. Please allow permission.';
      });
      return;
    }

    setState(() => _isListening = true);

    await _voice.startListening(
      localeId: _isTamil ? 'ta_IN' : 'en_US',
      onResult: (text, isFinal) {
        if (!mounted) return;
        setState(() {
          _transcript = text;
          _recognizedAction = VoiceCommandParser.parse(text);
          if (isFinal) {
            _isListening = false;
            _addToHistory(text);
          }
        });

        if (isFinal && _recognizedAction != null) {
          _startAutoExecute(_recognizedAction!);
        }
      },
    );
  }

  Future<void> _stopListening() async {
    await _voice.stop();
    setState(() => _isListening = false);
  }

  Future<void> _executeAction(String actionKey) async {
    _autoTimer?.cancel();
    _tts.stop();

    switch (actionKey) {
      case 'status_report':
        final msg = _isTamil
            ? await _status.buildTamil()
            : await _status.buildEnglish();
        _tts.speak(msg);
        setState(() {
          _transcript = msg;
          _recognizedAction = null;
        });
        return;

      case 'log_water':
        final glasses = VoiceCommandParser.extractGlasses(_transcript);
        HydrationStore.instance.addGlasses(glasses);
        final msg = _isTamil
            ? '$glasses கிளாஸ் தண்ணீர் பதிவு செய்யப்பட்டது'
            : 'Logged $glasses glasses of water';
        _tts.speak(msg);
        setState(() {
          _transcript = msg;
          _recognizedAction = null;
        });
        return;

      case 'open_medicine':
        context.go('/medicine');
        break;
      case 'open_hydration':
        context.go('/hydration');
        break;
      case 'open_routine':
        context.go('/routine');
        break;
      case 'open_appointments':
        context.go('/appointments');
        break;
      case 'open_games':
        context.go('/home');
        break;
      case 'open_settings':
        context.go('/settings');
        break;
      case 'go_home':
        context.go('/home');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _cancelAutoExecute();
            _voice.cancel();
            _tts.stop();
            context.go('/home');
          },
        ),
        title: const Text('Voice Command'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: GestureDetector(
                onTap: _toggleLanguage,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _isTamil ? 'தமிழ்' : 'EN',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.swap_horiz,
                        color: AppTheme.primary,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                _isListening
                    ? (_isTamil ? 'கேட்கிறது...' : 'Listening...')
                    : (_isTamil ? 'பேச தட்டவும்' : 'Tap to Speak'),
                style: GoogleFonts.nunito(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _isTamil
                    ? 'சொல்லுங்கள்: "நான் எப்படி இருக்கிறேன்?"'
                    : 'Try: "How am I doing?", "Log 2 glasses of water"',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _isListening ? _stopListening : _startListening,
                child: AnimatedBuilder(
                  animation: _pulseAnim,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _isListening ? _pulseAnim.value : 1.0,
                      child: child,
                    );
                  },
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isListening
                          ? AppTheme.pink.withOpacity(0.15)
                          : AppTheme.primary.withOpacity(0.12),
                      border: Border.all(
                        color: _isListening ? AppTheme.pink : AppTheme.primary,
                        width: 3,
                      ),
                    ),
                    child: Icon(
                      _isListening ? Icons.mic : Icons.mic_none,
                      size: 64,
                      color: _isListening ? AppTheme.pink : AppTheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_transcript.isNotEmpty || _errorMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _errorMessage != null
                          ? AppTheme.pink
                          : AppTheme.primary.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _errorMessage != null
                            ? (_isTamil ? 'பிழை' : 'Error')
                            : (_isTamil ? 'பதில்:' : 'Response:'),
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: _errorMessage != null
                              ? AppTheme.pink
                              : AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _errorMessage ?? _transcript,
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      if (_recognizedAction != null) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.green.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: AppTheme.green,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  '${VoiceCommandParser.describeAction(_recognizedAction!, isTamil: _isTamil)}...',
                                  style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.green,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_autoTimer != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppTheme.primary,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                _isTamil
                                    ? '$_autoSecondsLeft விநாடியில்...'
                                    : 'Auto-executing in $_autoSecondsLeft...',
                                style: GoogleFonts.nunito(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            if (_autoTimer != null)
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: _cancelAutoExecute,
                                  icon: const Icon(Icons.close, size: 20),
                                  label: Text(_isTamil ? 'ரத்து' : 'Cancel'),
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size(
                                      double.infinity,
                                      46,
                                    ),
                                    foregroundColor: AppTheme.textSecondary,
                                    side: const BorderSide(
                                      color: Color(0xFFCFD8DC),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            if (_autoTimer != null) const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    _executeAction(_recognizedAction!),
                                icon: const Icon(Icons.arrow_forward),
                                label: Text(_isTamil ? 'இப்போது' : 'Do it now'),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 46),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              const Spacer(),
              if (_history.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFCFD8DC)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isTamil ? 'சமீபத்திய கட்டளைகள்' : 'Recent',
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ..._history.map(
                        (h) => Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.history,
                                size: 14,
                                color: AppTheme.textSecondary,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  h,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.nunito(
                                    fontSize: 13,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isTamil ? 'சொல்லுங்கள்:' : 'Try saying:',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isTamil
                          ? '• "நான் எப்படி இருக்கிறேன்?"\n'
                                '• "2 கிளாஸ் தண்ணீர்"\n'
                                '• "மருந்து"\n'
                                '• "வழக்கம்"'
                          : '• "How am I doing?"\n'
                                '• "Log 2 glasses of water"\n'
                                '• "Add medicine"\n'
                                '• "Show my routine"',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        height: 1.5,
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
    );
  }
}
