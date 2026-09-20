/// Simple in-memory store for game difficulty.
/// Phase 6 will replace this with SQLite persistence.
class DifficultyStore {
  DifficultyStore._();
  static final DifficultyStore instance = DifficultyStore._();

  // ═══════════════════════════════════════════════════════════
  // MEMORY MATCH
  // ═══════════════════════════════════════════════════════════

  int memoryMatchLevel = 0;

  static const List<List<String>> _memoryEmojiPool = [
    ['🍎', '🐶', '⭐', '🌸'],
    ['🍎', '🐶', '⭐', '🌸', '🎈', '🍕'],
    ['🍎', '🐶', '⭐', '🌸', '🎈', '🍕', '☀️', '🐱'],
  ];

  List<String> getDeck() {
    final base = _memoryEmojiPool[memoryMatchLevel];
    final doubled = [...base, ...base];
    doubled.shuffle();
    return doubled;
  }

  int get crossAxisCount => 4;
  int get pairsAtLevel => _memoryEmojiPool[memoryMatchLevel].length;

  void setLevel(int level) => memoryMatchLevel = level.clamp(0, 2);

  String adjust({required int accuracy, required int seconds}) {
    final oldLevel = memoryMatchLevel;
    if (accuracy >= 70 && seconds <= 60) {
      if (memoryMatchLevel < 2) memoryMatchLevel++;
    } else if (accuracy < 40 || seconds > 120) {
      if (memoryMatchLevel > 0) memoryMatchLevel--;
    }
    if (memoryMatchLevel > oldLevel) return 'up';
    if (memoryMatchLevel < oldLevel) return 'down';
    return 'same';
  }

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

  // ═══════════════════════════════════════════════════════════
  // WORD BUILDER
  // ═══════════════════════════════════════════════════════════

  int wordBuilderLevel = 0;

  static const List<List<String>> _wordPool = [
    ['CAT', 'DOG', 'SUN', 'CUP', 'BED', 'HAT', 'PEN', 'BUS'],
    ['APPLE', 'TIGER', 'HOUSE', 'WATER', 'BREAD', 'MONEY', 'HAPPY'],
    ['ELEPHANT', 'COMPUTER', 'FAMILY', 'BIRTHDAY', 'FLOWER'],
  ];

  List<String> get wordPool => _wordPool[wordBuilderLevel];

  String get wordBuilderLevelName {
    switch (wordBuilderLevel) {
      case 0:
        return 'Easy';
      case 1:
        return 'Medium';
      default:
        return 'Hard';
    }
  }

  void setWordBuilderLevel(int level) =>
      wordBuilderLevel = level.clamp(0, 2);

  String adjustWordBuilder({required int attempts, required int seconds}) {
    final old = wordBuilderLevel;
    if (attempts <= 1 && seconds <= 60) {
      if (wordBuilderLevel < 2) wordBuilderLevel++;
    } else if (attempts >= 4 || seconds > 120) {
      if (wordBuilderLevel > 0) wordBuilderLevel--;
    }
    if (wordBuilderLevel > old) return 'up';
    if (wordBuilderLevel < old) return 'down';
    return 'same';
  }

  // ═══════════════════════════════════════════════════════════
  // PICTURE RECOGNITION
  // ═══════════════════════════════════════════════════════════

  int pictureLevel = 0;

  static const List<List<Map<String, String>>> _picturePool = [
    [
      {'emoji': '🍎', 'name': 'Apple'},
      {'emoji': '🐶', 'name': 'Dog'},
      {'emoji': '☀️', 'name': 'Sun'},
      {'emoji': '🌸', 'name': 'Flower'},
      {'emoji': '🏠', 'name': 'House'},
      {'emoji': '🚗', 'name': 'Car'},
      {'emoji': '🍕', 'name': 'Pizza'},
      {'emoji': '⭐', 'name': 'Star'},
    ],
    [
      {'emoji': '🍎', 'name': 'Apple'},
      {'emoji': '🐶', 'name': 'Dog'},
      {'emoji': '☀️', 'name': 'Sun'},
      {'emoji': '🌸', 'name': 'Flower'},
      {'emoji': '🏠', 'name': 'House'},
      {'emoji': '🚗', 'name': 'Car'},
      {'emoji': '🍕', 'name': 'Pizza'},
      {'emoji': '⭐', 'name': 'Star'},
      {'emoji': '🐱', 'name': 'Cat'},
      {'emoji': '🌳', 'name': 'Tree'},
      {'emoji': '📚', 'name': 'Book'},
      {'emoji': '🌙', 'name': 'Moon'},
    ],
    [
      {'emoji': '🍎', 'name': 'Apple'},
      {'emoji': '🐶', 'name': 'Dog'},
      {'emoji': '☀️', 'name': 'Sun'},
      {'emoji': '🌸', 'name': 'Flower'},
      {'emoji': '🏠', 'name': 'House'},
      {'emoji': '🚗', 'name': 'Car'},
      {'emoji': '🍕', 'name': 'Pizza'},
      {'emoji': '⭐', 'name': 'Star'},
      {'emoji': '🐱', 'name': 'Cat'},
      {'emoji': '🌳', 'name': 'Tree'},
      {'emoji': '📚', 'name': 'Book'},
      {'emoji': '🌙', 'name': 'Moon'},
      {'emoji': '⚽', 'name': 'Ball'},
      {'emoji': '✏️', 'name': 'Pencil'},
      {'emoji': '🕐', 'name': 'Clock'},
      {'emoji': '🎈', 'name': 'Balloon'},
      {'emoji': '🐟', 'name': 'Fish'},
      {'emoji': '🍌', 'name': 'Banana'},
      {'emoji': '🚌', 'name': 'Bus'},
      {'emoji': '🌈', 'name': 'Rainbow'},
    ],
  ];

  List<Map<String, String>> get picturePool => _picturePool[pictureLevel];

  int get pictureOptionCount {
    switch (pictureLevel) {
      case 0:
        return 2;
      case 1:
        return 4;
      default:
        return 6;
    }
  }

  String get pictureLevelName {
    switch (pictureLevel) {
      case 0:
        return 'Easy';
      case 1:
        return 'Medium';
      default:
        return 'Hard';
    }
  }

  void setPictureLevel(int level) => pictureLevel = level.clamp(0, 2);

  String adjustPicture({required int correct, required int total}) {
    final accuracy = (correct / total) * 100;
    final old = pictureLevel;
    if (accuracy >= 80) {
      if (pictureLevel < 2) pictureLevel++;
    } else if (accuracy < 50) {
      if (pictureLevel > 0) pictureLevel--;
    }
    if (pictureLevel > old) return 'up';
    if (pictureLevel < old) return 'down';
    return 'same';
  }

  // ═══════════════════════════════════════════════════════════
  // NUMBER SEQUENCE
  // ═══════════════════════════════════════════════════════════

  int numberSeqLevel = 0;

  /// Sequence length grows with level
  int get sequenceLength {
    switch (numberSeqLevel) {
      case 0:
        return 3;
      case 1:
        return 4;
      default:
        return 5;
    }
  }

  /// How long the sequence is shown (milliseconds)
  int get showDurationMs {
    switch (numberSeqLevel) {
      case 0:
        return 2000;
      case 1:
        return 2500;
      default:
        return 3000;
    }
  }

  String get numberSeqLevelName {
    switch (numberSeqLevel) {
      case 0:
        return 'Easy';
      case 1:
        return 'Medium';
      default:
        return 'Hard';
    }
  }

  void setNumberSeqLevel(int level) => numberSeqLevel = level.clamp(0, 2);

  String adjustNumberSeq({required bool correct}) {
    final old = numberSeqLevel;
    if (correct) {
      if (numberSeqLevel < 2) numberSeqLevel++;
    } else {
      if (numberSeqLevel > 0) numberSeqLevel--;
    }
    if (numberSeqLevel > old) return 'up';
    if (numberSeqLevel < old) return 'down';
    return 'same';
  }
}