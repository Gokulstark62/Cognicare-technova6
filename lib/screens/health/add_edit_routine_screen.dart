import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import 'models/routine_activity.dart';
import 'data/routine_store.dart';

class AddEditRoutineScreen extends StatefulWidget {
  final String? activityId;

  const AddEditRoutineScreen({super.key, this.activityId});

  @override
  State<AddEditRoutineScreen> createState() => _AddEditRoutineScreenState();
}

class _AddEditRoutineScreenState extends State<AddEditRoutineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  TimeOfDay _time = const TimeOfDay(hour: 8, minute: 0);
  int _iconCodePoint = Icons.event.codePoint;

  bool _isEditing = false;
  String? _existingId;

  static final List<IconData> _iconOptions = [
    Icons.wb_twilight,
    Icons.wb_sunny_outlined,
    Icons.nightlight_outlined,
    Icons.breakfast_dining,
    Icons.lunch_dining,
    Icons.dinner_dining,
    Icons.local_cafe,
    Icons.emoji_food_beverage,
    Icons.directions_walk,
    Icons.directions_run,
    Icons.self_improvement,
    Icons.fitness_center,
    Icons.bedtime_outlined,
    Icons.menu_book,
    Icons.brush,
    Icons.music_note,
    Icons.phone_outlined,
    Icons.family_restroom,
    Icons.pets,
    Icons.local_florist,
    Icons.spa_outlined,
    Icons.church_outlined,
    Icons.medication_outlined,
    Icons.event,
  ];

  @override
  void initState() {
    super.initState();
    final store = RoutineStore.instance;

    if (widget.activityId != null) {
      final a = store.findById(widget.activityId!);
      if (a != null) {
        _isEditing = true;
        _existingId = a.id;
        _nameCtrl.text = a.name;
        _descCtrl.text = a.description;
        _time = a.time;
        _iconCodePoint = a.iconCodePoint;
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
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

    final store = RoutineStore.instance;

    if (_isEditing && _existingId != null) {
      final updated = RoutineActivity(
        id: _existingId!,
        name: _nameCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        time: _time,
        iconCodePoint: _iconCodePoint,
      );
      await store.update(updated);
    } else {
      final newA = RoutineActivity(
        id: store.generateId(),
        name: _nameCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        time: _time,
        iconCodePoint: _iconCodePoint,
      );
      await store.add(newA);
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
          l10n.deleteActivity,
          style: GoogleFonts.nunito(
              fontSize: 20, fontWeight: FontWeight.w800),
        ),
        content: Text(
          l10n.deleteActivityMessage,
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
      await RoutineStore.instance.remove(_existingId!);
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
        title: Text(_isEditing ? l10n.editActivity : l10n.addActivity),
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
                  controller: _nameCtrl,
                  textCapitalization: TextCapitalization.words,
                  style: GoogleFonts.nunito(fontSize: 17),
                  decoration: InputDecoration(
                    labelText: l10n.activityName,
                    hintText: l10n.activityHintName,
                    prefixIcon: const Icon(Icons.title),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.pleaseEnterActivityName
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descCtrl,
                  textCapitalization: TextCapitalization.sentences,
                  style: GoogleFonts.nunito(fontSize: 17),
                  decoration: InputDecoration(
                    labelText: l10n.description,
                    hintText: l10n.activityHintDesc,
                    prefixIcon: const Icon(Icons.notes_outlined),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.pleaseAddDescription
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
                        : l10n.addActivityButton),
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