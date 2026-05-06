import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceProvider with ChangeNotifier {
  static const String _notificationsKey = 'notifications_enabled';
  static const String _shareDataKey = 'share_diagnostic_data';
  static const String _biometricLoginKey = 'biometric_login';

  bool _notificationsEnabled = true;
  bool _shareDiagnosticData = false;
  bool _biometricLogin = false;

  bool get notificationsEnabled => _notificationsEnabled;
  bool get shareDiagnosticData => _shareDiagnosticData;
  bool get biometricLogin => _biometricLogin;

  PreferenceProvider() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _notificationsEnabled = prefs.getBool(_notificationsKey) ?? true;
    _shareDiagnosticData = prefs.getBool(_shareDataKey) ?? false;
    _biometricLogin = prefs.getBool(_biometricLoginKey) ?? false;
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool value) async {
    _notificationsEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, value);
    notifyListeners();
  }

  Future<void> setShareDiagnosticData(bool value) async {
    _shareDiagnosticData = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_shareDataKey, value);
    notifyListeners();
  }

  Future<void> setBiometricLogin(bool value) async {
    _biometricLogin = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricLoginKey, value);
    notifyListeners();
  }
}
