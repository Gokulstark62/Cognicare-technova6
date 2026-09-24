import 'package:flutter/material.dart';

/// Represents a single medicine the user takes.
class Medicine {
  final String id;
  final String name;
  final String dosage;
  final String purpose;
  final TimeOfDay time;
  bool taken;

  Medicine({
    required this.id,
    required this.name,
    required this.dosage,
    required this.purpose,
    required this.time,
    this.taken = false,
  });

  /// "Morning", "Afternoon", "Evening", "Night"
  String get period {
    final h = time.hour;
    if (h >= 5 && h < 12) return 'Morning';
    if (h >= 12 && h < 17) return 'Afternoon';
    if (h >= 17 && h < 21) return 'Evening';
    return 'Night';
  }

  /// "8:00 AM"
  String get formattedTime {
    final h = time.hour == 0
        ? 12
        : (time.hour > 12 ? time.hour - 12 : time.hour);
    final m = time.minute.toString().padLeft(2, '0');
    final ampm = time.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $ampm';
  }

  // ─── JSON (shared_preferences) ──────────────
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'dosage': dosage,
        'purpose': purpose,
        'time_hour': time.hour,
        'time_minute': time.minute,
        'taken': taken,
      };

  factory Medicine.fromJson(Map<String, dynamic> json) => Medicine(
        id: json['id'] as String,
        name: json['name'] as String,
        dosage: json['dosage'] as String,
        purpose: json['purpose'] as String,
        time: TimeOfDay(
          hour: json['time_hour'] as int,
          minute: json['time_minute'] as int,
        ),
        taken: json['taken'] as bool? ?? false,
      );

  // ─── Map (future SQLite) ─────────────────────
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'dosage': dosage,
        'purpose': purpose,
        'time_hour': time.hour,
        'time_minute': time.minute,
        'taken': taken ? 1 : 0,
      };

  factory Medicine.fromMap(Map<String, dynamic> map) => Medicine(
        id: map['id'] as String,
        name: map['name'] as String,
        dosage: map['dosage'] as String,
        purpose: map['purpose'] as String,
        time: TimeOfDay(
          hour: map['time_hour'] as int,
          minute: map['time_minute'] as int,
        ),
        taken: (map['taken'] as int? ?? 0) == 1,
      );
}