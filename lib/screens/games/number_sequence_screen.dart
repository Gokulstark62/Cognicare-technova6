import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import 'difficulty_store.dart';

class NumberSequenceScreen extends StatefulWidget {
  const NumberSequenceScreen({super.key});

  @override
  State<NumberSequenceScreen> createState() => _NumberSequenceScreenState();
}

enum Phase { showing, inputting, correct, wrong }

class _NumberSequenceScreenState extends State<NumberSequenceScreen> {
  final _store = DifficultyStore.instance;
  final _random = Random();

  List<int> _sequence = [];
  List<int> _input = [];

  Phase _phase = Phase.showing;
  Timer? _hideTimer;
  bool _winShown = false;

  int _round = 0;
  int _correctCount = 0;
  static const int _totalRounds = 5;

  @override
  void initState() {
    super.initState();
    _newRound();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  void _newRound() {
    _hideTimer?.cancel();

    final length = _store.sequenceLength;
    final seq = List<int>.generate(length, (_) => _random.nextInt(10));

    setState(() {
      _sequence = seq;
      _input = [];
      _phase = Phase.showing;
    });

    _hideTimer = Timer(
      Duration(milliseconds: _store.showDurationMs),
      () {
        if (!mounted) return;
        setState(() => _phase = Phase.inputting);
      },
    );
  }

  void _onNumberTap(int digit) {
    if (_phase != Phase.inputting) return;
    if (_input.length >= _sequence.length) return;

    setState(() => _input.add(digit));

    if (_input.length == _sequence.length) {
      _checkAnswer();
    }
  }

  void _onBackspace() {
    if (_phase != Phase.inputting) return;
    if (_input.isEmpty) return;
    setState(() => _input.removeLast());
  }

  void _checkAnswer() {
    final isCorrect = _listEquals(_input, _sequence);

    setState(() {
      _phase = isCorrect ? Phase.correct : Phase.wrong;
    });

    if (isCorrect) _correctCount++;

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      _round++;

      if (_round >= _totalRounds) {
        _onGameComplete();
      } else {
        _newRound();
      }
    });
  }

  bool _listEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  Future<void> _onGameComplete() async {
    if (_winShown) return;
    _winShown = true;

    final lastCorrect = _correctCount > 0;
    final change = await _store.adjustNumberSeq(correct: lastCorrect);

    if (!mounted) return;
    _showWinDialog(change);
  }

  void _showWinDialog(String change) {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);

    String? changeMessage;
    Color changeColor = AppTheme.primary;
    IconData? changeIcon;

    if (change == 'up') {
      changeMessage = l10n.greatJobLevelUp;
      changeColor = AppTheme.green;
      changeIcon = Icons.arrow_upward;
    } else if (change == 'down') {
      changeMessage = l10n.letsTryEasier;
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
                    color: AppTheme.amber.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.emoji_events,
                      color: AppTheme.amber, size: 56),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.sessionComplete,
                  style: GoogleFonts.nunito(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.youGotOutOf(_correctCount, _totalRounds),
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
                      label: l10n.correct,
                      value: '$_correctCount',
                      icon: Icons.check_circle_outline,
                      color: AppTheme.green,
                    ),
                    _WinStat(
                      label: l10n.wrong,
                      value: '${_totalRounds - _correctCount}',
                      icon: Icons.cancel_outlined,
                      color: AppTheme.pink,
                    ),
                    _WinStat(
                      label: l10n.level,
                      value: _store.numberSeqLevelName,
                      icon: Icons.star_outline,
                      color: AppTheme.amber,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      _restartSession();
                    },
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.playAgain),
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
                    label: Text(l10n.backToHome),
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

  void _restartSession() {
    setState(() {
      _round = 0;
      _correctCount = 0;
      _winShown = false;
    });
    _newRound();
  }

  void _showLevelPicker() {
    final l10n = AppLocalizations.of(context);
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
                  l10n.chooseDifficulty,
                  style: GoogleFonts.nunito(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _levelOption(sheetContext, 0, l10n.easy,
                    '3 digits', AppTheme.green),
                _levelOption(sheetContext, 1, l10n.medium,
                    '4 digits', AppTheme.amber),
                _levelOption(sheetContext, 2, l10n.hard,
                    '5 digits', AppTheme.pink),
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
    final selected = _store.numberSeqLevel == level;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: selected ? color.withOpacity(0.12) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () async {
            await _store.setNumberSeqLevel(level);
            if (!sheetContext.mounted) return;
            Navigator.of(sheetContext).pop();
            _restartSession();
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_round >= _totalRounds) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        title: Text(l10n.numberSequence),
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
                      _store.numberSeqLevelName,
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
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${l10n.round} ${_round + 1} / $_totalRounds',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.green.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check,
                            color: AppTheme.green, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          '$_correctCount',
                          style: GoogleFonts.nunito(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: _round / _totalRounds,
                  minHeight: 10,
                  backgroundColor: AppTheme.primary.withOpacity(0.12),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      _phase == Phase.showing
                          ? '👀 Remember this sequence'
                          : '🔢 Enter the sequence',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_phase == Phase.showing)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _sequence
                            .map((n) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6),
                                  child: Container(
                                    width: 52,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: AppTheme.primary,
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$n',
                                        style: GoogleFonts.nunito(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_sequence.length, (i) {
                          final filled = i < _input.length;
                          final bg = _phase == Phase.correct
                              ? AppTheme.green
                              : _phase == Phase.wrong
                                  ? AppTheme.pink
                                  : AppTheme.primary.withOpacity(0.12);
                          final fg = _phase == Phase.correct ||
                                  _phase == Phase.wrong
                              ? Colors.white
                              : AppTheme.primary;
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6),
                            child: Container(
                              width: 52,
                              height: 60,
                              decoration: BoxDecoration(
                                color: bg,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppTheme.primary,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  filled ? '${_input[i]}' : '',
                                  style: GoogleFonts.nunito(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    color: fg,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.4,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        for (int i = 1; i <= 9; i++)
                          _NumberKey(
                            label: '$i',
                            onTap: () => _onNumberTap(i),
                            enabled: _phase == Phase.inputting,
                          ),
                        _NumberKey(
                          label: '0',
                          onTap: () => _onNumberTap(0),
                          enabled: _phase == Phase.inputting,
                        ),
                        _NumberKey(
                          label: '⌫',
                          onTap: _onBackspace,
                          enabled: _phase == Phase.inputting,
                          isBackspace: true,
                        ),
                        _NumberKey(
                          label: '',
                          onTap: () {},
                          enabled: false,
                          isBackspace: true,
                        ),
                      ],
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

class _NumberKey extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool enabled;
  final bool isBackspace;

  const _NumberKey({
    required this.label,
    required this.onTap,
    required this.enabled,
    this.isBackspace = false,
  });

  @override
  Widget build(BuildContext context) {
    if (label.isEmpty) return const SizedBox.shrink();

    final color = isBackspace ? AppTheme.pink : AppTheme.primary;

    return Material(
      color: enabled ? Colors.white : Colors.white.withOpacity(0.5),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: enabled ? onTap : null,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: enabled
                  ? color.withOpacity(0.4)
                  : const Color(0xFFCFD8DC),
              width: 2,
            ),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: enabled ? color : AppTheme.textSecondary,
              ),
            ),
          ),
        ),
      ),
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