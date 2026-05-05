import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_data.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final profile = userProvider.profile;
    const primaryColor = Color(0xFF4B55D6);

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
          "Profile",
          style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Top Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: profile != null && profile.profileImage.isNotEmpty
                        ? FileImage(File(profile.profileImage))
                        : null,
                    child: profile == null || profile.profileImage.isEmpty
                        ? const Icon(Icons.person, size: 50, color: Color(0xFF4B55D6))
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    profile?.name ?? "User",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile?.email ?? "No email provided",
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Personal Details List
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Personal Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0).withValues(alpha: 0.5)),
              ),
              child: Column(
                children: [
                  _buildDetailRow("Full Name", profile?.name ?? "N/A"),
                  _buildDivider(),
                  _buildDetailRow("Email", profile?.email ?? "N/A"),
                  _buildDivider(),
                  _buildDetailRow("Date of Birth", profile?.dob ?? "N/A"),
                  _buildDivider(),
                  _buildDetailRow("Gender", profile?.gender ?? "N/A"),
                  _buildDivider(),
                  _buildDetailRow("Phone", profile != null && profile.phone.isNotEmpty ? profile.phone : "N/A"),
                  _buildDivider(),
                  _buildDetailRow("Address", profile != null && profile.address.isNotEmpty ? profile.address : "N/A"),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Edit Profile Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                  );
                },
                child: const Text(
                  "Edit Profile",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 16, endIndent: 16, color: Color(0xFFF1F5F9));
  }
}