import 'package:flutter/material.dart';
import '../models/medicine.dart';

/// Sample medicines for Phase 3.1 testing.
/// Phase 3.2 will let users add / edit / delete their own.
List<Medicine> getSampleMedicines() {
  return [
    Medicine(
      id: 'm1',
      name: 'Amlodipine',
      dosage: '5mg',
      purpose: 'Blood pressure',
      time: const TimeOfDay(hour: 8, minute: 0),
    ),
    Medicine(
      id: 'm2',
      name: 'Metformin',
      dosage: '500mg',
      purpose: 'Diabetes',
      time: const TimeOfDay(hour: 8, minute: 30),
    ),
    Medicine(
      id: 'm3',
      name: 'Vitamin D3',
      dosage: '1000 IU',
      purpose: 'Bone health',
      time: const TimeOfDay(hour: 13, minute: 0),
    ),
    Medicine(
      id: 'm4',
      name: 'Atorvastatin',
      dosage: '10mg',
      purpose: 'Cholesterol',
      time: const TimeOfDay(hour: 20, minute: 0),
    ),
    Medicine(
      id: 'm5',
      name: 'Melatonin',
      dosage: '3mg',
      purpose: 'Sleep aid',
      time: const TimeOfDay(hour: 22, minute: 0),
    ),
  ];
}