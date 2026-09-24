import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import 'models/appointment.dart';
import 'data/appointment_store.dart';

class AddEditAppointmentScreen extends StatefulWidget {
  final String? appointmentId;

  const AddEditAppointmentScreen({super.key, this.appointmentId});

  @override
  State<AddEditAppointmentScreen> createState() =>
      _AddEditAppointmentScreenState();
}

class _AddEditAppointmentScreenState extends State<AddEditAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _doctorCtrl = TextEditingController();
  final _specialtyCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  DateTime _dateTime = DateTime.now().add(const Duration(days: 1));
  int _iconCodePoint = Icons.medical_services_outlined.codePoint;

  bool _isEditing = false;
  String? _existingId;

  static final List<IconData> _iconOptions = [
    Icons.medical_services_outlined,
    Icons.local_hospital_outlined,
    Icons.favorite_outline,
    Icons.healing_outlined,
    Icons.visibility_outlined,
    Icons.psychology_outlined,
    Icons.bloodtype_outlined,
    Icons.vaccines_outlined,
    Icons.monitor_heart_outlined,
    Icons.biotech_outlined,
    Icons.science_outlined,
    Icons.personal_injury_outlined,
  ];

  @override
  void initState() {
    super.initState();
    final store = AppointmentStore.instance;
    if (widget.appointmentId != null) {
      final a = store.findById(widget.appointmentId!);
      if (a != null) {
        _isEditing = true;
        _existingId = a.id;
        _doctorCtrl.text = a.doctorName;
        _specialtyCtrl.text = a.specialty;
        _locationCtrl.text = a.location;
        _notesCtrl.text = a.notes;
        _dateTime = a.dateTime;
        _iconCodePoint = a.iconCodePoint;
      }
    }
  }

  @override
  void dispose() {
    _doctorCtrl.dispose();
    _specialtyCtrl.dispose();
    _locationCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppTheme.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _dateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _dateTime.hour,
          _dateTime.minute,
        );
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dateTime),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppTheme.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _dateTime = DateTime(
          _dateTime.year,
          _dateTime.month,
          _dateTime.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final store = AppointmentStore.instance;

    if (_isEditing && _existingId != null) {
      await store.update(Appointment(
        id: _existingId!,
        doctorName: _doctorCtrl.text.trim(),
        specialty: _specialtyCtrl.text.trim(),
        dateTime: _dateTime,
        location: _locationCtrl.text.trim(),
        notes: _notesCtrl.text.trim(),
        iconCodePoint: _iconCodePoint,
      ));
    } else {
      await store.add(Appointment(
        id: store.generateId(),
        doctorName: _doctorCtrl.text.trim(),
        specialty: _specialtyCtrl.text.trim(),
        dateTime: _dateTime,
        location: _locationCtrl.text.trim(),
        notes: _notesCtrl.text.trim(),
        iconCodePoint: _iconCodePoint,
      ));
    }
    if (mounted) context.pop();
  }

  Future<void> _confirmDelete() async {
    final l10n = AppLocalizations.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          l10n.deleteAppointment,
          style: GoogleFonts.nunito(
              fontSize: 20, fontWeight: FontWeight.w800),
        ),
        content: Text(
          l10n.deleteAppointmentMessage,
          style: GoogleFonts.nunito(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              l10n.cancel,
              style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              l10n.delete,
              style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.pink),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && _existingId != null) {
      await AppointmentStore.instance.remove(_existingId!);
      if (mounted) context.pop();
    }
  }

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String get _formattedDate =>
      '${_dateTime.day.toString().padLeft(2, '0')} '
      '${_months[_dateTime.month - 1]} ${_dateTime.year}';

  String get _formattedTime {
    final h = _dateTime.hour == 0
        ? 12
        : (_dateTime.hour > 12 ? _dateTime.hour - 12 : _dateTime.hour);
    final m = _dateTime.minute.toString().padLeft(2, '0');
    final ampm = _dateTime.hour < 12 ? 'AM' : 'PM';
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
        title: Text(
            _isEditing ? l10n.editAppointment : l10n.addAppointment),
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
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      IconData(_iconCodePoint,
                          fontFamily: 'MaterialIcons'),
                      color: AppTheme.primary,
                      size: 44,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _doctorCtrl,
                  textCapitalization: TextCapitalization.words,
                  style: GoogleFonts.nunito(fontSize: 17),
                  decoration: InputDecoration(
                    labelText: l10n.doctorName,
                    hintText: l10n.doctorHintName,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.pleaseEnterDoctorName
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _specialtyCtrl,
                  textCapitalization: TextCapitalization.words,
                  style: GoogleFonts.nunito(fontSize: 17),
                  decoration: InputDecoration(
                    labelText: l10n.specialty,
                    hintText: l10n.doctorHintSpecialty,
                    prefixIcon: const Icon(Icons.badge_outlined),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.pleaseEnterSpecialty
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _locationCtrl,
                  textCapitalization: TextCapitalization.words,
                  style: GoogleFonts.nunito(fontSize: 17),
                  decoration: InputDecoration(
                    labelText: l10n.location,
                    hintText: l10n.doctorHintLocation,
                    prefixIcon: const Icon(Icons.location_on_outlined),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.pleaseEnterLocation
                      : null,
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _pickDate,
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
                        const Icon(Icons.calendar_today_outlined,
                            color: AppTheme.textSecondary, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.date,
                                style: GoogleFonts.nunito(
                                    fontSize: 13,
                                    color: AppTheme.textSecondary),
                              ),
                              Text(
                                _formattedDate,
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
                                    color: AppTheme.textSecondary),
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
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesCtrl,
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  style: GoogleFonts.nunito(fontSize: 16),
                  decoration: InputDecoration(
                    labelText: l10n.notesOptional,
                    hintText: l10n.doctorHintNotes,
                    prefixIcon: const Icon(Icons.notes_outlined),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.chooseAnIcon,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFCFD8DC)),
                  ),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _iconOptions.map((ic) {
                      final selected = ic.codePoint == _iconCodePoint;
                      return GestureDetector(
                        onTap: () => setState(
                            () => _iconCodePoint = ic.codePoint),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: selected
                                ? AppTheme.primary.withOpacity(0.15)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: selected
                                  ? AppTheme.primary
                                  : const Color(0xFFCFD8DC),
                              width: selected ? 2 : 1,
                            ),
                          ),
                          child: Icon(
                            ic,
                            color: selected
                                ? AppTheme.primary
                                : AppTheme.textSecondary,
                            size: 26,
                          ),
                        ),
                      );
                    }).toList(),
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
                        : l10n.addAppointmentButton),
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