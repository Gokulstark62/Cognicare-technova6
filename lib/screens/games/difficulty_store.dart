/// Simple in-memory store for game difficulty.
/// Phase 6 will replace this with SQLite persistence.
class DifficultyStore {
  // Singleton pattern — one shared instance for the app
  DifficultyStore._();
  static final DifficultyStore instance = DifficultyStore._();

  /// 0 = Easy (4 pairs), 1 = Medium (6 pairs), 2 = Hard (8 pairs)
  int memoryMatchLevel = 0;

  /// Emoji pools by level — each list is the "base" set,
  /// the deck is created by doubling and shuffling it.
  static const List<List<String>> _emojiPool = [
    // Easy — 4 pairs (8 cards)
    ['🍎', '🐶', '⭐', '🌸'],
    // Medium — 6 pairs (12 cards)
    ['🍎', '🐶', '⭐', '🌸', '🎈', '🍕'],
    // Hard — 8 pairs (16 cards)
    ['🍎', '🐶', '⭐', '🌸', '🎈', '🍕', '☀️', '🐱'],
  ];

  /// Get the shuffled emoji deck for the current level.
  /// Each emoji appears twice.
  List<String> getDeck() {
    final base = _emojiPool[memoryMatchLevel];
    final doubled = [...base, ...base];
    doubled.shuffle();
    return doubled;
  }

  /// Grid column count for the current level.
  /// All levels use 4 columns; rows adjust based on card count.
  int get crossAxisCount => 4;

  /// Number of pairs at current level (for display).
  int get pairsAtLevel => _emojiPool[memoryMatchLevel].length;

  /// Manually set the level (0 = Easy, 1 = Medium, 2 = Hard).
  void setLevel(int level) {
    memoryMatchLevel = level.clamp(0, 2);
  }

  /// Called after a game finishes. Adjusts level up or down
  /// based on accuracy and time. Returns 'up', 'down', or 'same'.
  String adjust({
    required int accuracy,
    required int seconds,
  }) {
    final oldLevel = memoryMatchLevel;

    // Level UP: high accuracy + fast
    if (accuracy >= 70 && seconds <= 60) {
      if (memoryMatchLevel < 2) memoryMatchLevel++;
    }
    // Level DOWN: low accuracy or slow
    else if (accuracy < 40 || seconds > 120) {
      if (memoryMatchLevel > 0) memoryMatchLevel--;
    }

    if (memoryMatchLevel > oldLevel) return 'up';
    if (memoryMatchLevel < oldLevel) return 'down';
    return 'same';
  }

  /// Human-readable name of the current level.
  String get levelName {
    switch (memoryMatchLevel) {
      case 0:
        return 'Easy';
      case 1:
        return 'Medium';
      default:
        return 'Hard';
    }
  }
}