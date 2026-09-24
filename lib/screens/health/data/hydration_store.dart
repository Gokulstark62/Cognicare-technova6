import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/water_log_entry.dart';

/// Persistent store for hydration data.
/// Uses shared_preferences + JSON.
class HydrationStore {
  HydrationStore._();
  static final HydrationStore instance = HydrationStore._();

  static const String _logKey = 'hydration_log_v1';
  static const String _goalKey = 'hydration_goal_v1';

  final List<WaterLogEntry> log = [];
  int dailyGoal = 8;
  bool _loaded = false;

  int get todayTotal => log.fold(0, (sum, entry) => sum + entry.glasses);

  int get remaining {
    final r = dailyGoal - todayTotal;
    return r < 0 ? 0 : r;
  }

  double get progress {
    if (dailyGoal == 0) return 0;
    final p = todayTotal / dailyGoal;
    return p > 1.0 ? 1.0 : p;
  }

  bool get isGoalReached => todayTotal >= dailyGoal;

  Future<void> load() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();

    dailyGoal = prefs.getInt(_goalKey) ?? 8;

    final raw = prefs.getString(_logKey);
    debugPrint('📖 HydrationStore: log raw = '
        '${raw == null ? "null" : "${raw.length} chars"}');
    if (raw != null) {
      try {
        final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
        log.clear();
        log.addAll(list
            .map((e) => WaterLogEntry.fromJson(e as Map<String, dynamic>))
            .toList());
        debugPrint('📖 HydrationStore: loaded ${log.length}');
      } catch (e) {
        debugPrint('📖 HydrationStore: parse error $e');
        log.clear();
      }
    }
    _loaded = true;
  }

  Future<void> _saveLog() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(log.map((e) => e.toJson()).toList());
    await prefs.setString(_logKey, raw);
    debugPrint('💾 HydrationStore: saved ${log.length} entries');
  }

  Future<void> _saveGoal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_goalKey, dailyGoal);
    debugPrint('💾 HydrationStore: saved goal $dailyGoal');
  }

  Future<void> addGlasses(int n) async {
    log.add(WaterLogEntry(timestamp: DateTime.now(), glasses: n));
    await _saveLog();
  }

  Future<void> removeLast() async {
    if (log.isNotEmpty) {
      log.removeLast();
      await _saveLog();
    }
  }

  Future<void> resetToday() async {
    log.clear();
    await _saveLog();
  }

  Future<void> setGoal(int g) async {
    dailyGoal = g < 1 ? 1 : g;
    await _saveGoal();
  }
}