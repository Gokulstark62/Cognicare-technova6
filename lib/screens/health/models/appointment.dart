import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

class Appointment {
  final String id;
  final String doctorName;
  final String specialty;
  final DateTime dateTime;
  final String location;
  final String notes;
  final int iconCodePoint;

  Appointment({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.dateTime,
    required this.location,
    required this.notes,
    required this.iconCodePoint,
  });

  IconData get icon =>
      IconData(iconCodePoint, fontFamily: 'MaterialIcons');

  bool get isUpcoming => dateTime.isAfter(DateTime.now());

  String get formattedDate {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${dateTime.day.toString().padLeft(2, '0')} '
        '${months[dateTime.month - 1]} ${dateTime.year}';
  }

  String get formattedTime {
    final h = dateTime.hour == 0
        ? 12
        : (dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour);
    final m = dateTime.minute.toString().padLeft(2, '0');
    final ampm = dateTime.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $ampm';
  }

  /// Localized countdown string.
  String countdownLocalized(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final diff = target.difference(today).inDays;

    if (diff == 0) return l10n.todayWord;
    if (diff == 1) return l10n.tomorrowWord;
    if (diff == -1) return l10n.yesterdayWord;
    if (diff > 1) return l10n.inDays(diff);
    return l10n.daysAgo(-diff);
  }

  // ─── JSON (shared_preferences) ──────────────
  Map<String, dynamic> toJson() => {
        'id': id,
        'doctor_name': doctorName,
        'specialty': specialty,
        'date_time_ms': dateTime.millisecondsSinceEpoch,
        'location': location,
        'notes': notes,
        'icon_code_point': iconCodePoint,
      };

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
        id: json['id'] as String,
        doctorName: json['doctor_name'] as String,
        specialty: json['specialty'] as String,
        dateTime: DateTime.fromMillisecondsSinceEpoch(
          json['date_time_ms'] as int,
        ),
        location: json['location'] as String,
        notes: json['notes'] as String,
        iconCodePoint: json['icon_code_point'] as int,
      );

  // ─── Map (future SQLite) ─────────────────────
  Map<String, dynamic> toMap() => {
        'id': id,
        'doctor_name': doctorName,
        'specialty': specialty,
        'date_time_ms': dateTime.millisecondsSinceEpoch,
        'location': location,
        'notes': notes,
        'icon_code_point': iconCodePoint,
      };

  factory Appointment.fromMap(Map<String, dynamic> map) => Appointment(
        id: map['id'] as String,
        doctorName: map['doctor_name'] as String,
        specialty: map['specialty'] as String,
        dateTime: DateTime.fromMillisecondsSinceEpoch(
          map['date_time_ms'] as int,
        ),
        location: map['location'] as String,
        notes: map['notes'] as String,
        iconCodePoint: map['icon_code_point'] as int,
      );
}