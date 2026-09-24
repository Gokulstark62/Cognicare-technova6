import 'package:flutter/material.dart';
import '../models/appointment.dart';

List<Appointment> getSampleAppointments() {
  final now = DateTime.now();

  return [
    Appointment(
      id: 'a1',
      doctorName: 'Dr. Sharma',
      specialty: 'Cardiologist',
      dateTime: now.add(const Duration(days: 4, hours: 2)),
      location: 'Apollo Clinic',
      notes: 'Bring previous ECG reports',
      iconCodePoint: Icons.favorite_outline.codePoint,
    ),
    Appointment(
      id: 'a2',
      doctorName: 'Dr. Mehta',
      specialty: 'Dentist',
      dateTime: now.add(const Duration(days: 11, hours: 5)),
      location: 'Smile Dental',
      notes: 'Routine cleaning',
      iconCodePoint: Icons.medical_services_outlined.codePoint,
    ),
    Appointment(
      id: 'a3',
      doctorName: 'Dr. Rao',
      specialty: 'General Physician',
      dateTime: now.subtract(const Duration(days: 5)),
      location: 'City Hospital',
      notes: 'Annual checkup — completed',
      iconCodePoint: Icons.local_hospital_outlined.codePoint,
    ),
  ];
}