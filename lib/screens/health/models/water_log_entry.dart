/// A single water intake event — timestamped.
class WaterLogEntry {
  final DateTime timestamp;
  final int glasses;

  WaterLogEntry({
    required this.timestamp,
    required this.glasses,
  });

  /// "8:15 AM"
  String get formattedTime {
    final h = timestamp.hour == 0
        ? 12
        : (timestamp.hour > 12 ? timestamp.hour - 12 : timestamp.hour);
    final m = timestamp.minute.toString().padLeft(2, '0');
    final ampm = timestamp.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $ampm';
  }

  /// "1 glass" or "2 glasses"
  String get glassesLabel => glasses == 1 ? '1 glass' : '$glasses glasses';

  // ─── JSON (shared_preferences) ──────────────
  Map<String, dynamic> toJson() => {
        'timestamp_ms': timestamp.millisecondsSinceEpoch,
        'glasses': glasses,
      };

  factory WaterLogEntry.fromJson(Map<String, dynamic> json) => WaterLogEntry(
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          json['timestamp_ms'] as int,
        ),
        glasses: json['glasses'] as int,
      );

  // ─── Map (future SQLite) ─────────────────────
  Map<String, dynamic> toMap() => {
        'timestamp_ms': timestamp.millisecondsSinceEpoch,
        'glasses': glasses,
      };

  factory WaterLogEntry.fromMap(Map<String, dynamic> map) => WaterLogEntry(
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          map['timestamp_ms'] as int,
        ),
        glasses: map['glasses'] as int,
      );
}