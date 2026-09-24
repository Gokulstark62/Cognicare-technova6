import 'ner_entity.dart';
import 'dictionaries/names.dart';
import 'dictionaries/places.dart';
import 'dictionaries/keywords.dart';

class TamilNer {
  /// Extract named entities from Tamil (or mixed Tamil/English) text.
  static List<NerEntity> extract(String text) {
    final entities = <NerEntity>[];

    // ─── Dates ───────────────────────────────────
    entities.addAll(_findDates(text));

    // ─── Times ───────────────────────────────────
    entities.addAll(_findTimes(text));

    // ─── Person names ────────────────────────────
    entities.addAll(_findNames(text));

    // ─── Places ──────────────────────────────────
    entities.addAll(_findPlaces(text));

    // ─── Tasks ───────────────────────────────────
    entities.addAll(_findTasks(text));

    // ─── Numbers ─────────────────────────────────
    entities.addAll(_findNumbers(text));

    // Sort by position
    entities.sort((a, b) => a.startIndex.compareTo(b.startIndex));

    // De-duplicate overlapping entities (keep earliest)
    return _dedupe(entities);
  }

  // ─── Date patterns ─────────────────────────
  static const Map<String, String> _dateWords = {
    'இன்று': 'today',
    'இன்றைக்கு': 'today',
    'நாளை': 'tomorrow',
    'நாளைக்கு': 'tomorrow',
    'நேற்று': 'yesterday',
    'நேற்றைக்கு': 'yesterday',
    'இன்றிரவு': 'tonight',
    'நாளை மறுநாள்': 'day after tomorrow',
    // Weekdays
    'திங்கள்': 'Monday',
    'செவ்வாய்': 'Tuesday',
    'புதன்': 'Wednesday',
    'வியாழன்': 'Thursday',
    'வெள்ளி': 'Friday',
    'சனி': 'Saturday',
    'ஞாயிறு': 'Sunday',
    // English
    'today': 'today',
    'tomorrow': 'tomorrow',
    'yesterday': 'yesterday',
  };

  static List<NerEntity> _findDates(String text) {
    final results = <NerEntity>[];
    for (final entry in _dateWords.entries) {
      int idx = text.indexOf(entry.key);
      while (idx != -1) {
        results.add(NerEntity(
          type: NerType.date,
          value: entry.key,
          startIndex: idx,
          endIndex: idx + entry.key.length,
        ));
        idx = text.indexOf(entry.key, idx + 1);
      }
    }

    // Numeric dates: dd/mm/yyyy or dd-mm-yyyy
    final dateRegex = RegExp(r'\b(\d{1,2})[/\-.](\d{1,2})[/\-.](\d{2,4})\b');
    for (final match in dateRegex.allMatches(text)) {
      results.add(NerEntity(
        type: NerType.date,
        value: match.group(0)!,
        startIndex: match.start,
        endIndex: match.end,
      ));
    }
    return results;
  }

  // ─── Time patterns ─────────────────────────
  static const Map<String, String> _timeWords = {
    'காலை': 'morning',
    'மதியம்': 'noon',
    'பிற்பகல்': 'afternoon',
    'மாலை': 'evening',
    'இரவு': 'night',
    'நள்ளிரவு': 'midnight',
    'morning': 'morning',
    'evening': 'evening',
    'night': 'night',
  };

  static List<NerEntity> _findTimes(String text) {
    final results = <NerEntity>[];
    for (final entry in _timeWords.entries) {
      int idx = text.indexOf(entry.key);
      while (idx != -1) {
        results.add(NerEntity(
          type: NerType.time,
          value: entry.key,
          startIndex: idx,
          endIndex: idx + entry.key.length,
        ));
        idx = text.indexOf(entry.key, idx + 1);
      }
    }

    // Time patterns: "8 மணி" (8 o'clock), "8:30", "8 AM"
    final timeRegex =
        RegExp(r'\b(\d{1,2})\s*(மணி|மணிக்கு|:\d{2}|AM|PM|am|pm)\b');
    for (final match in timeRegex.allMatches(text)) {
      results.add(NerEntity(
        type: NerType.time,
        value: match.group(0)!,
        startIndex: match.start,
        endIndex: match.end,
      ));
    }
    return results;
  }

  // ─── Person names ──────────────────────────
  static List<NerEntity> _findNames(String text) {
    final results = <NerEntity>[];
    final allNames = {
      ...NameDictionaries.maleNames,
      ...NameDictionaries.femaleNames,
    };

    for (final name in allNames) {
      int idx = text.indexOf(name);
      while (idx != -1) {
        results.add(NerEntity(
          type: NerType.person,
          value: name,
          startIndex: idx,
          endIndex: idx + name.length,
        ));
        idx = text.indexOf(name, idx + 1);
      }
    }
    return results;
  }

  // ─── Places ────────────────────────────────
  static List<NerEntity> _findPlaces(String text) {
    final results = <NerEntity>[];
    for (final place in PlaceDictionaries.places) {
      int idx = text.indexOf(place);
      while (idx != -1) {
        results.add(NerEntity(
          type: NerType.place,
          value: place,
          startIndex: idx,
          endIndex: idx + place.length,
        ));
        idx = text.indexOf(place, idx + 1);
      }
    }
    return results;
  }

  // ─── Tasks ─────────────────────────────────
  static List<NerEntity> _findTasks(String text) {
    final results = <NerEntity>[];
    for (final entry in TaskKeywords.mapping.entries) {
      int idx = text.indexOf(entry.key);
      while (idx != -1) {
        results.add(NerEntity(
          type: NerType.task,
          value: entry.key,
          startIndex: idx,
          endIndex: idx + entry.key.length,
        ));
        idx = text.indexOf(entry.key, idx + 1);
      }
    }
    return results;
  }

  // ─── Numbers ───────────────────────────────
  static List<NerEntity> _findNumbers(String text) {
    final results = <NerEntity>[];
    final regex = RegExp(r'\b\d+\b');
    for (final match in regex.allMatches(text)) {
      // Skip numbers that were already captured as date/time
      results.add(NerEntity(
        type: NerType.number,
        value: match.group(0)!,
        startIndex: match.start,
        endIndex: match.end,
      ));
    }
    return results;
  }

  // ─── De-duplication ────────────────────────
  static List<NerEntity> _dedupe(List<NerEntity> entities) {
    final result = <NerEntity>[];
    for (final e in entities) {
      // Check overlap with already-accepted entities
      bool overlaps = false;
      for (final r in result) {
        if (e.startIndex < r.endIndex && e.endIndex > r.startIndex) {
          overlaps = true;
          break;
        }
      }
      if (!overlaps) result.add(e);
    }
    return result;
  }
}