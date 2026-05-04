import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'medication_data.dart';
import 'splash_screen.dart';

void main() async {
  // Required to interact with native platform channels (like SQLite) before runApp
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MediMateApp());
}

class MediMateApp extends StatelessWidget {
  const MediMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MedicationProvider()..fetchAndSetMedications(),
        ),
      ],
      child: MaterialApp(
        title: 'MediMate',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Using the custom indigo-based color palette
          primaryColor: const Color(0xFF4B55D6),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4B55D6),
            primary: const Color(0xFF4B55D6),
          ),
          useMaterial3: true,
          fontFamily: 'Roboto', 
        ),
        home: const SplashScreen(), 
      ),
    );
  }
}