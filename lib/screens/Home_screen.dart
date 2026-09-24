import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import 'health/data/medicine_store.dart';
import 'health/data/hydration_store.dart';
import 'health/data/routine_store.dart';
import 'health/data/appointment_store.dart';

class HomeScreen extends StatefulWidget {
  final void Function(int)? onNavigateToTab;

  const HomeScreen({super.key, this.onNavigateToTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final medStore = MedicineStore.instance;
    final hydStore = HydrationStore.instance;
    final routineStore = RoutineStore.instance;
    final apptStore = AppointmentStore.instance;

    final medicines = medStore.medicines;
    final medsTaken = medicines.where((m) => m.taken).length;
    final medsTotal = medicines.length;
    final waterTotal = hydStore.todayTotal;
    final waterGoal = hydStore.dailyGoal;
    final nextAppt =
        apptStore.upcoming.isNotEmpty ? apptStore.upcoming.first : null;

    final now = DateTime.now();
    final scheduleItems = <_ScheduleItem>[];

    for (final med in medicines) {
      scheduleItems.add(_ScheduleItem(
        minutes: med.time.hour * 60 + med.time.minute,
        icon: Icons.medication,
        color: med.taken ? AppTheme.green : AppTheme.primary,
        title: '${med.name} ${med.dosage}',
        time: med.formattedTime,
        done: med.taken,
      ));
    }

    for (final act in routineStore.activities) {
      scheduleItems.add(_ScheduleItem(
        minutes: act.time.hour * 60 + act.time.minute,
        icon: act.icon,
        color: AppTheme.purple,
        title: act.name,
        time: act.formattedTime,
        done: false,
      ));
    }

    scheduleItems.sort((a, b) => a.minutes.compareTo(b.minutes));
    final visibleSchedule = scheduleItems.take(6).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_greeting(context)}, Ramesh!',
                          style: GoogleFonts.nunito(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formattedToday(now),
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined, size: 26),
                    onPressed: () => context.push('/settings'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primary.withOpacity(0.12),
                      AppTheme.primary.withOpacity(0.04),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                      color: AppTheme.primary.withOpacity(0.25), width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.insights,
                            color: AppTheme.primary, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          l10n.todaysProgress,
                          style: GoogleFonts.nunito(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _ProgressRow(
                      icon: Icons.medication_outlined,
                      color: AppTheme.green,
                      label: l10n.medicines,
                      value: medsTotal == 0
                          ? l10n.noMedicines
                          : '$medsTaken / $medsTotal ${l10n.taken}',
                      fraction: medsTotal == 0 ? 0 : medsTaken / medsTotal,
                    ),
                    const SizedBox(height: 12),
                    _ProgressRow(
                      icon: Icons.water_drop_outlined,
                      color: AppTheme.primary,
                      label: l10n.hydration,
                      value: '$waterTotal / $waterGoal ${l10n.glasses}',
                      fraction: waterGoal == 0
                          ? 0
                          : (waterTotal / waterGoal).clamp(0, 1),
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.event,
                      color: AppTheme.teal,
                      label: l10n.nextAppointment,
                      value: nextAppt == null
                          ? l10n.noneScheduled
                          : '${nextAppt.doctorName} • '
                              '${nextAppt.countdownLocalized(context)}',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                l10n.quickActions,
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.6,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _QuickAction(
                    icon: Icons.medication_outlined,
                    label: l10n.myMedicines,
                    color: AppTheme.green,
                    onTap: () => context.push('/medicine'),
                  ),
                  _QuickAction(
                    icon: Icons.water_drop_outlined,
                    label: l10n.logWater,
                    color: AppTheme.primary,
                    onTap: () => context.push('/hydration'),
                  ),
                  _QuickAction(
                    icon: Icons.event_note,
                    label: l10n.myRoutine,
                    color: AppTheme.purple,
                    onTap: () => context.push('/routine'),
                  ),
                  _QuickAction(
                    icon: Icons.games_outlined,
                    label: l10n.playGames,
                    color: AppTheme.pink,
                    onTap: () => widget.onNavigateToTab?.call(1),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.todaysSchedule,
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/routine'),
                    child: Text(
                      l10n.seeAll,
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              if (visibleSchedule.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.event_available,
                          color: AppTheme.textSecondary, size: 40),
                      const SizedBox(height: 8),
                      Text(
                        l10n.nothingScheduled,
                        style: GoogleFonts.nunito(
                          fontSize: 15,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
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
                    children: List.generate(visibleSchedule.length, (i) {
                      final item = visibleSchedule[i];
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: item.color.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(item.icon,
                                      color: item.color, size: 22),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        style: GoogleFonts.nunito(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                          color: AppTheme.textPrimary,
                                          decoration: item.done
                                              ? TextDecoration.lineThrough
                                              : null,
                                        ),
                                      ),
                                      Text(
                                        item.time,
                                        style: GoogleFonts.nunito(
                                          fontSize: 13,
                                          color: AppTheme.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (item.done)
                                  const Icon(Icons.check_circle,
                                      color: AppTheme.green, size: 22),
                              ],
                            ),
                          ),
                          if (i < visibleSchedule.length - 1)
                            const Divider(height: 1, indent: 60),
                        ],
                      );
                    }),
                  ),
                ),
              const SizedBox(height: 20),

              Center(
                child: TextButton(
                  onPressed: () => context.go('/login'),
                  child: Text(
                    l10n.logOut,
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _greeting(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final h = DateTime.now().hour;
    if (h < 12) return l10n.goodMorning;
    if (h < 17) return l10n.goodAfternoon;
    if (h < 21) return l10n.goodEvening;
    return l10n.goodNight;
  }

  String _formattedToday(DateTime now) {
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday',
    ];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${days[now.weekday - 1]}, ${now.day} '
        '${months[now.month - 1]} ${now.year}';
  }
}

class _ScheduleItem {
  final int minutes;
  final IconData icon;
  final Color color;
  final String title;
  final String time;
  final bool done;

  _ScheduleItem({
    required this.minutes,
    required this.icon,
    required this.color,
    required this.title,
    required this.time,
    required this.done,
  });
}

class _ProgressRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;
  final double fraction;

  const _ProgressRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    required this.fraction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            Text(
              value,
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 8,
            backgroundColor: color.withOpacity(0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}