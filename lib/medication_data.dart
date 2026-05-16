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
  Map<String, List<String>> _dailyLogs = {}; // date_string -> list of taken med ids
  DateTime _selectedDate = DateTime.now();

  List<Medication> get medications => _medications;
  DateTime get selectedDate => _selectedDate;

  String _formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  bool isMedicationTaken(String medId, DateTime date) {
    final dateStr = _formatDate(date);
    return _dailyLogs[dateStr]?.contains(medId) ?? false;
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  // History list: filters out medications that have been marked as taken FOR SELECTED DATE
  List<Medication> get history {
    final dateStr = _formatDate(_selectedDate);
    final takenIds = _dailyLogs[dateStr] ?? [];
    return _medications.where((med) => takenIds.contains(med.id)).toList();
  }

  // Pending list: filters out medications that have not been taken FOR SELECTED DATE
  List<Medication> get pending {
    final dateStr = _formatDate(_selectedDate);
    final takenIds = _dailyLogs[dateStr] ?? [];
    return _medications.where((med) => !takenIds.contains(med.id)).toList();
  }

  // Fetch data from the database and update the UI
  Future<void> fetchAndSetMedications() async {
    final dataList = await DatabaseHelper.instance.readAllMedications();
    _medications = dataList;

    final allLogs = await DatabaseHelper.instance.getAllLogs();
    _dailyLogs = {};
    for (var log in allLogs) {
      final date = log['date'] as String;
      final medId = log['medicationId'] as String;
      final status = log['status'] as int;
      if (status == 1) {
        if (!_dailyLogs.containsKey(date)) {
          _dailyLogs[date] = [];
        }
        _dailyLogs[date]!.add(medId);
      }
    }
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
  Future<void> toggleStatus(String id, {DateTime? date}) async {
    final targetDate = date ?? DateTime.now();
    final dateStr = _formatDate(targetDate);
    final currentlyTaken = isMedicationTaken(id, targetDate);
    final newStatus = !currentlyTaken;

    await DatabaseHelper.instance.saveLog(id, dateStr, newStatus);

    if (newStatus) {
      if (!_dailyLogs.containsKey(dateStr)) {
        _dailyLogs[dateStr] = [];
      }
      if (!_dailyLogs[dateStr]!.contains(id)) {
        _dailyLogs[dateStr]!.add(id);
      }
    } else {
      _dailyLogs[dateStr]?.remove(id);
    }

    notifyListeners();
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