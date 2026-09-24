import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import 'models/medicine.dart';
import 'data/medicine_store.dart';

class AddEditMedicineScreen extends StatefulWidget {
  final String? medicineId;
  const AddEditMedicineScreen({super.key, this.medicineId});

  @override
  State<AddEditMedicineScreen> createState() =>
      _AddEditMedicineScreenState();
}

class _AddEditMedicineScreenState extends State<AddEditMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _dosageCtrl = TextEditingController();
  final _purposeCtrl = TextEditingController();

  TimeOfDay _time = const TimeOfDay(hour: 8, minute: 0);
  bool _isEditing = false;
  String? _existingId;

  @override
  void initState() {
    super.initState();
    final store = MedicineStore.instance;
    if (widget.medicineId != null) {
      final med = store.findById(widget.medicineId!);
      if (med != null) {
        _isEditing = true;
        _existingId = med.id;
        _nameCtrl.text = med.name;
        _dosageCtrl.text = med.dosage;
        _purposeCtrl.text = med.purpose;
        _time = med.time;
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dosageCtrl.dispose();
    _purposeCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppTheme.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _time = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final store = MedicineStore.instance;

    if (_isEditing && _existingId != null) {
      final existing = store.findById(_existingId!);
      if (existing != null) {
        final updated = Medicine(
          id: existing.id,
          name: _nameCtrl.text.trim(),
          dosage: _dosageCtrl.text.trim(),
          purpose: _purposeCtrl.text.trim(),
          time: _time,
          taken: existing.taken,
        );
        await store.update(updated);
      }
    } else {
      final newMed = Medicine(
        id: store.generateId(),
        name: _nameCtrl.text.trim(),
        dosage: _dosageCtrl.text.trim(),
        purpose: _purposeCtrl.text.trim(),
        time: _time,
      );
      await store.add(newMed);
    }

    if (mounted) context.pop();
  }

  Future<void> _confirmDelete() async {
    final l10n = AppLocalizations.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          l10n.deleteMedicine,
          style: GoogleFonts.nunito(
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Text(
          l10n.deleteMedicineMessage,
          style: GoogleFonts.nunito(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(
              l10n.cancel,
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              l10n.delete,
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppTheme.pink,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && _existingId != null) {
      await MedicineStore.instance.remove(_existingId!);
      if (mounted) context.pop();
    }
  }

  String get _formattedTime {
    final h =
        _time.hour == 0 ? 12 : (_time.hour > 12 ? _time.hour - 12 : _time.hour);
    final m = _time.minute.toString().padLeft(2, '0');
    final ampm = _time.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $ampm';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(_isEditing ? l10n.editMedicine : l10n.addMedicine),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: AppTheme.pink,
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.medication,
                        color: AppTheme.primary, size: 40),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameCtrl,
                  textCapitalization: TextCapitalization.words,
                  style: GoogleFonts.nunito(fontSize: 17),
                  decoration: InputDecoration(
                    labelText: l10n.medicineName,
                    hintText: l10n.medicineHintName,
                    prefixIcon: const Icon(Icons.medical_services_outlined),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.pleaseEnterMedicineName
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _dosageCtrl,
                  style: GoogleFonts.nunito(fontSize: 17),
                  decoration: InputDecoration(
                    labelText: l10n.dosage,
                    hintText: l10n.medicineHintDosage,
                    prefixIcon: const Icon(Icons.science_outlined),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.pleaseEnterDosage
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _purposeCtrl,
                  textCapitalization: TextCapitalization.sentences,
                  style: GoogleFonts.nunito(fontSize: 17),
                  decoration: InputDecoration(
                    labelText: l10n.purpose,
                    hintText: l10n.medicineHintPurpose,
                    prefixIcon: const Icon(Icons.info_outline),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.pleaseEnterPurpose
                      : null,
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _pickTime,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFCFD8DC)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.schedule,
                            color: AppTheme.textSecondary, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.timeLabel,
                                style: GoogleFonts.nunito(
                                  fontSize: 13,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              Text(
                                _formattedTime,
                                style: GoogleFonts.nunito(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.edit_outlined,
                            color: AppTheme.primary, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.check),
                    label: Text(_isEditing
                        ? l10n.saveChanges
                        : l10n.addMedicineButton),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 58),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}