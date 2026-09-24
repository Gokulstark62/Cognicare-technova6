/// Common task-related Tamil keywords.
class TaskKeywords {
  /// Maps a trigger word → its canonical task type.
  static const Map<String, String> mapping = {
    // Medicine
    'மருந்து': 'medicine',
    'மாத்திரை': 'medicine',
    'டேப்லெட்': 'medicine',

    // Water
    'தண்ணீர்': 'water',
    'நீர்': 'water',

    // Food
    'உணவு': 'food',
    'சாப்பாடு': 'food',
    'சாப்பிட': 'food',
    'காலை உணவு': 'breakfast',
    'மதிய உணவு': 'lunch',
    'இரவு உணவு': 'dinner',
    'டிபன்': 'breakfast',
    'டின்னர்': 'dinner',

    // Sleep / rest
    'தூக்கம்': 'sleep',
    'ஓய்வு': 'rest',

    // Exercise
    'நடை': 'walk',
    'நடைப்பயிற்சி': 'walk',
    'உடற்பயிற்சி': 'exercise',

    // Appointments
    'மருத்துவர்': 'doctor',
    'டாக்டர்': 'doctor',
    'சந்திப்பு': 'appointment',
    'செக்-அப்': 'checkup',

    // Family / calls
    'அழைப்பு': 'call',
    'பேச': 'call',
    'குடும்பம்': 'family',
  };
}