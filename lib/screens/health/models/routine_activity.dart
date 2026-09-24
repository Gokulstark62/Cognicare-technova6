import 'package:flutter/material.dart';

/// A single activity in the user's daily routine.
class RoutineActivity {
  final String id;
  final String name;
  final String description;
  final TimeOfDay time;
  final int iconCodePoint;

  RoutineActivity({
    required this.id,
    required this.name,
    required this.description,
    required this.time,
    required this.iconCodePoint,
  });

  /// Reconstruct the IconData for display.
  IconData get icon =>
      IconData(iconCodePoint, fontFamily: 'MaterialIcons');

  /// "Morning", "Afternoon", "Evening", "Night"
  String get period {
    final h = time.hour;
    if (h >= 5 && h < 12) return 'Morning';
    if (h >= 12 && h < 17) return 'Afternoon';
    if (h >= 17 && h < 21) return 'Evening';
    return 'Night';
  }

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
        'description': description,
        'time_hour': time.hour,
        'time_minute': time.minute,
        'icon_code_point': iconCodePoint,
      };

  factory RoutineActivity.fromJson(Map<String, dynamic> json) =>
      RoutineActivity(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        time: TimeOfDay(
          hour: json['time_hour'] as int,
          minute: json['time_minute'] as int,
        ),
        iconCodePoint: json['icon_code_point'] as int,
      );

  // ─── Map (future SQLite) ─────────────────────
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'time_hour': time.hour,
        'time_minute': time.minute,
        'icon_code_point': iconCodePoint,
      };

  factory RoutineActivity.fromMap(Map<String, dynamic> map) =>
      RoutineActivity(
        id: map['id'] as String,
        name: map['name'] as String,
        description: map['description'] as String,
        time: TimeOfDay(
          hour: map['time_hour'] as int,
          minute: map['time_minute'] as int,
        ),
        iconCodePoint: map['icon_code_point'] as int,
      );
}