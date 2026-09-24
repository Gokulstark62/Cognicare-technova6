import '../screens/health/data/medicine_store.dart';
import '../screens/health/data/hydration_store.dart';
import '../screens/health/data/appointment_store.dart';

/// Builds a natural-language health summary.
class StatusService {
  StatusService._();
  static final StatusService instance = StatusService._();

  /// Simple helper to compute a countdown string without needing context.
  String _countdown(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(dt.year, dt.month, dt.day);
    final diff = target.difference(today).inDays;
    if (diff == 0) return 'today';
    if (diff == 1) return 'tomorrow';
    if (diff == -1) return 'yesterday';
    if (diff > 1) return 'in $diff days';
    return '${-diff} days ago';
  }

  Future<String> buildEnglish() async {
    final meds = MedicineStore.instance.medicines;
    final hyd = HydrationStore.instance;
    final appt = AppointmentStore.instance;

    final medsTaken = meds.where((m) => m.taken).length;
    final medsTotal = meds.length;
    final water = hyd.todayTotal;
    final goal = hyd.dailyGoal;
    final next = appt.upcoming.isNotEmpty ? appt.upcoming.first : null;

    final buffer = StringBuffer();

    if (medsTotal == 0) {
      buffer.write('You have no medicines set up. ');
    } else if (medsTaken == medsTotal) {
      buffer.write('Great! You have taken all $medsTotal medicines. ');
    } else {
      buffer.write('You have taken $medsTaken of $medsTotal medicines. ');
    }

    if (water >= goal) {
      buffer.write('You have reached your water goal of $goal glasses. ');
    } else {
      buffer.write('You have had $water of $goal glasses of water. ');
    }

    if (next != null) {
      buffer.write(
        'Your next appointment is with ${next.doctorName} ${_countdown(next.dateTime)}.',
      );
    } else {
      buffer.write('You have no upcoming appointments.');
    }

    return buffer.toString().trim();
  }

  Future<String> buildTamil() async {
    final meds = MedicineStore.instance.medicines;
    final hyd = HydrationStore.instance;
    final appt = AppointmentStore.instance;

    final medsTaken = meds.where((m) => m.taken).length;
    final medsTotal = meds.length;
    final water = hyd.todayTotal;
    final goal = hyd.dailyGoal;
    final next = appt.upcoming.isNotEmpty ? appt.upcoming.first : null;

    final buffer = StringBuffer();

    if (medsTotal == 0) {
      buffer.write('மருந்துகள் எதுவும் அமைக்கப்படவில்லை. ');
    } else if (medsTaken == medsTotal) {
      buffer.write('அருமை! $medsTotal மருந்துகளையும் எடுத்துவிட்டீர்கள். ');
    } else {
      buffer.write('$medsTotal மருந்துகளில் $medsTaken எடுத்திருக்கிறீர்கள். ');
    }

    if (water >= goal) {
      buffer.write('$goal கிளாஸ் தண்ணீர் இலக்கை அடைந்துவிட்டீர்கள். ');
    } else {
      buffer.write('$goal கிளாஸ் தண்ணீரில் $water குடித்திருக்கிறீர்கள். ');
    }

    if (next != null) {
      buffer.write('அடுத்த சந்திப்பு ${next.doctorName} உடன்.');
    } else {
      buffer.write('வரவிருக்கும் சந்திப்புகள் இல்லை.');
    }

    return buffer.toString().trim();
  }
}