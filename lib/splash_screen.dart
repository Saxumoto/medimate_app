import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // We don't need an AppBar here, just the full screen body
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          // 1. The Background Gradient
          gradient: LinearGradient(
            colors: [
              Color(0xFFB58CFF), // Lighter top purple (Approximated from Figma)
              Color(0xFF4B55D6), // Darker bottom indigo
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            
            // 2. The Logo Placeholder
            // (I used a tilted default icon for now. We will replace this 
            // with your actual exported Figma pill image later!)
            Transform.rotate(
              angle: -0.5,
              child: const Icon(
                Icons.medication, 
                size: 90,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),

            // 3. App Title
            const Text(
              'MediMate',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 16),

            // 4. Tagline
            const Text(
              'STAY ON TRACK,\nSTAY HEALTHY.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 2.0, // Spreads the letters out like your design
                height: 1.6, // Adds line spacing
              ),
            ),
            
            const Spacer(flex: 2),

            // 5. The Progress Bar
            Container(
              width: 160,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3), // Faded white background
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.centerLeft,
              child: Container(
                width: 60, // The solid white "progress" part
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            
            const Spacer(),
          ],
        ),
      ),
    );
  }
}