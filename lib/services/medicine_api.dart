import 'api_client.dart';

/// Talks to backend /medicines endpoints.
class MedicineApi {
  MedicineApi._();
  static final MedicineApi instance = MedicineApi._();

  final _api = ApiClient.instance;

  /// GET /medicines — fetch all medicines for current user.
  Future<List<Map<String, dynamic>>> getAll() async {
    try {
      final list = await _api.getList('/medicines');
      return list.cast<Map<String, dynamic>>();
    } catch (e) {
      // If not logged in or backend down, return empty
      return [];
    }
  }

  /// POST /medicines — create new.
  Future<Map<String, dynamic>?> create({
    required String name,
    required String dosage,
    required String purpose,
    required int timeHour,
    required int timeMinute,
  }) async {
    try {
      return await _api.post('/medicines', body: {
        'name': name,
        'dosage': dosage,
        'purpose': purpose,
        'time_hour': timeHour,
        'time_minute': timeMinute,
      });
    } catch (e) {
      return null;
    }
  }

  /// PUT /medicines/{id} — update.
  Future<Map<String, dynamic>?> update(int id, Map<String, dynamic> body) async {
    try {
      return await _api.put('/medicines/$id', body: body);
    } catch (e) {
      return null;
    }
  }

  /// DELETE /medicines/{id}
  Future<bool> delete(int id) async {
    try {
      await _api.delete('/medicines/$id');
      return true;
    } catch (e) {
      return false;
    }
  }

  /// POST /medicines/{id}/toggle
  Future<Map<String, dynamic>?> toggle(int id) async {
    try {
      return await _api.post('/medicines/$id/toggle');
    } catch (e) {
      return null;
    }
  }
}