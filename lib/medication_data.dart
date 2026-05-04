import 'package:flutter/material.dart';

class Medication {
  final String id;
  final String name;
  final String dosage;
  final String time;
  final String type;
  bool isTaken;
  final DateTime date;

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.time,
    required this.type,
    this.isTaken = false,
    required this.date,
  });
}

class MedicationProvider extends ChangeNotifier {
  final List<Medication> _meds = [
    Medication(id: '1', name: "Vitamin C", dosage: "500mg", time: "08:00 AM", type: "Pill", isTaken: true, date: DateTime.now()),
  ];

  List<Medication> get meds => _meds;
  List<Medication> get history => _meds.where((m) => m.isTaken).toList();

  void addMedication(Medication med) {
    _meds.add(med);
    notifyListeners();
  }

  void toggleStatus(String id) {
    final index = _meds.indexWhere((m) => m.id == id);
    if (index != -1) {
      _meds[index].isTaken = !_meds[index].isTaken;
      notifyListeners();
    }
  }
}