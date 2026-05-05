import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'medication_data.dart';
import 'user_data.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _bootUpApp();
  }

  Future<void> _bootUpApp() async {
    try {
      // Capture providers before async gaps
      final medProvider = Provider.of<MedicationProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      // Fetch data in the background
      await medProvider.fetchAndSetMedications();
      await userProvider.fetchProfile();
      
      // Enforce the 3-second delay requested by the design
      await Future.delayed(const Duration(seconds: 3));

      if (mounted) {
        // Navigate to Onboarding screens as required
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()), 
        );
      }
    } catch (e) {
      debugPrint("🚨 CRITICAL ERROR DURING BOOT: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFB58CFF), // Light Purple
              Color(0xFF4B55D6), // Primary Indigo
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            
            // Tilted Pill Icon
            Transform.rotate(
              angle: 0.5, // Slight tilt
              child: const Icon(
                Icons.medication,
                size: 100,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            
            // Title
            const Text(
              'MediMate',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            
            // Subtitle
            const Text(
              'STAY ON TRACK, STAY HEALTHY.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white70,
                letterSpacing: 2.0,
              ),
            ),
            
            const Spacer(),
            
            // Progress Bar
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 40.0),
              child: LinearProgressIndicator(
                color: Colors.white,
                backgroundColor: Colors.white30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}