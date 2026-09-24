import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/medicine.dart';
import 'sample_medicines.dart';

/// Persistent store for medicines.
/// Uses shared_preferences + JSON so it works on Chrome AND Android.
class MedicineStore {
  MedicineStore._();
  static final MedicineStore instance = MedicineStore._();

  static const String _key = 'medicines_v1';

  List<Medicine> medicines = [];
  int _idCounter = 100;
  bool _loaded = false;

  Future<void> load() async {
    if (_loaded) {
      debugPrint('📖 MedicineStore: already loaded');
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);

    debugPrint('📖 MedicineStore: raw = '
        '${raw == null ? "null" : "${raw.length} chars"}');

    if (raw == null) {
      medicines = getSampleMedicines();
      await _save();
    } else {
      try {
        final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
        medicines = list
            .map((e) => Medicine.fromJson(e as Map<String, dynamic>))
            .toList();
        debugPrint('📖 MedicineStore: loaded ${medicines.length}');
      } catch (e) {
        debugPrint('📖 MedicineStore: parse error $e');
        medicines = getSampleMedicines();
        await _save();
      }
    }
    _loaded = true;
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(medicines.map((m) => m.toJson()).toList());
    await prefs.setString(_key, raw);
    debugPrint('💾 MedicineStore: saved ${medicines.length} '
        '(${raw.length} chars)');
  }

  Future<void> add(Medicine med) async {
    medicines.add(med);
    await _save();
  }

  Future<void> update(Medicine med) async {
    final index = medicines.indexWhere((m) => m.id == med.id);
    if (index != -1) {
      medicines[index] = med;
      await _save();
    }
  }

  Future<void> remove(String id) async {
    medicines.removeWhere((m) => m.id == id);
    await _save();
  }

  Future<void> persistToggle() async {
    await _save();
  }

  Medicine? findById(String id) {
    try {
      return medicines.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  String generateId() {
    _idCounter++;
    return 'user_$_idCounter';
  }
}