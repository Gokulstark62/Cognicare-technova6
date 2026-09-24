import 'package:flutter/material.dart';
import '../models/routine_activity.dart';

List<RoutineActivity> getSampleRoutine() {
  return [
    RoutineActivity(
      id: 'r1',
      name: 'Wake Up',
      description: 'Start your day with a stretch',
      time: const TimeOfDay(hour: 6, minute: 30),
      iconCodePoint: Icons.wb_twilight.codePoint,
    ),
    RoutineActivity(
      id: 'r2',
      name: 'Morning Walk',
      description: '20 minutes of walking',
      time: const TimeOfDay(hour: 7, minute: 0),
      iconCodePoint: Icons.directions_walk.codePoint,
    ),
    RoutineActivity(
      id: 'r3',
      name: 'Breakfast',
      description: 'Healthy start to the day',
      time: const TimeOfDay(hour: 8, minute: 0),
      iconCodePoint: Icons.breakfast_dining.codePoint,
    ),
    RoutineActivity(
      id: 'r4',
      name: 'Lunch',
      description: 'Balanced meal',
      time: const TimeOfDay(hour: 13, minute: 0),
      iconCodePoint: Icons.lunch_dining.codePoint,
    ),
    RoutineActivity(
      id: 'r5',
      name: 'Afternoon Nap',
      description: 'Rest for 30 minutes',
      time: const TimeOfDay(hour: 15, minute: 0),
      iconCodePoint: Icons.bedtime_outlined.codePoint,
    ),
    RoutineActivity(
      id: 'r6',
      name: 'Evening Tea',
      description: 'Relax with a cup',
      time: const TimeOfDay(hour: 17, minute: 30),
      iconCodePoint: Icons.emoji_food_beverage.codePoint,
    ),
    RoutineActivity(
      id: 'r7',
      name: 'Dinner',
      description: 'Light meal',
      time: const TimeOfDay(hour: 20, minute: 0),
      iconCodePoint: Icons.dinner_dining.codePoint,
    ),
    RoutineActivity(
      id: 'r8',
      name: 'Bedtime',
      description: 'Sleep well',
      time: const TimeOfDay(hour: 22, minute: 0),
      iconCodePoint: Icons.nightlight_outlined.codePoint,
    ),
  ];
}