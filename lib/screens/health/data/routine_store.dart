import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/routine_activity.dart';
import 'sample_routine.dart';

/// Persistent store for routine activities.
/// Uses shared_preferences + JSON.
class RoutineStore {
  RoutineStore._();
  static final RoutineStore instance = RoutineStore._();

  static const String _key = 'routine_v1';

  List<RoutineActivity> activities = [];
  int _idCounter = 100;
  bool _loaded = false;

  Future<void> load() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);

    debugPrint('📖 RoutineStore: raw = '
        '${raw == null ? "null" : "${raw.length} chars"}');

    if (raw == null) {
      activities = getSampleRoutine();
      await _save();
    } else {
      try {
        final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
        activities = list
            .map((e) =>
                RoutineActivity.fromJson(e as Map<String, dynamic>))
            .toList();
        debugPrint('📖 RoutineStore: loaded ${activities.length}');
      } catch (e) {
        debugPrint('📖 RoutineStore: parse error $e');
        activities = getSampleRoutine();
        await _save();
      }
    }
    _loaded = true;
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(activities.map((a) => a.toJson()).toList());
    await prefs.setString(_key, raw);
    debugPrint('💾 RoutineStore: saved ${activities.length} '
        '(${raw.length} chars)');
  }

  Future<void> add(RoutineActivity a) async {
    activities.add(a);
    await _save();
  }

  Future<void> update(RoutineActivity a) async {
    final index = activities.indexWhere((x) => x.id == a.id);
    if (index != -1) {
      activities[index] = a;
      await _save();
    }
  }

  Future<void> remove(String id) async {
    activities.removeWhere((a) => a.id == id);
    await _save();
  }

  RoutineActivity? findById(String id) {
    try {
      return activities.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  String generateId() {
    _idCounter++;
    return 'routine_$_idCounter';
  }
}