import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import 'models/medicine.dart';
import 'data/medicine_store.dart';

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({super.key});

  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  static const List<String> _periodOrder = [
    'Morning',
    'Afternoon',
    'Evening',
    'Night',
  ];

  MedicineStore get _store => MedicineStore.instance;

  int get _takenCount => _store.medicines.where((m) => m.taken).length;
  int get _totalCount => _store.medicines.length;

  Future<void> _toggleTaken(Medicine med) async {
    setState(() {
      med.taken = !med.taken;
    });
    await _store.persistToggle();
  }

  void _openAdd() {
    context.push('/medicine/add').then((_) => setState(() {}));
  }

  void _openEdit(Medicine med) {
    context.push('/medicine/edit/${med.id}').then((_) => setState(() {}));
  }

  String _periodLabel(BuildContext context, String period) {
    final l10n = AppLocalizations.of(context);
    switch (period) {
      case 'Morning':
        return l10n.morning;
      case 'Afternoon':
        return l10n.afternoon;
      case 'Evening':
        return l10n.evening;
      default:
        return l10n.night;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final medicines = _store.medicines;

    final grouped = <String, List<Medicine>>{};
    for (final p in _periodOrder) {
      grouped[p] = [];
    }
    for (final med in medicines) {
      grouped[med.period]!.add(med);
    }
    for (final p in _periodOrder) {
      grouped[p]!.sort((a, b) {
        final aMin = a.time.hour * 60 + a.time.minute;
        final bMin = b.time.hour * 60 + b.time.minute;
        return aMin.compareTo(bMin);
      });
    }

    final progress = _totalCount == 0 ? 0.0 : _takenCount / _totalCount;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        title: Text(l10n.myMedicinesTitle),
        actions: [
          TextButton.icon(
            onPressed: _openAdd,
            icon: const Icon(Icons.add, size: 22),
            label: Text(
              l10n.add,
              style: GoogleFonts.nunito(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.medication_outlined,
                        color: AppTheme.primary, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.todaysMedicines,
                          style: GoogleFonts.nunito(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Text(
                          l10n.tapMedicineWhenTaken,
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.todaysProgress,
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        Text(
                          '$_takenCount ${l10n.ofWord} $_totalCount',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: _takenCount == _totalCount &&
                                    _totalCount > 0
                                ? AppTheme.green
                                : AppTheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 12,
                        backgroundColor: AppTheme.primary.withOpacity(0.12),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _takenCount == _totalCount && _totalCount > 0
                              ? AppTheme.green
                              : AppTheme.primary,
                        ),
                      ),
                    ),
                    if (_takenCount == _totalCount && _totalCount > 0) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.celebration,
                              color: AppTheme.green, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            l10n.allDoneForToday,
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (medicines.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withOpacity(0.10),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.medication_outlined,
                              color: AppTheme.primary, size: 48),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noMedicinesYet,
                          style: GoogleFonts.nunito(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.tapAddFirstMedicine,
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ..._periodOrder.map((period) {
                final meds = grouped[period]!;
                if (meds.isEmpty) return const SizedBox.shrink();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 8),
                      child: Row(
                        children: [
                          Icon(_iconForPeriod(period),
                              color: _colorForPeriod(period), size: 20),
                          const SizedBox(width: 8),
                          Text(
                            _periodLabel(context, period),
                            style: GoogleFonts.nunito(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '(${meds.length})',
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...meds.map((med) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _MedicineTile(
                            medicine: med,
                            onTap: () => _toggleTaken(med),
                            onEdit: () => _openEdit(med),
                          ),
                        )),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForPeriod(String p) {
    switch (p) {
      case 'Morning':
        return Icons.wb_twilight;
      case 'Afternoon':
        return Icons.wb_sunny_outlined;
      case 'Evening':
        return Icons.wb_twilight;
      default:
        return Icons.nightlight_outlined;
    }
  }

  Color _colorForPeriod(String p) {
    switch (p) {
      case 'Morning':
        return AppTheme.amber;
      case 'Afternoon':
        return AppTheme.primary;
      case 'Evening':
        return AppTheme.orange;
      default:
        return AppTheme.purple;
    }
  }
}

class _MedicineTile extends StatelessWidget {
  final Medicine medicine;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const _MedicineTile({
    required this.medicine,
    required this.onTap,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final taken = medicine.taken;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: taken ? AppTheme.green.withOpacity(0.08) : Colors.white,
            border: Border.all(
              color: taken ? AppTheme.green : const Color(0xFFCFD8DC),
              width: taken ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: taken
                      ? AppTheme.green.withOpacity(0.15)
                      : AppTheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.medication,
                  color: taken ? AppTheme.green : AppTheme.primary,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${medicine.name} ${medicine.dosage}',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                        decoration: taken
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      medicine.purpose,
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.schedule,
                            size: 14, color: AppTheme.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          medicine.formattedTime,
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20),
                color: AppTheme.textSecondary,
                onPressed: onEdit,
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: taken ? AppTheme.green : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: taken ? AppTheme.green : const Color(0xFFB0BEC5),
                    width: 2,
                  ),
                ),
                child: taken
                    ? const Icon(Icons.check, color: Colors.white, size: 22)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}