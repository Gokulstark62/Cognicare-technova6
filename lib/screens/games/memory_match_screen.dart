import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import 'difficulty_store.dart';

class MemoryMatchScreen extends StatefulWidget {
  const MemoryMatchScreen({super.key});

  @override
  State<MemoryMatchScreen> createState() => _MemoryMatchScreenState();
}

class _MemoryMatchScreenState extends State<MemoryMatchScreen> {
  final _store = DifficultyStore.instance;

  // Deck is generated fresh each game, based on current level
  late List<String> _deck;
  late int _totalPairs;

  // Game state
  late List<bool> _flipped;
  late List<bool> _matched;
  int? _firstIndex;
  bool _busy = false;

  // Score state
  int _moves = 0;
  int _seconds = 0;
  Timer? _timer;
  bool _winShown = false;

  @override
  void initState() {
    super.initState();
    _resetBoard();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimerIfNeeded() {
    if (_timer != null && _timer!.isActive) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _seconds++);
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _resetBoard() {
    _stopTimer();
    setState(() {
      _deck = _store.getDeck();
      _totalPairs = _deck.length ~/ 2;
      _flipped = List<bool>.filled(_deck.length, false);
      _matched = List<bool>.filled(_deck.length, false);
      _firstIndex = null;
      _busy = false;
      _moves = 0;
      _seconds = 0;
      _winShown = false;
    });
  }

  int get _matchedPairs => _matched.where((m) => m).length ~/ 2;

  int get _accuracy {
    if (_moves == 0) return 0;
    final a = (_totalPairs / _moves) * 100;
    return a.clamp(0, 100).round();
  }

  void _onCardTap(int index) {
    if (_busy) return;
    if (_matched[index]) return;
    if (_flipped[index]) return;

    _startTimerIfNeeded();

    setState(() {
      _flipped[index] = true;
    });

    if (_firstIndex == null) {
      _firstIndex = index;
      return;
    }

    final first = _firstIndex!;
    final second = index;

    setState(() {
      _moves++;
    });

    if (_deck[first] == _deck[second]) {
      setState(() {
        _matched[first] = true;
        _matched[second] = true;
        _firstIndex = null;
      });

      if (_matchedPairs == _totalPairs && !_winShown) {
        _stopTimer();
        _winShown = true;
        Timer(const Duration(milliseconds: 500), _onGameComplete);
      }
    } else {
      setState(() => _busy = true);
      Timer(const Duration(milliseconds: 700), () {
        if (!mounted) return;
        setState(() {
          _flipped[first] = false;
          _flipped[second] = false;
          _firstIndex = null;
          _busy = false;
        });
      });
    }
  }

  void _onGameComplete() {
    if (!mounted) return;

    final acc = _accuracy;
    final sec = _seconds;
    final change = _store.adjust(accuracy: acc, seconds: sec);

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
                  'Congratulations!',
                  style: GoogleFonts.nunito(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'You matched all pairs!',
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
                      label: 'Moves',
                      value: '$_moves',
                      icon: Icons.touch_app_outlined,
                      color: AppTheme.primary,
                    ),
                    _WinStat(
                      label: 'Time',
                      value: _formattedTime,
                      icon: Icons.timer_outlined,
                      color: AppTheme.amber,
                    ),
                    _WinStat(
                      label: 'Accuracy',
                      value: '$_accuracy%',
                      icon: Icons.check_circle_outline,
                      color: AppTheme.green,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Text(
                  'Next game: ${_store.levelName}',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      _resetBoard();
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
                _levelOption(sheetContext, 0, 'Easy', '4 pairs • 8 cards',
                    AppTheme.green),
                _levelOption(sheetContext, 1, 'Medium', '6 pairs • 12 cards',
                    AppTheme.amber),
                _levelOption(sheetContext, 2, 'Hard', '8 pairs • 16 cards',
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
    final selected = _store.memoryMatchLevel == level;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: selected ? color.withOpacity(0.12) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            _store.setLevel(level);
            Navigator.of(sheetContext).pop();
            _resetBoard();
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
        title: const Text('Memory Match'),
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
                      _store.levelName,
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
            onPressed: _resetBoard,
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
                      color: AppTheme.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.grid_view_rounded,
                        color: AppTheme.primary, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Find Matching Pairs',
                          style: GoogleFonts.nunito(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Text(
                          'Level: ${_store.levelName} • $_totalPairs pairs',
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
                      icon: Icons.touch_app_outlined,
                      label: 'Moves',
                      value: '$_moves',
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
                      icon: Icons.check_circle_outline,
                      label: 'Pairs',
                      value: '$_matchedPairs / $_totalPairs',
                      color: AppTheme.green,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: GridView.builder(
                      itemCount: _deck.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.0,
                      ),
                      itemBuilder: (context, index) {
                        return _CardTile(
                          emoji: _deck[index],
                          flipped: _flipped[index],
                          matched: _matched[index],
                          onTap: () => _onCardTap(index),
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

class _CardTile extends StatelessWidget {
  final String emoji;
  final bool flipped;
  final bool matched;
  final VoidCallback onTap;

  const _CardTile({
    required this.emoji,
    required this.flipped,
    required this.matched,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final showFront = flipped || matched;
    final faceColor =
        matched ? AppTheme.green.withOpacity(0.15) : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: showFront ? 1 : 0),
        duration: const Duration(milliseconds: 300),
        builder: (context, value, _) {
          final isFront = value > 0.5;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(value * 3.14159),
            child: Container(
              decoration: BoxDecoration(
                color: isFront ? faceColor : AppTheme.primary,
                borderRadius: BorderRadius.circular(16),
                border: matched
                    ? Border.all(color: AppTheme.green, width: 2)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: isFront
                    ? Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..rotateY(3.14159),
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 40),
                        ),
                      )
                    : Text(
                        '?',
                        style: GoogleFonts.nunito(
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}