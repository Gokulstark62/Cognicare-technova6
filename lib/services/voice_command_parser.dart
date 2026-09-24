/// Intent matcher for voice commands.
/// Phase 5.6 — adds "status" and "log water N" commands.
class VoiceCommandParser {
  VoiceCommandParser._();

  /// Try to match the transcript to a known command.
  static String? parse(String transcript) {
    final text = transcript.toLowerCase().trim();
    if (text.isEmpty) return null;

    // ─── Status: "How am I doing?" ──────────────
    if (_containsAny(text, [
      'how am i',
      'how am i doing',
      'my status',
      'my progress',
      'my summary',
      'health summary',
      'today summary',
      // Tamil
      'எப்படி இருக்கிறேன்',
      'என் நிலை',
      'என் முன்னேற்றம்',
      'இன்றைய நிலை',
    ])) {
      return 'status_report';
    }

    // ─── Log water with amount ──────────────────
    // Match "log 2 glasses", "add 1 water", etc.
    if (_matchesLogWater(text)) {
      return 'log_water';
    }

    // ─── Medicine ───────────────────────────────
    if (_containsAny(text, [
      'medicine',
      'medicines',
      'medication',
      'meds',
      'pill',
      'pills',
      'tablet',
      'tablets',
      'dose',
      'மருந்து',
      'மருந்துகள்',
      'மாத்திரை',
      'மாத்திரைகள்',
    ])) {
      return 'open_medicine';
    }

    // ─── Hydration / Water ──────────────────────
    if (_containsAny(text, [
      'water',
      'hydration',
      'drink',
      'thirsty',
      'hydrate',
      'தண்ணீர்',
      'நீர்',
      'தண்ணி',
      'குடி',
    ])) {
      return 'open_hydration';
    }

    // ─── Routine ────────────────────────────────
    if (_containsAny(text, [
      'routine',
      'schedule',
      'plan',
      'activities',
      'daily',
      'வழக்கம்',
      'அட்டவணை',
      'திட்டம்',
      'நடவடிக்கை',
    ])) {
      return 'open_routine';
    }

    // ─── Appointments ───────────────────────────
    if (_containsAny(text, [
      'appointment',
      'appointments',
      'doctor',
      'doctors',
      'visit',
      'meeting',
      'clinic',
      'hospital',
      'மருத்துவர்',
      'மருத்துவமனை',
      'சந்திப்பு',
      'டாக்டர்',
    ])) {
      return 'open_appointments';
    }

    // ─── Games ──────────────────────────────────
    if (_containsAny(text, [
      'game',
      'games',
      'play',
      'brain',
      'puzzle',
      'விளையாட்டு',
      'விளையாடு',
      'விளையாட்டுகள்',
    ])) {
      return 'open_games';
    }

    // ─── Settings ───────────────────────────────
    if (_containsAny(text, [
      'settings',
      'preferences',
      'options',
      'config',
      'அமைப்பு',
      'அமைப்புகள்',
      'விருப்பங்கள்',
    ])) {
      return 'open_settings';
    }

    // ─── Home ───────────────────────────────────
    if (_containsAny(text, [
      'home',
      'dashboard',
      'main',
      'back',
      'வீடு',
      'முகப்பு',
      'திரும்பு',
    ])) {
      return 'go_home';
    }

    return null;
  }

  /// Extract how many glasses from "log 2 glasses of water".
  /// Returns 1 as a default if no number found.
  static int extractGlasses(String transcript) {
    final text = transcript.toLowerCase();

    // Try digits first: "2 glasses", "3"
    final digitMatch = RegExp(r'(\d+)').firstMatch(text);
    if (digitMatch != null) {
      final n = int.tryParse(digitMatch.group(1)!);
      if (n != null && n > 0 && n <= 10) return n;
    }

    // Then English number words
    const wordMap = {
      'one': 1,
      'two': 2,
      'three': 3,
      'four': 4,
      'five': 5,
      'six': 6,
      'seven': 7,
      'eight': 8,
      'nine': 9,
      'ten': 10,
      'a': 1,
      'an': 1,
    };
    for (final entry in wordMap.entries) {
      if (text.contains(entry.key)) return entry.value;
    }

    // Tamil numbers
    const tamilMap = {
      'ஒன்று': 1,
      'ஒரு': 1,
      'இரண்டு': 2,
      'இரு': 2,
      'ரெண்டு': 2,
      'மூன்று': 3,
      'மூணு': 3,
      'நான்கு': 4,
      'நாலு': 4,
      'ஐந்து': 5,
      'ஐஞ்சு': 5,
    };
    for (final entry in tamilMap.entries) {
      if (text.contains(entry.key)) return entry.value;
    }

    return 1;
  }

  static bool _matchesLogWater(String text) {
    final hasWater = _containsAny(text, ['water', 'தண்ணீர்']);
    final hasLog = _containsAny(text, [
      'log',
      'add',
      'drank',
      'had',
      'record',
      'log water',
      'சேர்',
      'சேர்த்தேன்',
      'குடித்தேன்',
    ]);
    return hasWater && hasLog;
  }

  /// Human-readable action description.
  static String describeAction(String actionKey, {bool isTamil = false}) {
    if (isTamil) {
      switch (actionKey) {
        case 'open_medicine':
          return 'மருந்துகள் திறக்கிறது';
        case 'open_hydration':
          return 'தண்ணீர் திறக்கிறது';
        case 'open_routine':
          return 'வழக்கம் திறக்கிறது';
        case 'open_appointments':
          return 'சந்திப்புகள் திறக்கிறது';
        case 'open_games':
          return 'விளையாட்டு திறக்கிறது';
        case 'open_settings':
          return 'அமைப்புகள் திறக்கிறது';
        case 'go_home':
          return 'வீட்டிற்கு செல்கிறது';
        case 'status_report':
          return 'உங்கள் நிலை சொல்கிறேன்';
        case 'log_water':
          return 'தண்ணீர் பதிவு செய்கிறேன்';
        default:
          return 'புரியவில்லை';
      }
    }
    switch (actionKey) {
      case 'open_medicine':
        return 'Opening Medicines';
      case 'open_hydration':
        return 'Opening Hydration';
      case 'open_routine':
        return 'Opening Routine';
      case 'open_appointments':
        return 'Opening Appointments';
      case 'open_games':
        return 'Opening Games';
      case 'open_settings':
        return 'Opening Settings';
      case 'go_home':
        return 'Going Home';
      case 'status_report':
        return 'Here is your status';
      case 'log_water':
        return 'Logging water';
      default:
        return "Sorry, I didn't understand.";
    }
  }

  static bool _containsAny(String text, List<String> keywords) {
    for (final k in keywords) {
      if (text.contains(k)) return true;
    }
    return false;
  }
}
