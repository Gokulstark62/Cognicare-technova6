import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import 'models/routine_activity.dart';
import 'data/routine_store.dart';

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  static const List<String> _periodOrder = [
    'Morning',
    'Afternoon',
    'Evening',
    'Night',
  ];

  RoutineStore get _store => RoutineStore.instance;

  void _openAdd() {
    context.push('/routine/add').then((_) => setState(() {}));
  }

  void _openEdit(RoutineActivity a) {
    context.push('/routine/edit/${a.id}').then((_) => setState(() {}));
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
    final activities = _store.activities;

    final grouped = <String, List<RoutineActivity>>{};
    for (final p in _periodOrder) {
      grouped[p] = [];
    }
    for (final a in activities) {
      grouped[a.period]!.add(a);
    }
    for (final p in _periodOrder) {
      grouped[p]!.sort((a, b) {
        final aMin = a.time.hour * 60 + a.time.minute;
        final bMin = b.time.hour * 60 + b.time.minute;
        return aMin.compareTo(bMin);
      });
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        title: Text(l10n.myDailyRoutine),
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
                      color: AppTheme.purple.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.event_note,
                        color: AppTheme.purple, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.todaysSchedule2,
                          style: GoogleFonts.nunito(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Text(
                          l10n.activitiesPlanned(activities.length),
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
              const SizedBox(height: 24),
              if (activities.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppTheme.purple.withOpacity(0.10),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.event_note,
                              color: AppTheme.purple, size: 48),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noActivitiesYet,
                          style: GoogleFonts.nunito(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.tapAddPlanDay,
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
                final items = grouped[period]!;
                if (items.isEmpty) return const SizedBox.shrink();

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
                            '(${items.length})',
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...items.map((a) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _RoutineTile(
                            activity: a,
                            onEdit: () => _openEdit(a),
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

class _RoutineTile extends StatelessWidget {
  final RoutineActivity activity;
  final VoidCallback onEdit;

  const _RoutineTile({required this.activity, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCFD8DC)),
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
              color: AppTheme.purple.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(activity.icon,
                color: AppTheme.purple, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.name,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                if (activity.description.isNotEmpty)
                  Text(
                    activity.description,
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.schedule,
                        size: 14, color: AppTheme.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      activity.formattedTime,
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
        ],
      ),
    );
  }
}