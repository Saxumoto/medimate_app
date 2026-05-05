import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'medication_data.dart';

class NotificationCenterScreen extends StatefulWidget {
  const NotificationCenterScreen({super.key});

  @override
  State<NotificationCenterScreen> createState() => _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends State<NotificationCenterScreen> {
  int _selectedFilterIndex = 0;

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4B55D6);
    final medProvider = Provider.of<MedicationProvider>(context);

    // Filter logic
    final now = DateTime.now();
    final allPending = medProvider.medications.where((m) => m.status == false).toList();
    
    final missedMeds = allPending.where((m) => m.scheduledDateTime.isBefore(now)).toList();
    final upcomingMeds = allPending.where((m) => m.scheduledDateTime.isAfter(now) && m.scheduledDateTime.day == now.day).toList();

    List<Medication> displayMeds = [];
    if (_selectedFilterIndex == 0) { // All
      displayMeds = [...missedMeds, ...upcomingMeds];
    } else if (_selectedFilterIndex == 1) { // Missed
      displayMeds = missedMeds;
    } else if (_selectedFilterIndex == 2) { // Upcoming
      displayMeds = upcomingMeds;
    }

    // Sort so most recently missed or soonest upcoming are top
    displayMeds.sort((a, b) => a.scheduledDateTime.compareTo(b.scheduledDateTime));

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Notifications",
          style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            color: Colors.white,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => _selectedFilterIndex = 0),
                  child: _buildFilterChip("All", _selectedFilterIndex == 0, primaryColor),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => setState(() => _selectedFilterIndex = 1),
                  child: _buildFilterChip("Missed", _selectedFilterIndex == 1, primaryColor),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => setState(() => _selectedFilterIndex = 2),
                  child: _buildFilterChip("Upcoming", _selectedFilterIndex == 2, primaryColor),
                ),
              ],
            ),
          ),
          
          // Notification List
          Expanded(
            child: displayMeds.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_off, size: 80, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text("No active alerts", style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      Text("You're all caught up!", style: TextStyle(color: Colors.grey[500])),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20.0),
                  itemCount: displayMeds.length,
                  itemBuilder: (context, index) {
                    final med = displayMeds[index];
                    final isMissed = med.scheduledDateTime.isBefore(now);

                    return _buildNotificationCard(
                      icon: isMissed ? Icons.warning_amber_rounded : Icons.access_time,
                      iconColor: isMissed ? const Color(0xFFEF4444) : primaryColor,
                      title: isMissed ? "Missed Medication" : "Upcoming Medication",
                      message: isMissed 
                        ? "You missed your ${med.name} at ${med.time}."
                        : "It's almost time to take your ${med.name} at ${med.time}.",
                      time: med.time,
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, Color primaryColor) {
    return Chip(
      label: Text(label),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : const Color(0xFF64748B),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: isSelected ? primaryColor : const Color(0xFFF1F5F9),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget _buildNotificationCard({required IconData icon, required Color iconColor, required String title, required String message, required String time}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0).withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B))),
                    Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(message, style: const TextStyle(color: Color(0xFF64748B), fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}