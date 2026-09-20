import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import 'difficulty_store.dart';

class PictureRecognitionScreen extends StatefulWidget {
  const PictureRecognitionScreen({super.key});

  @override
  State<PictureRecognitionScreen> createState() =>
      _PictureRecognitionScreenState();
}

class _PictureRecognitionScreenState extends State<PictureRecognitionScreen> {
  final _store = DifficultyStore.instance;
  final _random = Random();

  static const int _totalRounds = 10;

  int _round = 0;
  int _correct = 0;
  int _wrong = 0;

  late Map<String, String> _target;
  late List<Map<String, String>> _options;

  int? _selectedIndex;
  bool _locked = false;
  bool _winShown = false;

  @override
  void initState() {
    super.initState();
    _newRound();
  }

  void _newRound() {
    if (_round >= _totalRounds) return;

    final pool = List<Map<String, String>>.from(_store.picturePool);
    pool.shuffle(_random);

    final optionCount = _store.pictureOptionCount;
    final target = pool.first;

    final distractors = pool
        .skip(1)
        .where((item) => item['emoji'] != target['emoji'])
        .take(optionCount - 1)
        .toList();

    final options = [target, ...distractors]..shuffle(_random);

    setState(() {
      _target = target;
      _options = options;
      _selectedIndex = null;
      _locked = false;
    });
  }

  void _onOptionTap(int index) {
    if (_locked) return;

    final isCorrect = _options[index]['emoji'] == _target['emoji'];

    setState(() {
      _selectedIndex = index;
      _locked = true;
      if (isCorrect) {
        _correct++;
      } else {
        _wrong++;
      }
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() => _round++);
      if (_round >= _totalRounds) {
        _onGameComplete();
      } else {
        _newRound();
      }
    });
  }

  void _onGameComplete() {
    if (_winShown) return;
    _winShown = true;
    final change =
        _store.adjustPicture(correct: _correct, total: _totalRounds);
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
                    color: AppTheme.amber.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.emoji_events,
                      color: AppTheme.amber, size: 56),
                ),
                const SizedBox(height: 16),
                Text(
                  'Session Complete!',
                  style: GoogleFonts.nunito(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'You got $_correct out of $_totalRounds',
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
                      label: 'Correct',
                      value: '$_correct',
                      icon: Icons.check_circle_outline,
                      color: AppTheme.green,
                    ),
                    _WinStat(
                      label: 'Wrong',
                      value: '$_wrong',
                      icon: Icons.cancel_outlined,
                      color: AppTheme.pink,
                    ),
                    _WinStat(
                      label: 'Level',
                      value: _store.pictureLevelName,
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
                    label: const Text('Play Again'),
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

  void _restartSession() {
    setState(() {
      _round = 0;
      _correct = 0;
      _wrong = 0;
      _winShown = false;
    });
    _newRound();
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
                _levelOption(
                    sheetContext, 0, 'Easy', '2 choices', AppTheme.green),
                _levelOption(
                    sheetContext, 1, 'Medium', '4 choices', AppTheme.amber),
                _levelOption(
                    sheetContext, 2, 'Hard', '6 choices', AppTheme.pink),
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
    final selected = _store.pictureLevel == level;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: selected ? color.withOpacity(0.12) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            _store.setPictureLevel(level);
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
        title: const Text('Picture Recognition'),
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
                      _store.pictureLevelName,
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
                      'Round ${_round + 1} / $_totalRounds',
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
                          '$_correct',
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
                      'Which one is the',
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _target['name']!,
                      style: GoogleFonts.nunito(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: GridView.builder(
                      itemCount: _options.length,
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _options.length <= 2 ? 2 : 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.0,
                      ),
                      itemBuilder: (context, i) {
                        return _OptionTile(
                          emoji: _options[i]['emoji']!,
                          state: _selectedIndex == null
                              ? _OptionState.idle
                              : _selectedIndex == i
                                  ? (_options[i]['emoji'] == _target['emoji']
                                      ? _OptionState.correct
                                      : _OptionState.wrong)
                                  : _OptionState.dimmed,
                          onTap: () => _onOptionTap(i),
                        );
                      },
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

enum _OptionState { idle, correct, wrong, dimmed }

class _OptionTile extends StatelessWidget {
  final String emoji;
  final _OptionState state;
  final VoidCallback onTap;

  const _OptionTile({
    required this.emoji,
    required this.state,
    required this.onTap,
  });

  Color get _borderColor {
    switch (state) {
      case _OptionState.correct:
        return AppTheme.green;
      case _OptionState.wrong:
        return AppTheme.pink;
      default:
        return const Color(0xFFCFD8DC);
    }
  }

  Color get _bgColor {
    switch (state) {
      case _OptionState.correct:
        return AppTheme.green.withOpacity(0.15);
      case _OptionState.wrong:
        return AppTheme.pink.withOpacity(0.15);
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: state == _OptionState.idle ? onTap : null,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: state == _OptionState.dimmed ? 0.4 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: _bgColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _borderColor,
              width: state == _OptionState.idle ? 2 : 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 56),
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