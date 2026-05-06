import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'preference_provider.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4B55D6);
    final prefProvider = Provider.of<PreferenceProvider>(context);

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
          "Privacy & Security",
          style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Security Settings",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text("Share Diagnostic Data", style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.w500)),
                    subtitle: const Text("Help us improve the app", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    activeThumbColor: primaryColor,
                    value: prefProvider.shareDiagnosticData,
                    onChanged: (val) => prefProvider.setShareDiagnosticData(val),
                  ),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  SwitchListTile(
                    title: const Text("Biometric Login", style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.w500)),
                    subtitle: const Text("Use fingerprint or face unlock", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    activeThumbColor: primaryColor,
                    value: prefProvider.biometricLogin,
                    onChanged: (val) => prefProvider.setBiometricLogin(val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              "Privacy Policy",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Text(
                "Your privacy is critically important to us. At MediMate, we have a few fundamental principles:\n\n"
                "• We don't ask you for personal information unless we truly need it.\n"
                "• We don't share your personal information with anyone except to comply with the law, develop our products, or protect our rights.\n"
                "• We don't store personal information on our servers unless required for the on-going operation of one of our services.\n\n"
                "If you have questions about deleting or correcting your personal data please contact our support team.",
                style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
