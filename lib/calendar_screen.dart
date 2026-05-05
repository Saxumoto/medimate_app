import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4B55D6);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Calendar", style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_month, size: 80, color: primaryColor.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            const Text("Month View", style: TextStyle(fontSize: 24, color: Color(0xFF1E293B), fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Detailed calendar functionality will be added here.", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}