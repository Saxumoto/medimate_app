import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'medication_data.dart';
import 'add_medication_screen.dart';
import 'profile_screen.dart';
import 'statistics_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Fetch meds from the database when the app opens
    Future.delayed(Duration.zero, () {
      Provider.of<MedicationProvider>(context, listen: false).fetchAndSetMeds();
    });
  }

  @override
  Widget build(BuildContext context) {
    final medProvider = Provider.of<MedicationProvider>(context);
    
    final List<Widget> screens = [
      _buildDashboardBody(medProvider),
      const StatisticsScreen(),
      const HistoryScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _selectedIndex == 0 ? AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Hello, Alex 👋", style: TextStyle(color: Color(0xFF1E293B), fontSize: 20, fontWeight: FontWeight.bold)),
          Text("Your daily health summary", style: TextStyle(color: Colors.grey, fontSize: 14)),
        ]),
      ) : null,
      body: IndexedStack(index: _selectedIndex, children: screens),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddMedicationScreen())),
        backgroundColor: const Color(0xFF4B55D6),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          IconButton(icon: Icon(Icons.home, color: _selectedIndex == 0 ? const Color(0xFF4B55D6) : Colors.grey), onPressed: () => setState(() => _selectedIndex = 0)),
          IconButton(icon: Icon(Icons.insert_chart_outlined, color: _selectedIndex == 1 ? const Color(0xFF4B55D6) : Colors.grey), onPressed: () => setState(() => _selectedIndex = 1)),
          const SizedBox(width: 48),
          IconButton(icon: Icon(Icons.history, color: _selectedIndex == 2 ? const Color(0xFF4B55D6) : Colors.grey), onPressed: () => setState(() => _selectedIndex = 2)),
          IconButton(icon: Icon(Icons.person_outline, color: _selectedIndex == 3 ? const Color(0xFF4B55D6) : Colors.grey), onPressed: () => setState(() => _selectedIndex = 3)),
        ]),
      ),
    );
  }

  Widget _buildDashboardBody(MedicationProvider provider) {
    return provider.meds.isEmpty 
      ? const Center(child: Text("No medications added yet. Tap + to start!"))
      : ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text("Today's Medications", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...provider.meds.map((med) => _buildMedCard(med, provider)).toList(),
          ],
        );
  }

  Widget _buildMedCard(Medication med, MedicationProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(children: [
        const Icon(Icons.medication, color: Color(0xFFB58CFF), size: 28),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(med.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text("${med.dosage} • ${med.time}", style: const TextStyle(color: Colors.grey)),
        ])),
        // Status Checkbox
        IconButton(
          icon: Icon(med.isTaken ? Icons.check_circle : Icons.radio_button_unchecked, color: med.isTaken ? const Color(0xFF4B55D6) : Colors.grey),
          onPressed: () => provider.toggleStatus(med.id),
        ),
        // Delete Button
        IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
          onPressed: () => provider.deleteMedication(med.id),
        ),
      ]),
    );
  }
}