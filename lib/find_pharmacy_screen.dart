import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class FindPharmacyScreen extends StatefulWidget {
  const FindPharmacyScreen({super.key});

  @override
  State<FindPharmacyScreen> createState() => _FindPharmacyScreenState();
}

class _FindPharmacyScreenState extends State<FindPharmacyScreen> {
  bool _isLoading = true;
  bool _isPermissionGranted = false;
  bool _isPermanentlyDenied = false;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    setState(() {
      _isLoading = true;
    });

    final status = await Permission.location.request();
    
    setState(() {
      _isPermissionGranted = status.isGranted;
      _isPermanentlyDenied = status.isPermanentlyDenied;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          "Find Pharmacy",
          style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search for pharmacies...",
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    )
                  : _isPermissionGranted
                      ? Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0E7FF),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.map_rounded, size: 80, color: primaryColor),
                              SizedBox(height: 16),
                              Text(
                                "Location securely acquired.",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF1E293B),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Map loading...",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _isPermanentlyDenied ? Icons.settings_suggest : Icons.location_off_rounded,
                                size: 80,
                                color: Colors.red[300],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _isPermanentlyDenied
                                    ? "Permission Permanently Denied"
                                    : "Location Permission Required",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFFEF4444),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _isPermanentlyDenied
                                    ? "Please enable location permissions in your phone settings to use this feature."
                                    : "We need your location to find nearby pharmacies.",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.red[300]),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFEF4444),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: () {
                                  if (_isPermanentlyDenied) {
                                    openAppSettings();
                                  } else {
                                    _requestLocationPermission();
                                  }
                                },
                                child: Text(
                                  _isPermanentlyDenied ? "Open Settings" : "Grant Permission",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
