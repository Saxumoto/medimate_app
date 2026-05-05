# 📱 MediMate App: Master UI/UX & Routing Specification

## 1. Global Theme & Styling
*   **Primary Color:** Indigo/Purple (`Color(0xFF4B55D6)`). Used for primary buttons, active icons, selected states, and main app branding.
*   **Secondary/Status Colors:**
    *   **Success (Green):** `Color(0xFF22C55E)`. Used for "Taken" buttons, checkmarks, and success confirmations.
    *   **Destructive/Missed (Red):** `Color(0xFFEF4444)`. Used for "Missed" status, Delete buttons, and Log Out.
    *   **Warning/Upcoming (Yellow/Orange):** `Color(0xFFF59E0B)`. Used for upcoming notification states.
*   **Background Colors:**
    *   **App Background:** Solid White (`#FFFFFF`).
    *   **Splash/Alert Background:** Linear Gradient (light purple to solid Primary Indigo).
    *   **Card/Input Background:** Very light gray/transparent fill with subtle borders.
*   **Typography:** Modern Sans-Serif (e.g., Poppins or Roboto).
    *   **Headings:** Bold, High Contrast (Black/Dark Gray).
    *   **Subtitles/Body:** Regular weight, Medium Gray.
*   **Component Styling:**
    *   **Buttons:** Full-width, rounded corners (`borderRadius: 8.0` or `12.0`), no elevation.
    *   **Text Fields:** Outlined borders with rounded corners. Left-aligned icons for context, right-aligned for actions (password visibility).

---

## 2. Navigation Architecture & Routing Logic
The app utilizes a mix of stack navigation (`Navigator.push` / `pushReplacement`) for linear flows and a `BottomNavigationBar` for main app traversal.

### A. Authentication Flow (Stack Navigation)
*   **Splash Screen** -> Automatically routes to **Onboarding 1** after a delay.
*   **Onboarding (1 -> 2 -> 3)** -> User taps "Next" to progress. "Skip" routes directly to **Log In**. Screen 3 "Start" routes to **Log In**.
*   **Log In** <-> **Sign Up**: Cross-link between each other (e.g., "Don't have an account? Sign Up").
*   **Sign Up** (Success) -> routes to **Create Profile**.
*   **Log In** (Success) -> uses `pushReplacement` to **Home** (Main App Hub).
*   **Create Profile** (Save) -> uses `pushReplacement` to **Home**.

### B. Main App Hub (Bottom Navigation Bar)
The `BottomNavigationBar` controls 4 root views. Tapping an icon switches the active index without pushing a new screen.
1.  **Home** (Index 0)
2.  **Medications** (Index 1)
3.  **History** (Index 2)
4.  **Settings** (Index 3)

### C. Deep Routing (From Main Tabs)
*   **From Home:**
    *   Tap "+ Add Medication" -> `push` to **Add Medication**.
    *   Tap "Bell Icon" (Top Right) -> `push` to **Notifications Center**.
    *   Tap Medication Card -> `push` to **Medication Detail View**.
*   **From Medications:**
    *   Tap specific Medication -> opens **Medication Detail View**.
    *   From Detail View, tap "Edit" -> `push` to **Edit Meds**. (Save -> `pop` back to Detail).
    *   From Detail View, tap "Delete" -> shows **Delete Modal/Screen**. (Confirm -> `pop` back to Medications list).
*   **From History:**
    *   Tap "Calendar Icon" (Top Right) -> `push` to **Calendar** (Month View).
    *   Tap a specific date on Calendar -> routes to **Calendar 2** (Day Detail View).
*   **From Settings:**
    *   Tap "Profile" -> `push` to **Profile View**.
        *   From Profile View, tap "Edit Profile" -> `push` to **Edit Profile**. (Save -> `pop`).
    *   Tap Notification Toggles -> opens **Notification Settings**.
    *   Tap "Log Out" -> clears user session and `pushReplacement` back to **Log In**.

### D. System Overlays / Alerts
*   **Time to Take Meds (Notify 1):** Full-screen gradient alert triggered by time.
    *   Tap "I've Taken It" -> routes to **Notify 2 (Success)** -> `pop` to previous screen.
    *   Tap "Snooze" -> dismisses alert temporarily.

---

## 3. Screen-by-Screen Layout Data

### Home Dashboard (`HomeScreen`)
*   **Header:** Hamburger menu (left), Notification Bell (right, primary color). Greeting text "Good Morning, [Name]! 👋".
*   **Today's Schedule:** List of Medication Cards.
    *   **Card UI:** Light background, colored pill icon (left), Name & Dose (center), Time & "Take" solid primary button (right).
*   **Action:** "+ Add Medication" outlined button below the list.

### Medication Management (Add/Edit)
*   **App Bar:** Back chevron (`Icons.arrow_back_ios`), centered title.
*   **Inputs:** Name (Text), Dose (Text), Time (TimePicker), Frequency (Dropdown), Notes (Multiline).
*   **Action:** Full-width Primary Button ("Save").
*   **Success Screen:** White background, large green checkmark circle, summary text, primary button ("View My Medication").

### History & Tracking (`HistoryScreen`)
*   **App Bar:** Hamburger menu, "History" title, Calendar icon (right).
*   **List View:** Grouped by "Today" and "Yesterday".
*   **Card UI:** Status Icon (Green check for Taken, Red X for Missed), Time, Name, Dose, and colored status text (Right).

### Profile & Settings
*   **Profile Card:** Light purple background, circular avatar, Name, Email.
*   **Data Fields:** Key-value pairs for Full Name, Email, DOB, Gender, Phone, Address separated by faint dividers.
*   **Settings Menu:** List tiles with leading icons, trailing toggles (switches) or chevrons. Red outlined "Log Out" button at the bottom.