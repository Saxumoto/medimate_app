# MediMate 📱

**Stay on Track, Stay Healthy.**

MediMate is a modern medication tracking and health management app built with Flutter. It helps users manage their daily medication schedules with high-priority reminders, a beautiful calendar view, and secure local data persistence.

## ✨ Features

- **Daily Medication Tracking:** Log and monitor your medications with ease.
- **High-Priority Alarms:** Forced notifications that act as alarms, directing you to a dedicated "Taken/Snooze" screen.
- **Visual Calendar:** A full monthly calendar (using `table_calendar`) to visualize your medication history and future schedules.
- **Dynamic History:** Filter and view your medication logs by specific dates.
- **Pharmacy Finder:** Find nearby pharmacies with secure location permission handling.
- **Profile Management:** Secure local storage of your health profile and biometric preferences.
- **Privacy First:** All data is stored locally on your device using SQLite and SharedPreferences.

## 🛠️ Tech Stack

- **Framework:** Flutter (Dart)
- **State Management:** Provider
- **Local Database:** SQLite (sqflite)
- **Persistence:** Shared Preferences
- **Notifications:** Flutter Local Notifications & Timezone
- **Charts:** fl_chart
- **Permissions:** Permission Handler
- **Utilities:** url_launcher, intl

## 🚀 Getting Started

### Prerequisites

- Flutter SDK
- Android Studio / VS Code with Flutter extension
- An Android Emulator or physical device

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/medimate_app.git
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## 📦 Build

To generate an Android APK for distribution:

```bash
flutter build apk --release
```

The APK will be located at `build/app/outputs/flutter-apk/app-release.apk`.

---
Built with ❤️ for a healthier lifestyle.
