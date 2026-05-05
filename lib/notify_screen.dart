import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'medication_data.dart';
import 'success_screen.dart';

class NotifyScreen extends StatefulWidget {
  final String payload; // Expecting the Medication ID

  const NotifyScreen({super.key, required this.payload});

  @override
  State<NotifyScreen> createState() => _NotifyScreenState();
}

class _NotifyScreenState extends State<NotifyScreen> {
  Medication? _medication;

  @override
  void initState() {
    super.initState();
    // Load medication immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MedicationProvider>(context, listen: false);
      try {
        final med = provider.medications.firstWhere((m) => m.id == widget.payload);
        setState(() {
          _medication = med;
        });
      } catch (e) {
        // Medication not found, might have been deleted. Dismiss alarm.
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_medication == null) {
      return const Scaffold(backgroundColor: Color(0xFF4B55D6), body: Center(child: CircularProgressIndicator(color: Colors.white)));
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4B55D6), Color(0xFF312E81)], // Indigo to Dark Slate
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const Icon(Icons.notifications_active, size: 100, color: Colors.white),
                const SizedBox(height: 32),
                Text(
                  "Time to take your ${_medication!.name}",
                  style: const TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  "${_medication!.dosage} • ${_medication!.time}",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (_medication!.notes.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Notes: ${_medication!.notes}",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                const Spacer(),
                
                // I've Taken It Button
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF22C55E), // Success Green
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      final provider = Provider.of<MedicationProvider>(context, listen: false);
                      // Set status to true (taken) if not already
                      if (!_medication!.status) {
                        await provider.toggleStatus(_medication!.id);
                      }
                      
                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const SuccessScreen()),
                        );
                      }
                    },
                    child: const Text("I've Taken It", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 16),

                // Snooze Button
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1E293B),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      // Basic snooze functionality: Just dismiss the alert for now. 
                      // In a full app, we would re-schedule the notification +10 minutes.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Alarm snoozed")),
                      );
                      Navigator.pop(context);
                    },
                    child: const Text("Snooze", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}