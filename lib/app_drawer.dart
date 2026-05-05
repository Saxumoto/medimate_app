import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_data.dart';
import 'login_screen.dart';
import 'find_pharmacy_screen.dart';
import 'help_support_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final profile = userProvider.profile;
    const primaryColor = Color(0xFF4B55D6);

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header
            Container(
              padding: const EdgeInsets.all(24.0),
              width: double.infinity,
              color: primaryColor.withValues(alpha: 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    backgroundImage: profile != null && profile.profileImage.isNotEmpty
                        ? FileImage(File(profile.profileImage))
                        : null,
                    child: profile == null || profile.profileImage.isEmpty
                        ? const Icon(Icons.person, size: 30, color: primaryColor)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    profile?.name ?? "User",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile?.email ?? "No email",
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Navigation Links
            _buildDrawerItem(
              icon: Icons.home_outlined,
              text: 'Home',
              onTap: () => Navigator.pop(context),
            ),
            _buildDrawerItem(
              icon: Icons.medical_services_outlined,
              text: 'Find Pharmacy',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FindPharmacyScreen()),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.contact_phone_outlined,
              text: 'Emergency Contacts',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Emergency contacts coming soon!")));
              },
            ),
            const Divider(color: Color(0xFFF1F5F9), indent: 24, endIndent: 24),
            _buildDrawerItem(
              icon: Icons.help_outline,
              text: 'Help & Support',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
                );
              },
            ),

            const Spacer(),

            // Logout Button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFEF4444),
                  side: const BorderSide(color: Color(0xFFEF4444)),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text("Log Out", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({required IconData icon, required String text, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF64748B)),
      title: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF1E293B),
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
    );
  }
}