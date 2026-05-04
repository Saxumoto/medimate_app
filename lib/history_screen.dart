import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'medication_data.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = Provider.of<MedicationProvider>(context).history;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, title: const Text("Activity History", style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold))),
      body: history.isEmpty 
        ? const Center(child: Text("No history yet! Take your meds to see them here."))
        : ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final med = history[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: Colors.white,
                child: ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: Text(med.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Completed at ${med.time}"),
                ),
              );
            },
          ),
    );
  }
}