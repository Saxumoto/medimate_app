import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'main.dart'; // For navigatorKey
import 'notify_screen.dart';
import 'medication_data.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();
    
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
    final scheduledDate = tz.TZDateTime.from(med.scheduledDateTime, tz.local);

    await _notificationsPlugin.zonedSchedule(
      id: med.id.hashCode,
      title: 'MediMate Reminder',
      body: 'Time to take your ${med.name} (${med.dosage})',
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'med_reminder_channel',
          'Medication Reminders',
          channelDescription: 'Daily notifications for your medication schedule.',
          importance: Importance.max,
          priority: Priority.high,
          fullScreenIntent: true, // Ideal for alarms
        ),
        iOS: DarwinNotificationDetails(
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