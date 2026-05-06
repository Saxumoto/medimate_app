import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';
import 'notification_service.dart';

class Medication {
  final String id;
  final String name;
  final String dosage;
  final String time;
  final String type;
  bool status;
  final String frequency;
  final String notes;

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.time,
    required this.type,
    this.status = false,
    this.frequency = "Daily",
    this.notes = "",
  });

  // Helper to parse time string (e.g. "08:00 AM") to DateTime for today
  DateTime get scheduledDateTime {
    final now = DateTime.now();
    try {
      final timeOfDay = DateFormat.jm().parse(time);
      return DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    } catch (e) {
      // Fallback to 8 AM if parsing fails
      return DateTime(now.year, now.month, now.day, 8, 0);
    }
  }

  // Convert a Medication object into a Map for SQLite.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'time': time,
      'type': type,
      'status': status ? 1 : 0, // Convert boolean to integer for SQLite
      'frequency': frequency,
      'notes': notes,
    };
  }

  // Extract a Medication object from a Map from SQLite.
  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id'],
      name: map['name'],
      dosage: map['dosage'],
      time: map['time'],
      type: map['type'],
      status: map['status'] == 1, // Convert integer back to boolean
      frequency: map['frequency'] ?? "Daily",
      notes: map['notes'] ?? "",
    );
  }
}

class MedicationProvider with ChangeNotifier {
  List<Medication> _medications = [];
  DateTime _selectedDate = DateTime.now();

  List<Medication> get medications => _medications;
  DateTime get selectedDate => _selectedDate;

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  // History list: filters out medications that have been marked as taken
  List<Medication> get history =>
      _medications.where((med) => med.status == true).toList();

  // Pending list: filters out medications that have not been taken
  List<Medication> get pending =>
      _medications.where((med) => med.status == false).toList();

  // Fetch data from the database and update the UI
  Future<void> fetchAndSetMedications() async {
    final dataList = await DatabaseHelper.instance.readAllMedications();
    _medications = dataList;
    notifyListeners();
  }

  // Add new med to database, then to UI
  Future<void> addMedication(Medication medication) async {
    await DatabaseHelper.instance.create(medication);
    _medications.add(medication);
    
    // Schedule notification
    await NotificationService.scheduleDailyNotification(medication);

    notifyListeners();
  }

  // Update existing med in database and UI
  Future<void> updateMedication(Medication medication) async {
    await DatabaseHelper.instance.update(medication);
    final index = _medications.indexWhere((m) => m.id == medication.id);
    if (index != -1) {
      _medications[index] = medication;
      
      // Re-schedule notification
      await NotificationService.cancelNotification(medication.id.hashCode);
      await NotificationService.scheduleDailyNotification(medication);
      
      notifyListeners();
    }
  }

  // Toggle "Taken" status in database, then update UI
  Future<void> toggleStatus(String id) async {
    final medIndex = _medications.indexWhere((med) => med.id == id);
    if (medIndex >= 0) {
      _medications[medIndex].status = !_medications[medIndex].status;
      await DatabaseHelper.instance.update(_medications[medIndex]);
      notifyListeners();
    }
  }

  // Delete from database, then update UI
  Future<void> deleteMedication(String id) async {
    await DatabaseHelper.instance.delete(id);
    _medications.removeWhere((med) => med.id == id);
    
    // Cancel notification
    await NotificationService.cancelNotification(id.hashCode);

    notifyListeners();
  }
}