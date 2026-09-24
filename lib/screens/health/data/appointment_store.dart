import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/appointment.dart';
import 'sample_appointments.dart';

/// Persistent store for appointments.
/// Uses shared_preferences + JSON.
class AppointmentStore {
  AppointmentStore._();
  static final AppointmentStore instance = AppointmentStore._();

  static const String _key = 'appointments_v1';

  List<Appointment> appointments = [];
  int _idCounter = 100;
  bool _loaded = false;

  Future<void> load() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);

    debugPrint('📖 AppointmentStore: raw = '
        '${raw == null ? "null" : "${raw.length} chars"}');

    if (raw == null) {
      appointments = getSampleAppointments();
      await _save();
    } else {
      try {
        final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
        appointments = list
            .map((e) => Appointment.fromJson(e as Map<String, dynamic>))
            .toList();
        debugPrint('📖 AppointmentStore: loaded ${appointments.length}');
      } catch (e) {
        debugPrint('📖 AppointmentStore: parse error $e');
        appointments = getSampleAppointments();
        await _save();
      }
    }
    _loaded = true;
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(appointments.map((a) => a.toJson()).toList());
    await prefs.setString(_key, raw);
    debugPrint('💾 AppointmentStore: saved ${appointments.length} '
        '(${raw.length} chars)');
  }

  Future<void> add(Appointment a) async {
    appointments.add(a);
    await _save();
  }

  Future<void> update(Appointment a) async {
    final index = appointments.indexWhere((x) => x.id == a.id);
    if (index != -1) {
      appointments[index] = a;
      await _save();
    }
  }

  Future<void> remove(String id) async {
    appointments.removeWhere((a) => a.id == id);
    await _save();
  }

  Appointment? findById(String id) {
    try {
      return appointments.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  String generateId() {
    _idCounter++;
    return 'appt_$_idCounter';
  }

  List<Appointment> get upcoming {
    final list = appointments.where((a) => a.isUpcoming).toList();
    list.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return list;
  }

  List<Appointment> get past {
    final list = appointments.where((a) => !a.isUpcoming).toList();
    list.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return list;
  }
}