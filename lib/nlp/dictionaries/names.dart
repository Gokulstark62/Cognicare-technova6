/// Common Tamil / Indian first names.
/// Extend this with the elder's actual family members for better accuracy.
class NameDictionaries {
  /// Common male first names
  static const Set<String> maleNames = {
    'ரமேஷ்', 'குமார்', 'அர்ஜுன்', 'ரவி', 'சுரேஷ்', 'விஜய்',
    'அஜித்', 'சூர்யா', 'கார்த்திக்', 'பிரகாஷ்', 'முருகன்',
    'செல்வம்', 'வேலு', 'பாலு', 'கண்ணன்', 'மணி', 'கோபால்',
    'ராஜா', 'ராஜேஷ்', 'சந்தோஷ்', 'விக்ரம்', 'அரவிந்த்', 'தினேஷ்',
    'தமிழ்', 'பாலாஜி', 'கிருஷ்ணன்', 'ஷண்முகம்', 'வெங்கடேஷ்',
    // English spelling variants
    'Ramesh', 'Kumar', 'Arjun', 'Ravi', 'Suresh', 'Vijay',
    'Ajith', 'Surya', 'Karthik', 'Prakash', 'Murugan',
    'Selvam', 'Velu', 'Balu', 'Kannan', 'Mani', 'Gopal',
    'Raja', 'Rajesh', 'Santhosh', 'Vikram', 'Aravind', 'Dinesh',
    'Balaji', 'Krishnan', 'Shanmugam', 'Venkatesh',
  };

  /// Common female first names
  static const Set<String> femaleNames = {
    'பிரியா', 'லக்ஷ்மி', 'மீனா', 'சரஸ்வதி', 'கீதா', 'கவிதா',
    'தீபா', 'அனிதா', 'சுஜாதா', 'வாணி', 'ராதா', 'லதா',
    'கமலா', 'சாவித்ரி', 'மாலா', 'சித்ரா', 'ஜானகி', 'பத்மா',
    'இந்திரா', 'கலா', 'சாந்தி', 'கோமதி', 'ரேவதி', 'வசந்தி',
    // English spelling variants
    'Priya', 'Lakshmi', 'Meena', 'Saraswathi', 'Geetha', 'Kavitha',
    'Deepa', 'Anitha', 'Sujatha', 'Vani', 'Radha', 'Latha',
    'Kamala', 'Savitri', 'Mala', 'Chitra', 'Janaki', 'Padma',
    'Indira', 'Kala', 'Shanthi', 'Gomathi', 'Revathi', 'Vasanthi',
  };

  /// Relation words often following a name
  static const Set<String> relations = {
    'மகன்', 'மகள்', 'பேரன்', 'பேத்தி', 'அண்ணன்', 'தங்கை',
    'அக்கா', 'தம்பி', 'மாமா', 'அத்தை', 'சித்தி', 'சித்தப்பா',
    'மாமி', 'மாமன்', 'நாத்தனார்', 'மாமியார்', 'மாமனார்',
    'கணவன்', 'மனைவி', 'தந்தை', 'தாய்', 'அப்பா', 'அம்மா',
    'Son', 'Daughter', 'Grandson', 'Granddaughter', 'Brother', 'Sister',
  };
}