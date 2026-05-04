import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'medication_data.dart';
import 'package:intl/intl.dart';

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  String _time = "08:00 AM";
  String _type = "Pill";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Add Medication"), centerTitle: true, elevation: 0, backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(children: [
          TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Medication Name")),
          const SizedBox(height: 16),
          TextField(controller: _dosageController, decoration: const InputDecoration(labelText: "Dosage (e.g. 500mg)")),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4B55D6), foregroundColor: Colors.white),
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  Provider.of<MedicationProvider>(context, listen: false).addMedication(
                    Medication(
                      id: DateTime.now().toString(),
                      name: _nameController.text,
                      dosage: _dosageController.text,
                      time: _time,
                      type: _type,
                      date: DateTime.now(),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text("Save Medication"),
            ),
          )
        ]),
      ),
    );
  }
}