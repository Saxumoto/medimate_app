import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header / Profile Info
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xFFE2E8F0),
                    child: Icon(Icons.person, size: 50, color: Color(0xFF4B55D6)),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Alex Johnson",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const Text(
                    "alex.johnson@example.com",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            
            // Health Stats Row
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  _buildStatCard("Weight", "72", "kg"),
                  const SizedBox(width: 12),
                  _buildStatCard("Height", "175", "cm"),
                  const SizedBox(width: 12),
                  _buildStatCard("Blood", "O+", ""),
                ],
              ),
            ),

            // Menu Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildMenuTile(Icons.person_outline, "Edit Profile"),
                    _buildDivider(),
                    _buildMenuTile(Icons.notifications_none, "Notifications"),
                    _buildDivider(),
                    _buildMenuTile(Icons.security_outlined, "Privacy & Security"),
                    _buildDivider(),
                    _buildMenuTile(Icons.help_outline, "Help Center"),
                    _buildDivider(),
                    _buildMenuTile(Icons.logout, "Logout", isLogout: true, context: context),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, String unit) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B55D6),
                  ),
                ),
                if (unit.isNotEmpty) ...[
                  const SizedBox(width: 2),
                  Text(unit, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile(IconData icon, String title, {bool isLogout = false, BuildContext? context}) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : const Color(0xFF64748B)),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.red : const Color(0xFF1E293B),
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: isLogout ? null : const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {
        if (isLogout && context != null) {
          // Logic to return to login or clear session
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 20, endIndent: 20, color: Color(0xFFF1F5F9));
  }
}