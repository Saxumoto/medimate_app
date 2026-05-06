import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'main.dart'; // For navigatorKey
import 'notify_screen.dart';
import 'medication_data.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  static const MethodChannel _channel = MethodChannel('com.example.medimate_app/alarm_uri');
  static String? _alarmUri;

  static Future<void> init() async {
    tz.initializeTimeZones();
    
    // Fetch system alarm URI
    try {
      _alarmUri = await _channel.invokeMethod<String>('getAlarmUri');
    } catch (e) {
      debugPrint("Failed to get alarm URI: $e");
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false, // We request manually later
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload != null) {
          // Route to the Active Alarm screen using the global navigator key
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (context) => NotifyScreen(payload: response.payload!),
            ),
          );
        }
      },
    );

    // Handle initial notification if the app was launched by tapping it
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await _notificationsPlugin.getNotificationAppLaunchDetails();
    
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      final response = notificationAppLaunchDetails!.notificationResponse;
      if (response?.payload != null) {
        // Delay slightly to ensure navigator is ready
        Future.delayed(const Duration(seconds: 1), () {
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (context) => NotifyScreen(payload: response!.payload!),
            ),
          );
        });
      }
    }
  }

  static Future<void> requestPermissions() async {
    // Request Android 13+ permissions
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
      await androidImplementation.requestExactAlarmsPermission();
    }

    // Request iOS permissions
    final IOSFlutterLocalNotificationsPlugin? iosImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    
    if (iosImplementation != null) {
      await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  // Re-designed to accept the full Medication object to pass its ID as payload
  static Future<void> scheduleDailyNotification(Medication med) async {
    DateTime scheduledDateTime = med.scheduledDateTime;
    final now = DateTime.now();
    
    // If the time has already passed today, schedule for tomorrow
    if (scheduledDateTime.isBefore(now)) {
      scheduledDateTime = scheduledDateTime.add(const Duration(days: 1));
    }

    final scheduledDate = tz.TZDateTime.from(scheduledDateTime, tz.local);

    await _notificationsPlugin.zonedSchedule(
      id: med.id.hashCode,
      title: 'MediMate Reminder',
      body: 'Time to take your ${med.name} (${med.dosage})',
      scheduledDate: scheduledDate,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'med_reminder_channel_v2', // Changed ID to ensure new settings (sound) take effect
          'Medication Alarms',
          channelDescription: 'High-priority alarms for your medication schedule.',
          importance: Importance.max,
          priority: Priority.max,
          fullScreenIntent: true,
          category: AndroidNotificationCategory.alarm,
          audioAttributesUsage: AudioAttributesUsage.alarm,
          sound: _alarmUri != null ? UriAndroidNotificationSound(_alarmUri!) : null,
          playSound: true,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time, // Repeats daily at the same time
      payload: med.id, // We pass the medication ID so we can look it up when tapped
    );
  }

  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id: id);
  }
}