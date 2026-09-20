import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import 'difficulty_store.dart';

class WordBuilderScreen extends StatefulWidget {
  const WordBuilderScreen({super.key});

  @override
  State<WordBuilderScreen> createState() => _WordBuilderScreenState();
}

class _WordBuilderScreenState extends State<WordBuilderScreen> {
  final _store = DifficultyStore.instance;
  final _random = Random();

  String _targetWord = '';
  List<String> _scrambled = [];
  List<String?> _answer = [];
  List<bool> _used = [];

  int _attempts = 0;
  int _seconds = 0;
  Timer? _timer;
  bool _winShown = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _newRound();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _newRound() {
    _timer?.cancel();
    _timer = null;

    final pool = _store.wordPool;
    final word = pool[_random.nextInt(pool.length)];

    final letters = word.split('');
    List<String> scrambled;
    do {
      scrambled = List<String>.from(letters)..shuffle(_random);
    } while (scrambled.join() == word && letters.length > 1);

    setState(() {
      _targetWord = word;
      _scrambled = scrambled;
      _answer = List<String?>.filled(word.length, null);
      _used = List<bool>.filled(scrambled.length, false);
      _attempts = 0;
      _seconds = 0;
      _winShown = false;
      _busy = false;
    });

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _seconds++);
    });
  }

  void _onPoolTap(int i) {
    if (_busy || _used[i]) return;

    final slot = _answer.indexOf(null);
    if (slot == -1) return;

    setState(() {
      _answer[slot] = _scrambled[i];
      _used[i] = true;
    });

    if (!_answer.contains(null)) {
      _checkAnswer();
    }
  }

  void _onAnswerTap(int slot) {
    if (_busy) return;
    final letter = _answer[slot];
    if (letter == null) return;

    setState(() {
      _answer[slot] = null;
      // Free the first used pool tile matching this letter
      for (int i = 0; i < _scrambled.length; i++) {
        if (_used[i] && _scrambled[i] == letter) {
          _used[i] = false;
          break;
        }
      }
    });
  }

  void _clearAnswer() {
    if (_busy) return;
    setState(() {
      _answer = List<String?>.filled(_targetWord.length, null);
      _used = List<bool>.filled(_scrambled.length, false);
    });
  }

  void _checkAnswer() {
    final guess = _answer.join();
    if (guess == _targetWord) {
      _timer?.cancel();
      _busy = true;
      Timer(const Duration(milliseconds: 400), _onCorrect);
    } else {
      setState(() {
        _attempts++;
        _busy = true;
      });
      Timer(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        setState(() {
          _answer = List<String?>.filled(_targetWord.length, null);
          _used = List<bool>.filled(_scrambled.length, false);
          _busy = false;
        });
      });
    }
  }

  void _onCorrect() {
    if (!mounted) return;
    if (_winShown) return;
    _winShown = true;

    final change = _store.adjustWordBuilder(
      attempts: _attempts,
      seconds: _seconds,
    );

    _showWinDialog(change);
  }

  void _showWinDialog(String change) {
    if (!mounted) return;

    String? changeMessage;
    Color changeColor = AppTheme.primary;
    IconData? changeIcon;

    if (change == 'up') {
      changeMessage = 'Great job! Level up!';
      changeColor = AppTheme.green;
      changeIcon = Icons.arrow_upward;
    } else if (change == 'down') {
      changeMessage = "Let's try an easier level";
      changeColor = AppTheme.amber;
      changeIcon = Icons.arrow_downward;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.green.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.celebration,
                      color: AppTheme.green, size: 56),
                ),
                const SizedBox(height: 16),
                Text(
                  'Correct!',
                  style: GoogleFonts.nunito(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'You built: $_targetWord',
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),

                if (changeMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: changeColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(changeIcon, color: changeColor, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          changeMessage,
                          style: GoogleFonts.nunito(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: changeColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                Row(
                  children: [
                    _WinStat(
                      label: 'Attempts',
                      value: '$_attempts',
                      icon: Icons.refresh,
                      color: AppTheme.primary,
                    ),
                    _WinStat(
                      label: 'Time',
                      value: _formattedTime,
                      icon: Icons.timer_outlined,
                      color: AppTheme.amber,
                    ),
                    _WinStat(
                      label: 'Level',
                      value: _store.wordBuilderLevelName,
                      icon: Icons.star_outline,
                      color: AppTheme.green,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      _newRound();
                    },
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Next Word'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      context.go('/home');
                    },
                    icon: const Icon(Icons.home_outlined),
                    label: const Text('Back to Home'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 58),
                      side: const BorderSide(color: Color(0xFFCFD8DC)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLevelPicker() {
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
                  'Choose Difficulty',
                  style: GoogleFonts.nunito(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _levelOption(sheetContext, 0, 'Easy', 'Short words (3 letters)',
                    AppTheme.green),
                _levelOption(
                    sheetContext, 1, 'Medium', 'Medium words (5 letters)',
                    AppTheme.amber),
                _levelOption(sheetContext, 2, 'Hard', 'Long words (7+ letters)',
                    AppTheme.pink),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _levelOption(
    BuildContext sheetContext,
    int level,
    String name,
    String subtitle,
    Color color,
  ) {
    final selected = _store.wordBuilderLevel == level;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: selected ? color.withOpacity(0.12) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            _store.setWordBuilderLevel(level);
            Navigator.of(sheetContext).pop();
            _newRound();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.nunito(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        subtitle,
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

  String get _formattedTime {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        title: const Text('Word Builder'),
        actions: [
          Center(
            child: GestureDetector(
              onTap: _showLevelPicker,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _store.wordBuilderLevelName,
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_drop_down,
                        color: AppTheme.primary, size: 20),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _newRound,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.purple.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.abc_rounded,
                        color: AppTheme.purple, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Build the Word',
                          style: GoogleFonts.nunito(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Text(
                          'Tap letters to arrange them',
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
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
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
                    _StatBox(
                      icon: Icons.refresh,
                      label: 'Attempts',
                      value: '$_attempts',
                      color: AppTheme.primary,
                    ),
                    _StatDivider(),
                    _StatBox(
                      icon: Icons.timer_outlined,
                      label: 'Time',
                      value: _formattedTime,
                      color: AppTheme.amber,
                    ),
                    _StatDivider(),
                    _StatBox(
                      icon: Icons.star_outline,
                      label: 'Level',
                      value: _store.wordBuilderLevelName,
                      color: AppTheme.green,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: List.generate(_answer.length, (slot) {
                  final letter = _answer[slot];
                  return GestureDetector(
                    onTap: () => _onAnswerTap(slot),
                    child: Container(
                      width: 48,
                      height: 56,
                      decoration: BoxDecoration(
                        color: letter != null
                            ? AppTheme.primary.withOpacity(0.12)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: letter != null
                              ? AppTheme.primary
                              : const Color(0xFFCFD8DC),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          letter ?? '',
                          style: GoogleFonts.nunito(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),

              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: List.generate(_scrambled.length, (i) {
                  final used = _used[i];
                  return GestureDetector(
                    onTap: () => _onPoolTap(i),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: used ? 0.25 : 1,
                      child: Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFCFD8DC),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _scrambled[i],
                            style: GoogleFonts.nunito(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _clearAnswer,
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 54),
                    side: const BorderSide(color: Color(0xFFCFD8DC)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatBox({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: const Color(0xFFCFD8DC),
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}

class _WinStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _WinStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.nunito(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}