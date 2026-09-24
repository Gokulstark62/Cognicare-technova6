import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persistent store for game difficulty levels.
/// Uses shared_preferences to survive app restarts.
class DifficultyStore {
  DifficultyStore._();
  static final DifficultyStore instance = DifficultyStore._();

  // ─── Keys ─────────────────────────────────
  static const String _kMemory = 'difficulty_memory';
  static const String _kWord = 'difficulty_word';
  static const String _kPicture = 'difficulty_picture';
  static const String _kNumberSeq = 'difficulty_numberseq';

  // ═══════════════════════════════════════════
  // STATE
  // ═══════════════════════════════════════════
  int memoryMatchLevel = 0;
  int wordBuilderLevel = 0;
  int pictureLevel = 0;
  int numberSeqLevel = 0;

  bool _loaded = false;

  // ═══════════════════════════════════════════
  // LOAD / SAVE
  // ═══════════════════════════════════════════
  Future<void> load() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    memoryMatchLevel = prefs.getInt(_kMemory) ?? 0;
    wordBuilderLevel = prefs.getInt(_kWord) ?? 0;
    pictureLevel = prefs.getInt(_kPicture) ?? 0;
    numberSeqLevel = prefs.getInt(_kNumberSeq) ?? 0;
    debugPrint('📖 DifficultyStore: loaded — memory=$memoryMatchLevel '
        'word=$wordBuilderLevel picture=$pictureLevel '
        'numseq=$numberSeqLevel');
    _loaded = true;
  }

  Future<void> _saveAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kMemory, memoryMatchLevel);
    await prefs.setInt(_kWord, wordBuilderLevel);
    await prefs.setInt(_kPicture, pictureLevel);
    await prefs.setInt(_kNumberSeq, numberSeqLevel);
    debugPrint('💾 DifficultyStore: saved — memory=$memoryMatchLevel '
        'word=$wordBuilderLevel picture=$pictureLevel '
        'numseq=$numberSeqLevel');
  }

  // ═══════════════════════════════════════════
  // MEMORY MATCH
  // ═══════════════════════════════════════════
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

  Future<void> setLevel(int level) async {
    memoryMatchLevel = level.clamp(0, 2);
    await _saveAll();
  }

  Future<String> adjust({required int accuracy, required int seconds}) async {
    final oldLevel = memoryMatchLevel;
    if (accuracy >= 70 && seconds <= 60) {
      if (memoryMatchLevel < 2) memoryMatchLevel++;
    } else if (accuracy < 40 || seconds > 120) {
      if (memoryMatchLevel > 0) memoryMatchLevel--;
    }
    if (memoryMatchLevel != oldLevel) await _saveAll();
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

  // ═══════════════════════════════════════════
  // WORD BUILDER
  // ═══════════════════════════════════════════
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

  Future<void> setWordBuilderLevel(int level) async {
    wordBuilderLevel = level.clamp(0, 2);
    await _saveAll();
  }

  Future<String> adjustWordBuilder(
      {required int attempts, required int seconds}) async {
    final old = wordBuilderLevel;
    if (attempts <= 1 && seconds <= 60) {
      if (wordBuilderLevel < 2) wordBuilderLevel++;
    } else if (attempts >= 4 || seconds > 120) {
      if (wordBuilderLevel > 0) wordBuilderLevel--;
    }
    if (wordBuilderLevel != old) await _saveAll();
    if (wordBuilderLevel > old) return 'up';
    if (wordBuilderLevel < old) return 'down';
    return 'same';
  }

  // ═══════════════════════════════════════════
  // PICTURE RECOGNITION
  // ═══════════════════════════════════════════
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

  Future<void> setPictureLevel(int level) async {
    pictureLevel = level.clamp(0, 2);
    await _saveAll();
  }

  Future<String> adjustPicture(
      {required int correct, required int total}) async {
    final accuracy = (correct / total) * 100;
    final old = pictureLevel;
    if (accuracy >= 80) {
      if (pictureLevel < 2) pictureLevel++;
    } else if (accuracy < 50) {
      if (pictureLevel > 0) pictureLevel--;
    }
    if (pictureLevel != old) await _saveAll();
    if (pictureLevel > old) return 'up';
    if (pictureLevel < old) return 'down';
    return 'same';
  }

  // ═══════════════════════════════════════════
  // NUMBER SEQUENCE
  // ═══════════════════════════════════════════
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

  Future<void> setNumberSeqLevel(int level) async {
    numberSeqLevel = level.clamp(0, 2);
    await _saveAll();
  }

  Future<String> adjustNumberSeq({required bool correct}) async {
    final old = numberSeqLevel;
    if (correct) {
      if (numberSeqLevel < 2) numberSeqLevel++;
    } else {
      if (numberSeqLevel > 0) numberSeqLevel--;
    }
    if (numberSeqLevel != old) await _saveAll();
    if (numberSeqLevel > old) return 'up';
    if (numberSeqLevel < old) return 'down';
    return 'same';
  }
}